//
//  UserInfoViewModelTests.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 09/12/2025.
//

import XCTest
@testable import LeagueiOSChallenge

@MainActor
final class UserInfoViewModelTests: XCTestCase {

    func testUserInfoFieldsAreCorrectlyExposed() {
        let user = User(
            id: 1,
            avatar: "https://avatar.png",
            name: "Axel Mosiejko",
            username: "axelmos",
            email: "axel@example.com"
        )

        let vm = UserInfoViewModel(user: user)

        XCTAssertEqual(vm.displayName, "Axel Mosiejko")
        XCTAssertEqual(vm.username, "axelmos")
        XCTAssertEqual(vm.email, "axel@example.com")
        XCTAssertEqual(vm.avatarUrl, "https://avatar.png")
    }

    func testEmailValidation_acceptsValidDomains() {
        let validEmails = [
            "test@example.com",
            "test@domain.NET",
            "user@company.biz",
            "USER@UPPERCASE.COM"
        ]

        for email in validEmails {
            let vm = UserInfoViewModel(user: .fake(email: email))
            XCTAssertTrue(vm.isEmailValid, "Expected valid email: \(email)")
        }
    }

    func testEmailValidation_rejectsInvalidDomains() {
        let invalidEmails = [
            "test@example.org",
            "hello@test.io",
            "name@domain.dev",
            "user@domain.co",
            "invalid"
        ]

        for email in invalidEmails {
            let vm = UserInfoViewModel(user: .fake(email: email))
            XCTAssertFalse(vm.isEmailValid, "Expected invalid email: \(email)")
        }
    }
}

private extension User {
    static func fake(email: String) -> User {
        return User(
            id: 1,
            avatar: "avatar",
            name: "Test",
            username: "test",
            email: email
        )
    }
}
