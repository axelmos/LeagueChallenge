//
//  LoginViewModelTests.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 09/12/2025.
//

import XCTest
@testable import LeagueiOSChallenge

@MainActor
final class LoginViewModelTests: XCTestCase {

    func test_login_success() async {
        let mock = APIClientMock()
        mock.loginResult = .success("ABC123")

        let vm = LoginViewModel(apiClient: mock)

        var capturedToken: String?
        vm.onLoginSuccess = { token in
            capturedToken = token
        }

        vm.username = "axel"
        vm.password = "1234"
        vm.login()

        // Allow async to run
        try? await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(capturedToken, "ABC123")
        XCTAssertFalse(vm.isLoading)
        XCTAssertNil(vm.errorMessage)
    }

    func test_login_failure() async {
        let mock = APIClientMock()
        mock.loginResult = .failure(NSError(domain: "X", code: 1))

        let vm = LoginViewModel(apiClient: mock)

        vm.username = "john"
        vm.password = "pass123"
        vm.login()

        try? await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertNotNil(vm.errorMessage)
        XCTAssertFalse(vm.isLoading)
    }

    func test_continue_as_guest() {
        let mock = APIClientMock()
        let vm = LoginViewModel(apiClient: mock)

        var guestCalled = false
        vm.onContinueAsGuest = { guestCalled = true }

        vm.continueAsGuest()

        XCTAssertTrue(guestCalled)
        XCTAssertTrue(vm.isGuest)
    }
}
