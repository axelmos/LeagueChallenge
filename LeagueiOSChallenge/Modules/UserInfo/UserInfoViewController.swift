//
//  UserInfoViewController.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 08/12/2025.
//

import UIKit

final class UserInfoViewController: UIViewController {

    private let viewModel: UserInfoViewModel

    private let avatarImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let emailLabel = UILabel()
    private let warningIcon = UIImageView(image: UIImage(systemName: "exclamationmark.triangle"))

    init(viewModel: UserInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        usernameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false

        emailLabel.font = .systemFont(ofSize: 18)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        warningIcon.tintColor = .systemRed
        warningIcon.translatesAutoresizingMaskIntoConstraints = false
        warningIcon.isHidden = true

        view.addSubview(avatarImageView)
        view.addSubview(usernameLabel)
        view.addSubview(emailLabel)
        view.addSubview(warningIcon)

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),

            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 16),
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            warningIcon.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 6),
            warningIcon.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor),
            warningIcon.widthAnchor.constraint(equalToConstant: 20),
            warningIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func configure() {
        usernameLabel.text = viewModel.username
        emailLabel.text = viewModel.email

        if let url = URL(string: viewModel.avatarUrl) {
            avatarImageView.load(url: url)
        }

        warningIcon.isHidden = viewModel.isEmailValid
    }
}
