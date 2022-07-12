//
//  SceneDelegate.swift
//  JJCarouselView-Demo
//
//  Created by zgjff on 2022/4/8.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let wsc = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: wsc)
        window?.backgroundColor = .systemBackground
        window?.rootViewController = TabBarViewController()
        window?.makeKeyAndVisible()
    }
}
