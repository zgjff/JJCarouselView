//
//  Event.swift
//  JJCarouselView
//
//  Created by 郑桂杰 on 2022/4/11.
//

import UIKit

extension JJCarouselView {
    public final class Event {
        /// 点击回调
        public var onTap: ((Object, Int) -> ())?
    }
}
