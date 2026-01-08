//
//  PostsListViewController.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 08/12/2025.
//

import UIKit
import Combine

final class PostsListViewController: UIViewController {

    private let viewModel: PostsListViewModel
    private let isGuest: Bool

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let errorLabel = UILabel()
    private var cancellables = Set<AnyCancellable>()
    var onUserSelected: ((User) -> Void)?

    init(viewModel: PostsListViewModel, isGuest: Bool) {
        self.viewModel = viewModel
        self.isGuest = isGuest
        super.init(nibName: nil, bundle: nil)
        title = NSLocalizedString("POSTS", comment: "Posts")
    }

    required init?(coder: NSCoder) { fatalError()}

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupNavigation()
        setupTableView()
        setupLoadingAndErrorViews()
        bindViewModel()

        viewModel.loadPosts()
    }
}

// MARK: - Navigation

private extension PostsListViewController {
    func setupNavigation() {
        if isGuest {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: NSLocalizedString("EXIT", comment: "Exit"),
                style: .plain,
                target: self,
                action: #selector(exitTapped)
            )
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: NSLocalizedString("LOGOUT", comment: "Logout"),
                style: .plain,
                target: self,
                action: #selector(logoutTapped)
            )
        }
    }

    @objc func logoutTapped() {
        viewModel.didRequestLogout?()
    }

    @objc func exitTapped() {
        let alert = UIAlertController(
            title: NSLocalizedString("EXIT_ALERT_TITLE", comment: "Thank you for trialing this app"),
            message: nil,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default) { _ in
            self.viewModel.didRequestLogout?()
        })

        present(alert, animated: true)
    }
}

// MARK: - TableView Setup

private extension PostsListViewController {
    func setupTableView() {
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 130
        tableView.allowsSelection = false

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Loading + Error Views

private extension PostsListViewController {
    func setupLoadingAndErrorViews() {
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        errorLabel.textColor = .systemRed
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        view.addSubview(errorLabel)

        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    func bindViewModel() {

        viewModel.$posts
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                isLoading
                ? self?.activityIndicator.startAnimating()
                : self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                self?.errorLabel.isHidden = (message == nil)
                self?.errorLabel.text = message
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableView

extension PostsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseId, for: indexPath) as? PostCell else {
            return UITableViewCell()
        }

        let item = viewModel.posts[indexPath.row]

        cell.configure(with: item)
        cell.tag = item.user.id

        cell.onUserTapped = { [weak self] user in
            self?.onUserSelected?(user)
        }

        return cell
    }
}


