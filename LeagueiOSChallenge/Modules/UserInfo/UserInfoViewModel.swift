//
//  UserInfoViewModel.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 08/12/2025.
//

import Foundation

@MainActor
final class UserInfoViewModel {
    private let user: User

    var displayName: String { user.name }
    var username: String { user.username }
    var email: String { user.email }
    var avatarUrl: String { user.avatar }
    var isEmailValid: Bool {
        let lower = user.email.lowercased()
        return lower.hasSuffix(".com") || lower.hasSuffix(".net") || lower.hasSuffix(".biz")
    }

    init(user: User) {
        self.user = user
    }
}
