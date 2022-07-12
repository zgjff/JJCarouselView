//
//  Config.swift
//  JJCarouselView
//
//  Created by zgjff on 2022/4/8.
//

import UIKit

extension JJCarouselView {
    /// 轮播图配置
    public struct Config {
        /// 自动滑动方向,默认左->右
        public var direction = JJCarousel.Direction.ltr
        
        /// 是否自动轮播,默认`true`自动轮播
        public var autoLoop = true
        
        /// 轮播间隔,默认5s
        public var loopTimeInterval: TimeInterval = 5
        
        /// 轮播图内边局
        public var contentInset = UIEdgeInsets.zero
        
        /// 具体显示轮播内容的方法
        public var display: ((Cell, Object) -> ())?
        
        /// 计算pageView的frame, 默认底部居中显示
        public var pageViewFrame: ((_ pageView: JJCarouselViewPageable, _ direction: JJCarousel.Direction, _ carouselViewSize: CGSize, _ totalDataCount: Int) -> CGRect) = { pageView, _, carouselViewSize, totalDataCount in
            let pageSize = pageView.size(forNumberOfPages: totalDataCount)
            return CGRect(x: (carouselViewSize.width - pageSize.width) * 0.5, y: carouselViewSize.height - pageSize.height - 5, width: pageSize.width, height: pageSize.height)
        }
    }
}
