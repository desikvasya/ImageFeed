//
//  ProfileViewController.swift
//  Image Feed
//
//  Created by Denis on 10.01.2023.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
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

