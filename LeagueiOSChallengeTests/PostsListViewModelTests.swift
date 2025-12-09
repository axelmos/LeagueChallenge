//
//  PostsListViewModelTests.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 09/12/2025.
//

import XCTest
@testable import LeagueiOSChallenge

@MainActor
final class PostsListViewModelTests: XCTestCase {

    func test_loadPosts_mergesUsersCorrectly() async {
        let mock = APIClientMock()

        mock.postsResult = .success([
            Post(userId: 1, id: 10, title: "Hello", body: "World")
        ])

        mock.usersResult = .success([
            User(id: 1,
                 avatar: "url",
                 name: "John",
                 username: "jdoe",
                 email: "a@b.com",
                 address: nil,
                 phone: nil,
                 website: nil,
                 company: nil)
        ])

        let vm = PostsListViewModel(apiClient: APIClientWrapper(mock), apiKey: "123")

        var updatedCalled = false
        vm.onPostsUpdated = { updatedCalled = true }

        vm.loadPosts()
        try? await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertTrue(updatedCalled)
        XCTAssertEqual(vm.posts.count, 1)
        XCTAssertEqual(vm.posts.first?.user?.username, "jdoe")
    }

    func test_loadPosts_error() async {
        let mock = APIClientMock()
        mock.postsResult = .failure(NSError(domain: "X", code: 1))

        let vm = PostsListViewModel(apiClient: APIClientWrapper(mock), apiKey: "123")

        var errorMessage: String?
        vm.onError = { err in errorMessage = err }

        vm.loadPosts()
        try? await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertNotNil(errorMessage)
    }
}

/// Wraps APIClientProtocol so the VM works (VM expects APIClient)
final class APIClientWrapper: APIClient {
    private let mock: APIClientProtocol

    init(_ mock: APIClientProtocol) {
        self.mock = mock
        super.init(session: .shared) // unused for mock
    }

    override func login(username: String?, password: String?) async throws -> String {
        try await mock.login(username: username, password: password)
    }

    override func fetchUsers(apiKey: String) async throws -> [User] {
        try await mock.fetchUsers(apiKey: apiKey)
    }

    override func fetchPosts(apiKey: String) async throws -> [Post] {
        try await mock.fetchPosts(apiKey: apiKey)
    }
}
