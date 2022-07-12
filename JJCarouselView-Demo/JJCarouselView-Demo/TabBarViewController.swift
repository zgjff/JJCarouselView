//
//  TabBarViewController.swift
//  JJCarouselView-Demo
//
//  Created by 郑桂杰 on 2022/4/19.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .red
        let vc1 = ViewController()
        vc1.title = "轮播"
        
        let vc2 = UIViewController()
        vc2.title = "空白"
        viewControllers = [vc1, vc2]
    }
}
