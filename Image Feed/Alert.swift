//
//  Alert.swift
//  Image Feed
//
//  Created by Denis on 28.02.2023.
//

import Foundation
import UIKit

struct AlertPresenter {
    
    weak var viewController: UIViewController?
    func showAlert() {
        
        let alert = UIAlertController(
            title: "Что-то пошло не так", 
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: "OK",
            style: .default,
            handler: {action in})
        
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
    
}
