//
//  JJCarouselViewPageable.swift
//  JJCarouselView
//
//  Created by zgjff on 2022/4/8.
//

import UIKit

/// 抽象化轮播图page指示器协议
public protocol JJCarouselViewPageable: UIView {
    /// 如果只有一个轮播数据时,是否隐藏page指示器
    var hidesForSinglePage: Bool { get set }
    
    /// 轮播数据总数
    var numberOfPages: Int { get set }
    
    /// 当前位置
    var currentPage: Int { get set }
    
    /// 非当前指示器颜色
    var pageIndicatorTintColor: UIColor? { get set }
    
    /// 当前指示器颜色
    var currentPageIndicatorTintColor: UIColor? { get set }
    
    /// 根据给定的数据数量计算对应控件所需的size
    func size(forNumberOfPages pageCount: Int) -> CGSize
    
    /// 轮播图滑动回调
    /// - Parameters:
    ///   - fromIndex: 当前index
    ///   - toindex: 目标index
    ///   - progress: 进度
    func onScroll(from fromIndex: Int, to toindex: Int, progress: Float)
}

extension UIPageControl: JJCarouselViewPageable {
    public func onScroll(from fromIndex: Int, to toindex: Int, progress: Float) {}
}
