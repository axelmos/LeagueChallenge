//
//  PostsListViewModel.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 08/12/2025.
//

import Foundation

@MainActor
final class PostsListViewModel {

    // Output
    private(set) var posts: [PostItem] = [] {
        didSet { onPostsUpdated?() }
    }

    // Callbacks
    var onPostsUpdated: (() -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onError: ((String?) -> Void)?
    var didRequestLogout: (() -> Void)?

    // Dependencies
    private let apiClient: APIClient
    private let apiKey: String

    init(apiClient: APIClient, apiKey: String) {
        self.apiClient = apiClient
        self.apiKey = apiKey
    }

    // MARK: - Load Posts
    func loadPosts() {
        onLoadingChanged?(true)

        Task {
            do {
                let fetchedPosts = try await apiClient.fetchPosts(apiKey: apiKey)
                let users = try await apiClient.fetchUsers(apiKey: apiKey)

                let userMap = Dictionary(uniqueKeysWithValues:
                    users.map { ($0.id, $0) }
                )

                let mapped: [PostItem] = fetchedPosts.map { post in
                    let user = userMap[post.userId]

                    return PostItem(
                        id: post.id,
                        title: post.title,
                        body: post.body,
                        userId: post.userId,
                        user: user
                    )
                }

                self.posts = mapped
                onLoadingChanged?(false)
            } catch {
                onLoadingChanged?(false)
                onError?(error.localizedDescription)
            }
        }
    }
}
