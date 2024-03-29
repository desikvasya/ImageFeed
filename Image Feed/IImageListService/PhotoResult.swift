//
//  PhotoResult.swift
//  Image Feed
//
//  Created by Denis on 12.03.2023.
//

import Foundation

struct PhotoResult: Codable {
    let urls: UrlsResult
    let id: String
    let height: Int
    let width: Int
    let createdAt: String
    let welcomeDescription: String?
    let isLiked: Bool
    
    private enum CodingKeys: String, CodingKey {
        case urls, id, width, height
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case isLiked = "liked_by_user"
    }
}

struct UrlsResult: Codable {
    let thumbImageURL: String
    let largeImageURL: String
    
    private enum CodingKeys: String, CodingKey {
        case thumbImageURL = "thumb"
        case largeImageURL = "full"
    }
}

struct LikePhotoResult: Decodable {
    let photo: PhotoResult
}
