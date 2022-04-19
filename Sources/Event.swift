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
        /// 点击回调
        public var onTap: ((_ view: Cell, _ object: Object, _ index: Int) -> ())?
    }
}
