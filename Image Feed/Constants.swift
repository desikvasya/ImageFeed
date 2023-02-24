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
