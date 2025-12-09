//
//  APIHelper.swift
//  LeagueiOSChallenge
//
//  Copyright © 2024 League Inc. All rights reserved.
//

import Foundation

class APIHelper {

    func fetchUserToken(
        username: String?,
        password: String?) async throws
    -> String
    {
        guard let url = APIEndpoint.login.url() else {
            throw APIError.invalidEndpoint
        }

        let urlSessionConfig: URLSessionConfiguration = .default
        
        if let username, let password {
            let authString = "\(username):\(password)"
            let authData = Data(authString.utf8)
            let base64AuthString = "Basic \(authData.base64EncodedString())"
            urlSessionConfig.httpAdditionalHeaders = ["Authorization": base64AuthString]
        }
        
        let session = URLSession(configuration: urlSessionConfig)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let (data, _) = try await session.data(for: URLRequest(url: url))

        if let results = try? decoder.decode(LoginResponse.self, from: data) {
            return results.apiKey
        } else {
            throw APIError.decodeFailure
        }
    }
}
