//
//  ImageListService.swift
//  Image Feed
//
//  Created by Denis on 12.03.2023.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask? = nil
    private var nextPage = 0
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    func fetchPhotosNextPage() {
            print(lastLoadedPage as Any)

            // Проверяем, не выполняется ли уже задача
            guard lastTask == nil else { return }

            var request = URLRequest.makeRequest(path: "photos?page=\(nextPage)", httpMethod: "GET")
            if let token = OAuth2TokenStorage().token {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            print(photos.count)

            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<Array<PhotoResult>, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let photoResult):
                    for i in photoResult.indices {
                        let createdAt = photoResult[i].createdAt
                        let dateFormatter = ISO8601DateFormatter()
                        let date = dateFormatter.date(from: createdAt)
                        self.photos.append(
                            Photo(
                                id: photoResult[i].id,
                                size: CGSize(width: photoResult[i].width, height: photoResult[i].height),
                                createdAt: date,
                                welcomeDescription: photoResult[i].welcomeDescription,
                                thumbImageURL: photoResult[i].urls.thumbImageURL,
                                largeImageURL: photoResult[i].urls.largeImageURL,
                                isLiked: photoResult[i].isLiked))
                    }
                    self.lastLoadedPage = self.nextPage
                    self.nextPage += 1 // увеличиваем переменную только при успешной загрузке

                    NotificationCenter.default.post (
                        name: ImagesListService.didChangeNotification,
                        object: self)
                    self.lastTask = nil

                case .failure(let error):
                    print(error.localizedDescription)
                    self.lastTask = nil
                }
            }
            lastTask = task
            print(photos.count)
            print(lastLoadedPage as Any)

            task.resume()

        // Дожидаемся окончания всех операций в сессии
        urlSession.finishTasksAndInvalidate()
    }
    
    
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<LikeResult, Error>) -> Void){
        assert(Thread.isMainThread)
        lastTask?.cancel()
        
        var request: URLRequest
        
        if isLike {
            request = URLRequest.makeRequest(path: "photos/\(photoId)/like", httpMethod: "POST")
            request.setValue("Bearer \(OAuth2TokenStorage().token!)", forHTTPHeaderField: "Authorization")
        }
        else {
            request = URLRequest.makeRequest(path: "photos/\(photoId)/like", httpMethod: "DELETE")
            request.setValue("Bearer \(OAuth2TokenStorage().token!)", forHTTPHeaderField: "Authorization")
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                if let index = self.photos.firstIndex(where: {$0.id == photoId}){
                    let photo = self.photos[index]
                    let newPhoto = Photo(id: photo.id,
                                         size: photo.size,
                                         createdAt: photo.createdAt,
                                         welcomeDescription: photo.welcomeDescription,
                                         thumbImageURL: photo.thumbImageURL,
                                         largeImageURL: photo.largeImageURL,
                                         isLiked: !photo.isLiked)
                    
                    // Заменяем элемент в массиве.
                    DispatchQueue.main.async {
                        self.photos[index] = newPhoto
                        completion(result)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(result)
            }
        }
        lastTask = task
        task.resume()
    }
}
