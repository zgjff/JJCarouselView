//
//  JJCarouselEmptyPageView.swift
//  JJCarouselView
//
//  Created by 郑桂杰 on 2022/4/8.
//

import UIKit

/// 空轮播图page,也就是不显示轮播图page指示器
public final class JJCarouselEmptyPageView: UIView, JJCarouselViewPageable {
    public var hidesForSinglePage: Bool = true
    
    public var numberOfPages: Int = 0
    
    public var currentPage: Int = 0
    
    public var pageIndicatorTintColor: UIColor?
    
    public var currentPageIndicatorTintColor: UIColor?
    
    public func size(forNumberOfPages pageCount: Int) -> CGSize {
        return .zero
    }
}
