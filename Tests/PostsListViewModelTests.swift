//
//  PostsListViewModelTests.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 09/12/2025.
//

import XCTest
import Combine
@testable import LeagueiOSChallenge

@MainActor
final class PostsListViewModelTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []
    
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
                 email: "a@b.com")
        ])

        let vm = PostsListViewModel(apiClient: APIClientWrapper(mock), apiKey: "123")

        let expectation = XCTestExpectation(description: "Posts loaded")

        vm.$posts
            .dropFirst() // ignore initial empty value
            .sink { posts in
                XCTAssertEqual(posts.count, 1)
                XCTAssertEqual(posts.first?.user.username, "jdoe")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        vm.loadPosts()

        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func test_loadPosts_error() async {

        let mock = APIClientMock()
        mock.postsResult = .failure(NSError(domain: "X", code: 1))

        let vm = PostsListViewModel(
            apiClient: mock,
            apiKey: "123"
        )

        let expectation = XCTestExpectation(description: "Error received")

        vm.$errorMessage
            .compactMap { $0 }
            .sink { error in
                XCTAssertFalse(error.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        vm.loadPosts()

        await fulfillment(of: [expectation], timeout: 1.0)
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
