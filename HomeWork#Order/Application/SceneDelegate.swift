//
//  SceneDelegate.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 16.10.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let navigationController = NavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
    }

}

