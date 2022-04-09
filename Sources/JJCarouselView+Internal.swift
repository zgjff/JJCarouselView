//
//  JJCarouselView+Internal.swift
//  JJCarouselView
//
//  Created by 郑桂杰 on 2022/4/8.
//

import UIKit

extension JJCarouselView {
    /// 对比新数据源与旧数据源
    /// - Parameters:
    ///   - old: 旧数据源
    ///   - new: 新数据源
    internal func onGetDatas(old: [Object], new: [Object]) {
        pageView.numberOfPages = new.count
        if old.count != new.count {
            onGetDifferentDatas()
            return
        }
        if new.isEmpty {
            scrollView.isScrollEnabled = false
            return
        }
        let isSame = new.elementsEqual(old, by: { $0 == $1 })
        if !isSame {
            onGetDifferentDatas()
        }
    }
    
    /// 获取到的新数据源跟旧数据源不一致
    private  func onGetDifferentDatas() {
        scrollView.isScrollEnabled = datas.count > 1
        switch datas.count {
        case 0:
            [firstContainer, secondContainer, thirdContainer].forEach { $0.cell.isHidden = true }
        case 1:
            [firstContainer, thirdContainer].forEach { $0.cell.isHidden = true }
            secondContainer.cell.isHidden = false
        default:
            [firstContainer, secondContainer, thirdContainer].forEach { $0.cell.isHidden = false }
        }
        if currentFrame.isEmpty {
            setNeedsLayout()
            layoutIfNeeded()
        } else {
            switch config.direction {
            case .horizontal:
                scrollView.contentOffset = CGPoint(x: bounds.width, y: 0)
            case .vertical:
                scrollView.contentOffset = CGPoint(x: 0, y: bounds.height)
            }
            pageView.frame = config.pageViewFrame(pageView, config.direction, bounds.size, datas.count)
        }
        currentIndex = 0
        if datas.count > 1 {
            createTimer()
        } else {
            destoryTimer()
        }
    }
    
    /// 轮播图frame改变回调
    internal func onChangeFrame() {
        switch config.direction {
        case .horizontal:
            scrollView.contentSize = CGSize(width: bounds.width * 3, height: bounds.height)
            scrollView.contentOffset = CGPoint(x: bounds.width, y: 0)
        case .vertical:
            scrollView.contentSize = CGSize(width: bounds.width, height: bounds.height * 3)
            scrollView.contentOffset = CGPoint(x: 0, y: bounds.height)
        }
        preScrollcontentOffset = scrollView.contentOffset
        pageView.frame = config.pageViewFrame(pageView, config.direction, bounds.size, datas.count)
    }
    
    /// 轮播图当前显示的index改变回调
    internal func onChangeCurrentIndex() {
        pageView.currentPage = currentIndex
        switch datas.count {
        case 0:
            return
        case 1:
            secondContainer.index = 0
            config.display?(secondContainer.cell, datas[0])
        default:
            let preIndex = (currentIndex - 1 + datas.count) % datas.count
            firstContainer.index = preIndex
            config.display?(firstContainer.cell, datas[preIndex])
            secondContainer.index = currentIndex
            config.display?(secondContainer.cell, datas[currentIndex])
            let nextIndex = (currentIndex + 1) % datas.count
            thirdContainer.index = nextIndex
            config.display?(thirdContainer.cell, datas[nextIndex])
        }
    }
    
    /// 添加观察者
    internal func addObservers() {
        didEnterBackgroundObserver = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main, using: { [weak self] _ in
            self?.pauseTimer()
        })
        willEnterForegroundObserver = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let self = self else {
                return
            }
            self.timer?.fireDate = .distantFuture
            self.timer?.fireDate = Date().addingTimeInterval(self.config.loopTimeInterval)
        })
    }
    
    /// 移除观察者
    internal func removeObservers() {
        if let didEnterBackgroundObserver = didEnterBackgroundObserver {
            NotificationCenter.default.removeObserver(didEnterBackgroundObserver)
        }
        if let willEnterForegroundObserver = didEnterBackgroundObserver {
            NotificationCenter.default.removeObserver(willEnterForegroundObserver)
        }
    }
    
    /// 布局
    internal func layoutCells() {
        switch config.direction {
        case .horizontal:
            let contentInsetWidth = bounds.width - config.contentInset.left - config.contentInset.right
            let cellWidth = contentInsetWidth > 0 ? contentInsetWidth : 0
            let contentInsetHeight = bounds.height - config.contentInset.top - config.contentInset.bottom
            let cellHeight = contentInsetHeight > 0 ? contentInsetHeight : 0
            firstContainer.cell.frame = CGRect(x: config.contentInset.left, y: config.contentInset.top, width: cellWidth, height: cellHeight)
            secondContainer.cell.frame = firstContainer.cell.frame.offsetBy(dx: bounds.width, dy: 0)
            thirdContainer.cell.frame = secondContainer.cell.frame.offsetBy(dx: bounds.width, dy: 0)
        case .vertical:
            firstContainer.cell.frame = CGRect(origin: .zero, size: bounds.size)
            let contentInsetWidth = bounds.width - config.contentInset.left - config.contentInset.right
            let cellWidth = contentInsetWidth > 0 ? contentInsetWidth : 0
            let contentInsetHeight = bounds.height - config.contentInset.top - config.contentInset.bottom
            let cellHeight = contentInsetHeight > 0 ? contentInsetHeight : 0
            firstContainer.cell.frame = CGRect(x: config.contentInset.left, y: config.contentInset.top, width: cellWidth, height: cellHeight)
            secondContainer.cell.frame = firstContainer.cell.frame.offsetBy(dx: 0, dy: bounds.height)
            thirdContainer.cell.frame = secondContainer.cell.frame.offsetBy(dx: 0, dy: bounds.height)
        }
    }
    
    /// 创建定时器
    internal func createTimer() {
        if !config.autoLoop {
            return
        }
        let timer = Timer(fire: Date().addingTimeInterval(config.loopTimeInterval), interval: config.loopTimeInterval, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            switch self.config.direction {
            case .horizontal:
                self.scrollView.setContentOffset(CGPoint(x: self.bounds.width * 2, y: 0), animated: true)
            case .vertical:
                self.scrollView.setContentOffset(CGPoint(x: 0, y: self.bounds.height * 2), animated: true)
            }
        }
        RunLoop.current.add(timer, forMode: .common)
        self.timer = timer
    }
    
    /// 暂停定时器
    internal func pauseTimer() {
        timer?.fireDate = .distantFuture
    }
    
    /// 销毁定时器
    internal func destoryTimer() {
        timer?.invalidate()
        timer = nil
    }
}
