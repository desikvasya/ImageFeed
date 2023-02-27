//
//  UserResult.swift
//  Image Feed
//
//  Created by Denis on 27.02.2023.
//

import Foundation
struct UserResult: Codable {
    let profileImage: ProfileImage
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

extension UserResult {
    struct ProfileImage: Codable {
        let small: String
        let medium: String
        let large: String
        
        private enum CodingKeys: String, CodingKey {
            case small
            case medium
            case large
        }
    }
}
