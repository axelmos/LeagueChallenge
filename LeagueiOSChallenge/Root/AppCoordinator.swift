//
//  AppCoordinator.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 08/12/2025.
//

import UIKit

@MainActor
final class AppCoordinator {

    private let navigationController: UINavigationController
    private let apiClient: APIClient
    private var apiKey: String?

    init(navigationController: UINavigationController, apiClient: APIClient) {
        self.navigationController = navigationController
        self.apiClient = apiClient
    }

    func start() {
        showLogin()
    }
}

// MARK: - Navigation
extension AppCoordinator {

    private func showLogin() {
        let viewModel = LoginViewModel(apiClient: apiClient)
        let viewController = LoginViewController(viewModel: viewModel)

        viewModel.onLoginSuccess = { [weak self] token in
            guard let self else { return }
            self.apiKey = token
            self.showPostsList(isGuest: false)
        }

        viewModel.onContinueAsGuest = { [weak self] in
            guard let self else { return }
            
            Task {
                do {
                    // Login without credentials (API returns random token)
                    let token = try await self.apiClient.login(username: nil, password: nil)

                    self.apiKey = token
                    self.showPostsList(isGuest: true)
                } catch {
                    print("Guest login failed: \(error)")
                }
            }
        }

        navigationController.setViewControllers([viewController], animated: false)
    }

    private func showPostsList(isGuest: Bool) {
        let viewModel = PostsListViewModel(
            apiClient: apiClient,
            apiKey: apiKey ?? ""
        )
        
        viewModel.didRequestLogout = { [weak self] in
            self?.apiKey = nil
            self?.showLogin()
        }

        let viewController = PostsListViewController(
            viewModel: viewModel,
            isGuest: isGuest
        )

        viewController.onUserSelected = { [weak self] user in
            guard let self else { return }
            self.showUserInfo(user: user)
        }

        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func showUserInfo(user: User) {
        let vm = UserInfoViewModel(user: user)
        let vc = UserInfoViewController(viewModel: vm)
        let nav = UINavigationController(rootViewController: vc)

        nav.modalPresentationStyle = .formSheet
        navigationController.present(nav, animated: true)
    }
}
