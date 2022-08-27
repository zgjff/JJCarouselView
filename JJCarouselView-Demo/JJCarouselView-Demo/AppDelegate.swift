//
//  AppDelegate.swift
//  JJCarouselView-Demo
//
//  Created by zgjff on 2022/4/8.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            window?.backgroundColor = .systemBackground
        } else {
            window?.backgroundColor = .black
        }
        window?.rootViewController = TabBarViewController()
        window?.makeKeyAndVisible()
        return true
    }
}
