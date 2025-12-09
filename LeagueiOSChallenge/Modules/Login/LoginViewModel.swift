//
//  LoginViewModel.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 08/12/2025.
//

import Foundation

@MainActor
final class LoginViewModel {
    // Inputs
    var username: String = ""
    var password: String = ""
    var isGuest: Bool = false

    // Outputs (Coordinator callbacks)
    var onLoginSuccess: ((String) -> Void)?
    var onContinueAsGuest: (() -> Void)?

    // UI state bindings
    var isLoading: Bool = false
    var errorMessage: String?

    private let apiClient: APIClientProtocol

    // MARK: - Init
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    // MARK: - Actions
    func login() {
        guard !isGuest else {
            onContinueAsGuest?()
            return
        }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let token = try await apiClient.login(username: username, password: password)
                await MainActor.run {
                    self.isLoading = false
                    self.onLoginSuccess?(token)
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = LoginViewModel.errorMessage(for: error)
                }
            }
        }
    }

    func continueAsGuest() {
        isGuest = true
        onContinueAsGuest?()
    }

    // MARK: - Error handling
    private static func errorMessage(for error: Error) -> String {
        error.localizedDescription
    }
}

