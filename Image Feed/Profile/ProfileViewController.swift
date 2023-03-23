//
//  ProfileViewController.swift
//  Image Feed
//
//  Created by Denis on 10.01.2023.
//

import Foundation
import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?

    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Avatar")
        imageView.clipsToBounds = true
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
        self.view.backgroundColor = .ypBlack
        addSubViews()
        applyConstraints()
        
        profileImageServiceObserver = NotificationCenter.default    // 2
                    .addObserver(
                        forName: ProfileImageService.didChangeNotification, // 3
                        object: nil,                                        // 4
                        queue: .main                                        // 5
                    ) { [weak self] _ in
                        guard let self = self else { return }
                        self.updateAvatar()                                 // 6
                    }
                updateAvatar()                                              // 7
        
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }
    }
    
    private func updateAvatar() {
        guard
            let profileImageUrl = profileImageService.avatarURL,
            let url = URL(string: profileImageUrl)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 35.0)
        avatarImageView.kf.setImage(with: url, placeholder: UIImage(named: "DefaultAvatar"), options: [.processor(processor)])
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
    
    
    @objc func didTapLogoutButton() {
        let alert = UIAlertController(
            title: "Выйти из профиля",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { _ in
            OAuth2TokenStorage().token = nil
            WebCacheCleaner.clean()
            guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")}
            let splashViewController = SplashViewController()
            window.rootViewController = splashViewController
        })
        )
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        present(alert, animated: true)
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

