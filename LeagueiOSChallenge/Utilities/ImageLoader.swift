//
//  ImageLoader.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 09/12/2025.
//

import UIKit

actor ImageLoader {
    static let shared = ImageLoader()
    private var cache: [String: UIImage] = [:]

    func loadImage(from urlString: String) async -> UIImage? {
        if let cached = cache[urlString] {
            return cached
        }

        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                cache[urlString] = image
                return image
            }
        } catch {
            return nil
        }

        return nil
    }
}
