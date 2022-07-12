//
//  TabBarViewController.swift
//  JJCarouselView-Demo
//
//  Created by zgjff on 2022/4/19.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .red
        let vc1 = UINavigationController(rootViewController: ViewController())
        vc1.title = "轮播"
        
        let vc2 = UIViewController()
        vc2.title = "空白"
        viewControllers = [vc1, vc2]
    }
}
