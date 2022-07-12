//
//  Style.swift
//  JJCarouselView
//
//  Created by zgjff on 2022/4/13.
//

import CoreGraphics

extension JJCarouselView {
    /// 轮播图风格
    public enum Style {
        /// 平铺式-----单个cell充满整个轮播图容器
        case full
        // TODO: - 其它风格
    }
}

extension JJCarouselView.Style {
    func createContainerView(frame: CGRect, initialize: (() -> Cell)?) -> JJCarouselContainerView {
        switch self {
        case .full:
            return JJCarouselView.FullContainerView(frame: frame, initialize: initialize)
        }
    }
}
