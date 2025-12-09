//
//  SceneDelegate.swift
//  LeagueiOSChallenge
//
//  Copyright © 2024 League Inc. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let nav = UINavigationController()
        let coordinator = AppCoordinator(navigationController: nav, apiClient: APIClient())

        self.window = window
        self.coordinator = coordinator

        window.rootViewController = nav
        window.makeKeyAndVisible()

        coordinator.start()
    }
}
