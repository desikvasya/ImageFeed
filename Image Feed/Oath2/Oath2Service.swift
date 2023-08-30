//
//  Oath2Service.swift
//  Image Feed
//
//  Created by Denis on 05.02.2023.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private var lastCode: String?
    private var task: URLSessionTask?
  
    private (set) var authToken: String? { get {
        return OAuth2TokenStorage().token }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func fetchOAuthToken( _ code: String,
                          completion: @escaping (Result<String, Error>) -> Void ){
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        let request = makeRequest(code: code)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(authToken))
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                    self.lastCode = nil
                }
            }
        }
        task.resume()
        self.task = task
    }
}

    
    private func makeRequest(code: String) -> URLRequest {
        URLRequest.makeRequest(
            path: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectUri)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code", httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        ) }
// MARK: - HTTP Request
fileprivate let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
extension URLRequest {
    static func makeRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = DefaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!); request.httpMethod = httpMethod
        return request
    } }
// MARK: - Network Connection
enum NetworkError: Error {
    case httpStatusCode
    case urlRequestError(Error)
    case urlSessionError
    case notDecodeJson
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {
                completion(.failure(NetworkError.httpStatusCode))
            }
            guard let data = data else {
                return
            }
            do {
                let JSONtoStruct = try JSONDecoder().decode(T.self, from: data)
                completion(.success(JSONtoStruct))
            } catch {
                completion(.failure(NetworkError.notDecodeJson))
            }
        })
        return task
    }
}

//final class OAuth2Service {
//    static let shared = OAuth2Service()
//    private let urlSession = URLSession.shared
//    private var lastCode: String?
//    private var task: URLSessionTask?
//
//    private (set) var authToken: String? { get {
//        return OAuth2TokenStorage().token }
//        set {
//            OAuth2TokenStorage().token = newValue
//        }
//    }
//
//    func fetchOAuthToken( _ code: String,
//                          completion: @escaping (Result<String, Error>) -> Void ){
//        assert(Thread.isMainThread)
//        if lastCode == code { return }
//        task?.cancel()
//        lastCode = code
//        let request = makeRequest(code: code)
//        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let body):
//                    let authToken = body.accessToken
//                    self.authToken = authToken
//                    completion(.success(authToken))
//                    self.task = nil
//                case .failure(let error):
//                    completion(.failure(error))
//                    self.lastCode = nil
//                }
//            }
//        }
//        task.resume()
//        self.task = task
//    }
//}
//
//
//private func makeRequest(code: String) -> URLRequest {
//    URLRequest.makeRequest(
//        path: "/oauth/token"
//        + "?client_id=\(AuthConfiguration.standart.accessKey)"
//        + "&&client_secret=\(AuthConfiguration.standart.secretKey)"
//        + "&&redirect_uri=\(AuthConfiguration.standart.redirectURI)"
//        + "&&code=\(code)"
//        + "&&grant_type=authorization_code",
//        httpMethod: "POST",
//        baseURL: URL(string: "https://unsplash.com")!
//    )
//}

