//
//  APIClientProtocol.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 08/12/2025.
//

import Foundation

protocol APIClientProtocol {
    func login(username: String?, password: String?) async throws -> String
    func fetchUsers(apiKey: String) async throws -> [User]
    func fetchPosts(apiKey: String) async throws -> [Post]
}
