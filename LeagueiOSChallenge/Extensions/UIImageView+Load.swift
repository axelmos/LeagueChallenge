//
//  UIImageView+Load.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 08/12/2025.
//

import UIKit

import UIKit

extension UIImageView {
    func load(url: URL) {
        self.image = nil  // clear current image while loading

        Task { [weak self] in
            // Move only the network call off the main actor
            let data: Data
            do {
                data = try await URLSession.shared.data(from: url).0
            } catch {
                return // Silent fail
            }

            guard let image = UIImage(data: data) else { return }

            // Update UI on main actor
            await MainActor.run {
                self?.image = image
            }
        }
    }
}

