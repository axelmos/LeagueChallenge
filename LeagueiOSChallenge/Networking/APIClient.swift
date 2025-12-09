//
//  APIClient.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 08/12/2025.
//

import Foundation

class APIClient: APIClientProtocol {

    private let helper: APIHelper
    private let session: URLSession

    init(helper: APIHelper = APIHelper(), session: URLSession = .shared) {
        self.helper = helper
        self.session = session
    }

    // MARK: - LOGIN (uses APIHelper)
    func login(username: String?, password: String?) async throws -> String {
        try await helper.fetchUserToken(username: username, password: password)
    }

    // MARK: - USERS
    func fetchUsers(apiKey: String) async throws -> [User] {
        try await fetch(endpoint: .users, apiKey: apiKey)
    }

    // MARK: - POSTS
    func fetchPosts(apiKey: String) async throws -> [Post] {
        try await fetch(endpoint: .posts, apiKey: apiKey)
    }

    // MARK: - GENERIC FETCH
    private func fetch<T: Decodable>(
        endpoint: APIEndpoint,
        apiKey: String?,
        queryItems: [URLQueryItem]? = nil
    ) async throws -> T {

        guard let url = endpoint.url(with: queryItems) else {
            throw APIError.invalidEndpoint
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        if let apiKey {
            request.addValue(apiKey, forHTTPHeaderField: "x-access-token")
        }

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            throw APIError.decodeFailure
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
