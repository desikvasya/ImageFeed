//
//  Oath2TokenStorage.swift
//  Image Feed
//
//  Created by Denis on 05.02.2023.
//

import Foundation
import SwiftKeychainWrapper


protocol OAuth2TokenStorageProtocol {
    var token: String? {get set}
}
final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    private enum Keys: String {
        case token
    }
    
    private let keychainWrapper = KeychainWrapper.standard
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: Keys.token.rawValue)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: Keys.token.rawValue)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Keys.token.rawValue)
            }
        }
    }
}
