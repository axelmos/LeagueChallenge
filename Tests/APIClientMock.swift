//
//  APIClientMock.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 09/12/2025.
//

import Foundation
@testable import LeagueiOSChallenge

final class APIClientMock: APIClientProtocol {

    // Configurable results
    var loginResult: Result<String, Error> = .failure(MockError.noResult)
    var usersResult: Result<[User], Error> = .failure(MockError.noResult)
    var postsResult: Result<[Post], Error> = .failure(MockError.noResult)

    enum MockError: Error { case noResult }

    func login(username: String?, password: String?) async throws -> String {
        try loginResult.get()
    }

    func fetchUsers(apiKey: String) async throws -> [User] {
        try usersResult.get()
    }

    func fetchPosts(apiKey: String) async throws -> [Post] {
        try postsResult.get()
    }
}
