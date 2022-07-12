//
//  JJCarouselHiddenPageView.swift
//  JJCarouselView
//
//  Created by zgjff on 2022/4/8.
//

import UIKit

/// 不显示轮播图page指示器
public final class JJCarouselHiddenPageView: UIView, JJCarouselViewPageable {
    public var hidesForSinglePage: Bool = true
    
    public var numberOfPages: Int = 0
    
    public var currentPage: Int = 0
    
    public var pageIndicatorTintColor: UIColor?
    
    public var currentPageIndicatorTintColor: UIColor?
    
    public func size(forNumberOfPages pageCount: Int) -> CGSize {
        return .zero
    }
    
    public func onScroll(from fromIndex: Int, to toindex: Int, progress: Float) { }
}
