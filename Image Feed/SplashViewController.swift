//
//  SplashViewController.swift
//  Image Feed
//
//  Created by Denis on 05.02.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "auth_screen_logo")
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        addSubviews()
        applyConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oauth2Service.authToken {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.fetchProfile(token)
            }
        } else {
            let authViewController = AuthViewController()
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                UIBlockingProgressHUD.show()
                self.present(authViewController, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func addSubviews() {
        view.addSubview(imageView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_vc vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print(error.localizedDescription)
            }
        }
    }
    private func fetchProfile(_ token: String) {
            profileService.fetchProfile(token) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let profile):
                        self.profileImageService.fetchProfileImageURL(username: profile.username) { result in }
                        self.switchToTabBarController()
                        UIBlockingProgressHUD.dismiss()
                    case .failure:
                        let alert = AlertPresenter(viewController: self)
                        alert.showAlert()
                        UIBlockingProgressHUD.dismiss()
                        break
                    }
                }
            }
        }
    }


