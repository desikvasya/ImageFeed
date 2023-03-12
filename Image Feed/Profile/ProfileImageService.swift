////
////  ProfileImageService.swift
////  Image Feed
////
////  Created by Denis on 18.02.2023.
////
//
//import Foundation
//
//protocol ProfileImageServiceProtocol {
//    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void)
//    var avatarURL: String? {get}
//}
//
//final class ProfileImageService {
//    static let sharedd = ProfileImageService()
//    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
//
//
//    var avatarURL: String? {
//        get {
//            return tempAvatarURL
//        }
//        set {
//            tempAvatarURL = newValue
//        }
//
//        func fetchProfileImageURL(username: String, completion: @escaping (Result<UserResult, Error>) -> Void)
//        if let token = storage.token
//            var request = URLRequest.authTokenRequest(path: "users/\(username)", httpMethod: "GET")
//            request.setValue("Bearer\(token)", forHTTPHeaderField: "Authorization")
//
//            let task = URLSession.objsectTask(for: request) {
//            [weak self] (result: Result<String, Error>) in
//            guard let self else {return}
//            switch result
//        case .success(let UserResult):
//            self.avatarURL = UserResult.ProfileImage.medium
//
//            if let avatarURL = self.avatarURL {
//                NotificationCenter.default.post(
//                    name: ProfileImageService.didChangeNotification,
//                    object: self,
//                    userInfo: ["URL": avatarURL])
//            }
//
//            completion(.success(UserResult))
//            print("got image")
//        case .failure:
//            print("didn't receive the image")
//        }
//    }
//}
