//
//  ProfileService.swift
//  Image Feed
//
//  Created by Denis on 24.02.2023.
//

import Foundation

protocol ProfileServiceProtocol {
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
    var profile: Profile? { get }
}

final class ProfileService: ProfileServiceProtocol {
    static let shared: ProfileServiceProtocol = ProfileService()

    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    private var tempProfile: Profile?
    
    var profile: Profile? {
        get {
            return tempProfile
        }
        set {
            tempProfile = newValue
        }
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        lastTask?.cancel()

        var request = URLRequest.makeHTTPRequest(path: "me", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let body):
                let profile = Profile(result: body)
                self.profile = profile
                completion(.success(profile))
                print("Данные профиля получены")
            case .failure(let error):
                print("Не удалось получить данные прфоиля")
                completion(.failure(error))
            }
        }
        task.resume()
        self.lastTask = task
    }
}
