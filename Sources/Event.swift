//
//  Event.swift
//  JJCarouselView
//
//  Created by 郑桂杰 on 2022/4/11.
//

import UIKit

extension JJCarouselView {
    /// 轮播图事件
    public final class Event {
        /// 点击事件
        public var onTap: ((_ view: Cell, _ object: Object, _ index: Int) -> ())?
        
        /// 滑动回调(当前index, 目标index, 进度)
        public var onScroll: ((_ fronIndex: Int, _ toIndex: Int, _ progress: Float) -> ())?
        
        /// 准备滑动到目标的index
        public var willMove: ((_ index: Int) -> ())?
        
        /// 已经滑动到具体的index
        public var didMove: ((_ index: Int) -> ())?
    }
}
