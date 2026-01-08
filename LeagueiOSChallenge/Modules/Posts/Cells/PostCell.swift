//
//  PostCell.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 08/12/2025.
//

import UIKit

final class PostCell: UITableViewCell {

    static let reuseId = "PostCell"

    var onUserTapped: ((User) -> Void)?
    private var user: User?

    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 30
        iv.clipsToBounds = true
        iv.image = UIImage(systemName: "person.crop.circle")
        iv.isUserInteractionEnabled = true
        return iv
    }()

    private let usernameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.textColor = .systemBlue
        lbl.isUserInteractionEnabled = true
        return lbl
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 18)
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()

    private let bodyLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(with post: PostViewData) {
        user = post.user
        usernameLabel.text = post.user.username
        titleLabel.text = post.title
        bodyLabel.text = post.body

        // Load avatar
        Task { [weak self] in
            guard let self = self else { return }
            if let img = await ImageLoader.shared.loadImage(from: post.user.avatar) {
                await MainActor.run {
                    UIView.transition(
                        with: self.avatarImageView,
                        duration: 0.15,
                        options: .transitionCrossDissolve,
                        animations: {
                            self.avatarImageView.image = img
                        }
                    )
                }
            }
        }
    }
}

private extension PostCell {
    func setupUI() {

        // Gestures
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        let usernameTap = UITapGestureRecognizer(target: self, action: #selector(userTapped))

        avatarImageView.addGestureRecognizer(avatarTap)
        usernameLabel.addGestureRecognizer(usernameTap)

        // Stack View
        let stack = UIStackView(arrangedSubviews: [usernameLabel, titleLabel, bodyLabel])
        stack.axis = .vertical
        stack.spacing = 4

        contentView.addSubview(avatarImageView)
        contentView.addSubview(stack)

        // Constraints
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),

            stack.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    @objc func userTapped() {
        guard let user = user else { return }
        onUserTapped?(user)
    }
}
