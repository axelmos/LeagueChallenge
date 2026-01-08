//
//  PostsListViewModel.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 08/12/2025.
//

import Foundation
import Combine

final class PostsListViewModel {

    var didRequestLogout: (() -> Void)?
    
    // MARK: - Outputs (Combine)
    @Published private(set) var posts: [PostViewData] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?

    // MARK: - Dependencies
    private let apiClient: APIClientProtocol
    private let apiKey: String

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(apiClient: APIClientProtocol, apiKey: String) {
        self.apiClient = apiClient
        self.apiKey = apiKey
    }

    // MARK: - Actions
    func loadPosts() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                // ✅ Parallel requests
                async let postsRequest = apiClient.fetchPosts(apiKey: apiKey)
                async let usersRequest = apiClient.fetchUsers(apiKey: apiKey)

                let (posts, users) = try await (postsRequest, usersRequest)

                let userMap = Dictionary(uniqueKeysWithValues:
                    users.map { ($0.id, $0) }
                )

                let mapped: [PostViewData] = posts.compactMap { post in
                    guard let user = userMap[post.userId] else { return nil }

                    return PostViewData(
                        id: post.id,
                        title: post.title,
                        body: post.body,
                        user: user
                    )
                }

                // ✅ UI updates isolated to MainActor
                await MainActor.run {
                    self.posts = mapped
                    self.isLoading = false
                }

            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
