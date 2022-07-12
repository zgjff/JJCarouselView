//
//  JJCarouselContainerView.swift
//  JJCarouselView
//
//  Created by zgjff on 2022/4/13.
//

import UIKit

/// 轮播图容器协议
protocol JJCarouselContainerView: UIView {
    var delegate: JJCarouselContainerViewDelegate? { get set }
    var dataSource: JJCarouselContainerViewDataSource? { get set }
    /// 刷新数据
    func reload()
    /// 需要滑动下一位置
    func needAutoScrollToNextIndex()
}

/// 轮播图容器代理
protocol JJCarouselContainerViewDelegate: NSObjectProtocol {
    /// 展示轮播图数据
    func displayCell(_ cell: UIView, atIndex index: Int)
    /// 点击具体的cell容器
    func onClickCell(_ cell: UIView, atIndex index: Int)
    /// 将要到index位置
    func willScroll(to index: Int)
    /// 滑动
    func onScroll(from fromIndex: Int, to toIndex: Int, progress: Float)
    /// 滑动到index位置
    func didScroll(to index: Int)
    /// 开始手动拖动scrollView
    func scrollViewWillBeginDragging()
    /// scrollView停止滑动
    func scrollViewDidEndDecelerating()
}

/// 轮播图容器数据源
protocol JJCarouselContainerViewDataSource: NSObjectProtocol {
    /// 轮播方向
    func loopDirection() -> JJCarousel.Direction
    /// 数据源数量
    func numberOfDatas() -> Int
    /// 轮播图内边局
    func cellContentInset() -> UIEdgeInsets
}
