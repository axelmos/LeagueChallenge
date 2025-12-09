//
//  APIEndpoint.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 08/12/2025.
//

import Foundation

enum APIError: Error {
    case invalidEndpoint
    case decodeFailure
}

enum APIEndpoint: String {
    case login = "login"
    case users = "users"
    case posts = "posts"

    private static let baseUrlString =
        "https://northamerica-northeast1-league-engineering-hiring.cloudfunctions.net/mobile-challenge-api/"

    func url(with queryItems: [URLQueryItem]? = nil) -> URL? {
        var components = URLComponents(string: APIEndpoint.baseUrlString + rawValue)
        components?.queryItems = queryItems
        return components?.url
    }
}
