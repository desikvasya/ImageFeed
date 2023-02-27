//
//  ProfileViewController.swift
//  Image Feed
//
//  Created by Denis on 10.01.2023.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?

    
    override init(nibName: String?, bundle: Bundle?) {
            super.init(nibName: nibName, bundle: bundle)
            addObserver()
        }
    
    required init?(coder: NSCoder) {
            super.init(coder: coder)
            addObserver()
        }
    
    deinit {
            removeObserver()
        }
    
    private func addObserver() {
            NotificationCenter.default.addObserver(                 // 1
                self,                                               // 2
                selector: #selector(updateAvatar(notification:)),   // 3
                name: ProfileImageService.didChangeNotification,    // 4
                object: nil)                                        // 5
        }
       
       private func removeObserver() {
            NotificationCenter.default.removeObserver(              // 6
                self,                                               // 7
                name: ProfileImageService.didChangeNotification,    // 8
                object: nil)                                        // 9
        }
       
        @objc                                                       // 10
        private func updateAvatar(notification: Notification) {     // 11
            guard
                isViewLoaded,                                       // 12
                let userInfo = notification.userInfo,               // 13
                let profileImageURL = userInfo["URL"] as? String,   // 14
                let url = URL(string: profileImageURL)              // 15
            else { return }
            
            // TODO [Sprint 11] Обновить аватар, используя Kingfisher
        }

    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "avatar")
        imageView.layer.cornerRadius = 35.0
        
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Екатерина Новикова"
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private var loginNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@ekaterina_nov"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, world!"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "logout_button"), for: .normal)
        button.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        applyConstraints()
        
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }
       
        if let avatarURL = ProfileImageService.shared.avatarURL,// 16
                   let url = URL(string: avatarURL) {                   // 17
                    // TODO [Sprint 11]  Обновить аватар, если нотификация
                    // была опубликована до того, как мы подписались.
                }
            }
    
    @objc func didTapLogoutButton() {
        print("didTapLogoutButton")
    }
    
    func addSubViews() {
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(loginNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(logoutButton)
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leftAnchor.constraint(equalTo: avatarImageView.leftAnchor),
            
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leftAnchor.constraint(equalTo: loginNameLabel.leftAnchor),
            
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56),
            logoutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -26)
        ])
    }
}

