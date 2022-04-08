//
//  SceneDelegate.swift
//  JJCarouselView-Demo
//
//  Created by 郑桂杰 on 2022/4/8.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let wsc = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: wsc)
        window?.backgroundColor = .systemBackground
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    }
}
