//
//  Constants.swift
//  Image Feed
//
//  Created by Denis on 24.01.2023.
//

import Foundation

struct Constants {
    static let accessKey = "9JfQB7nGwFMCy2VbNfejIewCXKgnopIY8F_xLejNvuY"
    static let secretKey = "AHFDOFodhpa1WQZ-mixA4Z4apDu29lN8Ew9_fze7hdc"
    static let redirectUri = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseUrl = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey, secretKey: Constants.secretKey, redirectURI: Constants.redirectUri, accessScope: Constants.accessScope, defaultBaseURL: Constants.defaultBaseUrl, authURLString: Constants.unsplashAuthorizeURLString)
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
}

public struct NoReply: Decodable {}
public struct LikeResult: Decodable {}

