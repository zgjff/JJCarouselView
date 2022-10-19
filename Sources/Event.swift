//
//  Event.swift
//  JJCarouselView
//
//  Created by zgjff on 2022/4/11.
//

import UIKit
import Combine

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
        
//        @available(iOS 13.0, *)
//        internal lazy var _onTapPublisher = PassthroughSubject<(Cell, Object, Int), Never>()
//
//        @available(iOS 13.0, *)
//        internal lazy var _onScrollPublisher = PassthroughSubject<(Int, Int, Float), Never>()
//
//        @available(iOS 13.0, *)
//        internal lazy var _willMovePublisher = PassthroughSubject<Int, Never>()
//
//        @available(iOS 13.0, *)
//        internal lazy var _didMovePublisher = PassthroughSubject<Int, Never>()
    }
}

internal extension JJCarouselView.Event {
    func onTapFunction(view: Cell, object: Object, index: Int) {
        onTap?(view, object, index)
    }
     
    func onScrollFunction(fronIndex: Int, toIndex: Int, progress: Float) {
        onScroll?(fronIndex, toIndex, progress)
    }
    
    func willMoveFunction(index: Int) {
        willMove?(index)
    }
    
    func didMoveFunction(index: Int) {
        didMove?(index)
    }
}
