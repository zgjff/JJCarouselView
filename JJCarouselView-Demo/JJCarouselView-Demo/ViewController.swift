//
//  ViewController.swift
//  JJCarouselView-Demo
//
//  Created by zgjff on 2022/4/8.
//

import UIKit
import SDWebImage
import SafariServices
import Combine

class ViewController: UIViewController {

    private lazy var scrollView = UIScrollView()
    private lazy var subviewsMaxY: CGFloat = 0
    private lazy var cancellable = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addLocalImageCarouselView1()
//        addLocalImageCarouselView2()
//        addWebImageCarouselView()
//        addCustomCarouselView()
        scrollView.contentSize = CGSize(width: view.bounds.width, height: subviewsMaxY + 20)
    }
}

private extension ViewController {
    func setup() {
        navigationItem.title = "可以切换tabbar来观察轮播图是否暂停"
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
    }
    
    func addLocalImageCarouselView1() {
        let carouselView: JJCarouselView<UIImageView, UIImage> = JJCarouselView(frame: CGRect(x: 50, y: 0, width: view.bounds.width - 100, height: 200), initialize: nil)
        carouselView.config.display = { cell, object in
            cell.clipsToBounds = true
            cell.contentMode = .scaleAspectFill
            cell.image = object
        }
        carouselView.config.direction = .rtl
        carouselView.backgroundColor = .random()
        carouselView.event.onTap = { _, obj, idx in
            print(obj, idx)
        }
        carouselView.event.willMove = { idx in
            print("willMove----", idx)
        }
        carouselView.event.didMove = { idx in
            print("didMove----", idx)
        }
        carouselView.event.onScroll = { fromIndex, toIndex, progress in 
//            print("onScroll----", fromIndex, toIndex, progress)
        }
        carouselView.event.onTapPublisher.sink { _, _, idx in
//            print("onTapPublisher-----------", idx)
        }.store(in: &cancellable)
        carouselView.event.onScrollPublisher.sink(receiveValue: { fromIndex, toIndex, progress in
//            print("onScrollPublisher----", fromIndex, toIndex, progress)
        }).store(in: &cancellable)
        carouselView.event.willMovePublisher.sink(receiveValue: { idx in
//            print("willMovePublisher-----------", idx)
        }).store(in: &cancellable)
        carouselView.event.didMovePublisher.sink(receiveValue: { idx in
//            print("didMovePublisher-----------", idx)
        }).store(in: &cancellable)
        subviewsMaxY = carouselView.frame.maxY
        scrollView.addSubview(carouselView)
        carouselView.datas = (0..<6).map { UIImage(named: "a-\($0).jpeg")! }
    }
    
    func addLocalImageCarouselView2() {
        let carouselView = JJLocalImageCarouselView(frame: CGRect(x: 50, y: subviewsMaxY + 30, width: view.bounds.width - 100, height: 200)) {
            return UIImageView()
        }
        carouselView.config.display = { cell, object in
            cell.contentMode = .scaleAspectFit
            cell.image = object
        }
        carouselView.config.direction = .ttb
        carouselView.config.pageViewFrame = { pageView, _, carouselViewSize, totalDataCount in
            let pageSize = pageView.size(forNumberOfPages: totalDataCount)
            return CGRect(x: carouselViewSize.width - pageSize.width - 12, y: carouselViewSize.height - pageSize.height - 10, width: pageSize.width, height: pageSize.height)
        }
        carouselView.pageView = JJCarouselNumberPageView()
        subviewsMaxY = carouselView.frame.maxY
        scrollView.addSubview(carouselView)
        carouselView.datas = (0..<3).map { UIImage(named: "a-\($0).jpeg")! }
    }
    
    func addWebImageCarouselView() {
        let carouselView = JJWebImageCarouselView(frame: CGRect(x: 50, y: subviewsMaxY + 30, width: view.bounds.width - 100, height: 200))
        carouselView.config.display = { cell, object in
            cell.clipsToBounds = true
            cell.contentMode = .scaleAspectFill
            cell.sd_setImage(with: object)
        }
        carouselView.pageView = JJCarouselNumberPageView()
        carouselView.config.pageViewFrame = { _, _, carouselViewSize, _ in
            return CGRect(x: carouselViewSize.width - 55, y: carouselViewSize.height - 30, width: 45, height: 20)
        }
        subviewsMaxY = carouselView.frame.maxY
        scrollView.addSubview(carouselView)
        carouselView.datas = (1..<25).compactMap { URL(string: String(format: "http://r0k.us/graphics/kodak/kodak/kodim%02d.png", $0)) }
    }
    
    func addCustomCarouselView() {
        let carouselView: JJCarouselView<WebCarouselView, WebCarouselModel> = JJCarouselView(frame: CGRect(x: 50, y: subviewsMaxY + 30, width: view.bounds.width - 100, height: 150))
        carouselView.config.display = { cell, object in
            cell.titleLabel.text = object.title
            cell.descLabel.text = object.desc
        }
        carouselView.event.onTap = { [weak self] _, obj, _ in
            let sf = SFSafariViewController(url: obj.url)
            self?.present(sf, animated: true)
        }
        carouselView.pageView = JJCarouselNumberPageView()
        subviewsMaxY = carouselView.frame.maxY
        scrollView.addSubview(carouselView)
        carouselView.datas = [
            WebCarouselModel(title: "这是第1个自定义轮播控件", desc: "这是第1个自定义轮播控件", url: URL(string: "https://www.baidu.com")!),
            WebCarouselModel(title: "这是第2个自定义轮播控件", desc: "这是第2个自定义轮播控件", url: URL(string: "https://www.zhihu.com")!),
            WebCarouselModel(title: "这是第3个自定义轮播控件", desc: "这是第3个自定义轮播控件", url: URL(string: "https://cn.bing.com")!),
        ]
    }
}
