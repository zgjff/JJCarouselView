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
        
        @available(iOS 13.0, *)
        internal lazy var _onTapPublisher = PassthroughSubject<(Cell, Object, Int), Never>()
        
        @available(iOS 13.0, *)
        internal lazy var _onScrollPublisher = PassthroughSubject<(Int, Int, Float), Never>()
        
        @available(iOS 13.0, *)
        internal lazy var _willMovePublisher = PassthroughSubject<Int, Never>()
        
        @available(iOS 13.0, *)
        internal lazy var _didMovePublisher = PassthroughSubject<Int, Never>()
    }
}

extension JJCarouselView.Event {
    /// 滑动回调(当前index, 目标index, 进度)
    @available(iOS 13.0, *)
    public var onTapPublisher: AnyPublisher<(Cell, Object, Int), Never> {
        return _onTapPublisher.eraseToAnyPublisher()
    }
    
    /// 滑动回调(当前index, 目标index, 进度)
    @available(iOS 13.0, *)
    public var willMovePublisher: AnyPublisher<Int, Never> {
        return _willMovePublisher.eraseToAnyPublisher()
    }
    
    /// 准备滑动到目标的index
    @available(iOS 13.0, *)
    public var onScrollPublisher: AnyPublisher<(Int, Int, Float), Never> {
        return _onScrollPublisher.eraseToAnyPublisher()
    }
    
    /// 已经滑动到具体的index
    @available(iOS 13.0, *)
    public var didMovePublisher: AnyPublisher<Int, Never> {
        return _didMovePublisher.eraseToAnyPublisher()
    }
}

internal extension JJCarouselView.Event {
    func onTapFunction(view: Cell, object: Object, index: Int) {
        onTap?(view, object, index)
        if #available(iOS 13.0, *) {
            _onTapPublisher.send((view, object, index))
        }
    }
     
    func onScrollFunction(fronIndex: Int, toIndex: Int, progress: Float) {
        onScroll?(fronIndex, toIndex, progress)
        if #available(iOS 13.0, *) {
            _onScrollPublisher.send((fronIndex, toIndex, progress))
        }
    }
    
    func willMoveFunction(index: Int) {
        willMove?(index)
        if #available(iOS 13.0, *) {
            _willMovePublisher.send(index)
        }
    }
    
    func didMoveFunction(index: Int) {
        didMove?(index)
        if #available(iOS 13.0, *) {
            _didMovePublisher.send(index)
        }
    }
}
