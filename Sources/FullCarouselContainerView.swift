//
//  FullCarouselContainerView.swift
//  JJCarouselView
//
//  Created by 郑桂杰 on 2022/4/13.
//

import UIKit

extension JJCarouselView {
    /// cell充满view风格轮播图
    final class FullContainerView: UIView, JJCarouselContainerView, UIScrollViewDelegate {
        weak var delegate: JJCarouselContainerViewDelegate?
        weak var dataSource: JJCarouselContainerViewDataSource?

        init(frame: CGRect, initialize: (() -> Cell)?) {
            scrollView = UIScrollView(frame: CGRect(origin: .zero, size: frame.size))
            scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            scrollView.isPagingEnabled = true
            scrollView.bounces = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.contentInsetAdjustmentBehavior = .never
            firstContainer = CellContainer(cell: initialize?() ?? Cell(frame: .zero), index: 0)
            secondContainer = CellContainer(cell: initialize?() ?? Cell(frame: .zero), index: 1)
            thirdContainer = CellContainer(cell: initialize?() ?? Cell(frame: .zero), index: 2)
            super.init(frame: CGRect(origin: .zero, size: frame.size))
            scrollView.isScrollEnabled = false
            scrollView.delegate = self
            addSubview(scrollView)
            [firstContainer, secondContainer, thirdContainer].forEach { [unowned self] obj in
                obj.cell.isHidden = true
                obj.onTap = { [weak self] cell, idx in
                    self?.delegate?.onClickCell(cell, atIndex: idx)
                }
                self.scrollView.addSubview(obj.cell)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - 组件
        private let scrollView: UIScrollView
        private let firstContainer: CellContainer
        private let secondContainer: CellContainer
        private let thirdContainer: CellContainer
        
        // MARK: - 属性
        private var currentFrame = CGRect.zero {
            didSet {
                onChangeFrame(old: oldValue, new: currentFrame)
            }
        }
        private var currentIndex = 0 {
            didSet {
                onChangeCurrentIndex()
            }
        }
        
        private var willScrollIndex = -1 {
            didSet {
                if (willScrollIndex != oldValue) && (willScrollIndex != -1) {
                    delegate?.willScroll(to: willScrollIndex)
                }
            }
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            currentFrame = bounds
        }
        
        // MARK: - UIScrollViewDelegate
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let dataCount = dataSource?.numberOfDatas() ?? 0
            if (bounds.width == 0) || (bounds.height == 0) || (dataCount == 0) {
                return
            }
            switch (dataSource?.isHorizontalScroll() ?? true) {
            case true:
                let offsetX = scrollView.contentOffset.x
                if (bounds.width < offsetX) && (offsetX < bounds.width * 2) {
                    let nextIndex = (currentIndex + 1) % dataCount
                    willScrollIndex = nextIndex
                    let progress = (offsetX - bounds.width) / bounds.width
                    delegate?.onScroll(from: currentIndex, to: nextIndex, progress: Float(progress))
                } else if (0 < offsetX) && (offsetX < bounds.width) {
                    let preIndex = (currentIndex - 1 + dataCount) % dataCount
                    willScrollIndex = preIndex
                    let progress = (bounds.width - offsetX) / bounds.width
                    delegate?.onScroll(from: currentIndex, to: preIndex, progress: Float(progress))
                }
            case false:
                let offsetY = scrollView.contentOffset.y
                if (bounds.height < offsetY) && (offsetY < bounds.height * 2) {
                    let nextIndex = (currentIndex + 1) % dataCount
                    willScrollIndex = nextIndex
                    let progress = (offsetY - bounds.height) / bounds.height
                    delegate?.onScroll(from: currentIndex, to: nextIndex, progress: Float(progress))
                } else if (0 < offsetY) && (offsetY < bounds.height) {
                    let preIndex = (currentIndex - 1 + dataCount) % dataCount
                    willScrollIndex = preIndex
                    let progress = (bounds.height - offsetY) / bounds.height
                    delegate?.onScroll(from: currentIndex, to: preIndex, progress: Float(progress))
                }
            }
        }
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            delegate?.scrollViewWillBeginDragging()
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            adjustWhenEndScrolling(animation: false)
        }
        
        func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
            adjustWhenEndScrolling(animation: true)
        }
        
        func reload() {
            onGetDatas()
        }
        
        func needAutoScrollToNextIndex() {
            switch (dataSource?.isHorizontalScroll() ?? true) {
            case true:
                scrollView.setContentOffset(CGPoint(x: bounds.width * 2, y: 0), animated: true)
            case false:
                scrollView.setContentOffset(CGPoint(x: 0, y: bounds.height * 2), animated: true)
            }
        }
    }
}

private extension JJCarouselView.FullContainerView {
    func onChangeFrame(old: CGRect, new: CGRect) {
        if old == new {
            return
        }
        layoutCells()
        switch (dataSource?.isHorizontalScroll() ?? true) {
        case true:
            scrollView.contentSize = CGSize(width: bounds.width * 3, height: bounds.height)
            scrollView.contentOffset = CGPoint(x: bounds.width, y: 0)
        case false:
            scrollView.contentSize = CGSize(width: bounds.width, height: bounds.height * 3)
            scrollView.contentOffset = CGPoint(x: 0, y: bounds.height)
        }
    }
    
    func layoutCells() {
        let contentInset = dataSource?.cellContentInset() ?? .zero
        switch (dataSource?.isHorizontalScroll() ?? true) {
        case true:
            let contentInsetWidth = bounds.width - contentInset.left - contentInset.right
            let cellWidth = contentInsetWidth > 0 ? contentInsetWidth : 0
            let contentInsetHeight = bounds.height - contentInset.top - contentInset.bottom
            let cellHeight = contentInsetHeight > 0 ? contentInsetHeight : 0
            firstContainer.cell.frame = CGRect(x: contentInset.left, y: contentInset.top, width: cellWidth, height: cellHeight)
            secondContainer.cell.frame = firstContainer.cell.frame.offsetBy(dx: bounds.width, dy: 0)
            thirdContainer.cell.frame = secondContainer.cell.frame.offsetBy(dx: bounds.width, dy: 0)
        case false:
            firstContainer.cell.frame = CGRect(origin: .zero, size: bounds.size)
            let contentInsetWidth = bounds.width - contentInset.left - contentInset.right
            let cellWidth = contentInsetWidth > 0 ? contentInsetWidth : 0
            let contentInsetHeight = bounds.height - contentInset.top - contentInset.bottom
            let cellHeight = contentInsetHeight > 0 ? contentInsetHeight : 0
            firstContainer.cell.frame = CGRect(x: contentInset.left, y: contentInset.top, width: cellWidth, height: cellHeight)
            secondContainer.cell.frame = firstContainer.cell.frame.offsetBy(dx: 0, dy: bounds.height)
            thirdContainer.cell.frame = secondContainer.cell.frame.offsetBy(dx: 0, dy: bounds.height)
        }
    }
    
    func onGetDatas() {
        let dataCount = dataSource?.numberOfDatas() ?? 0
        scrollView.isScrollEnabled = dataCount > 1
        switch dataCount {
        case 0:
            [firstContainer, secondContainer, thirdContainer].forEach { $0.cell.isHidden = true }
        case 1:
            [firstContainer, thirdContainer].forEach { $0.cell.isHidden = true }
            secondContainer.cell.isHidden = false
        default:
            [firstContainer, secondContainer, thirdContainer].forEach { $0.cell.isHidden = false }
        }
        if bounds.isEmpty {
            setNeedsLayout()
            layoutIfNeeded()
        } else {
            switch (dataSource?.isHorizontalScroll() ?? true) {
            case true:
                scrollView.contentOffset = CGPoint(x: bounds.width, y: 0)
            case false:
                scrollView.contentOffset = CGPoint(x: 0, y: bounds.height)
            }
        }
        delegate?.willScroll(to: 0)
        currentIndex = 0
    }
    
    func onChangeCurrentIndex() {
        let dataCount = dataSource?.numberOfDatas() ?? 0
        delegate?.didScroll(to: currentIndex)
        switch dataCount {
        case 0:
            return
        case 1:
            secondContainer.index = 0
            delegate?.displayCell(secondContainer.cell, atIndex: 0)
        default:
            let preIndex = (currentIndex - 1 + dataCount) % dataCount
            firstContainer.index = preIndex
            delegate?.displayCell(firstContainer.cell, atIndex: preIndex)
            secondContainer.index = currentIndex
            delegate?.displayCell(secondContainer.cell, atIndex: currentIndex)
            let nextIndex = (currentIndex + 1) % dataCount
            thirdContainer.index = nextIndex
            delegate?.displayCell(thirdContainer.cell, atIndex: nextIndex)
        }
    }
    
    func adjustWhenEndScrolling(animation: Bool) {
        let dataCount = dataSource?.numberOfDatas() ?? 0
        if dataCount == 0 {
            return
        }
        if !animation {
            delegate?.scrollViewDidEndDecelerating()
        }
        let offset = scrollView.contentOffset
        let storeCurrentIndex = currentIndex
        var nextIndex = currentIndex
        switch (dataSource?.isHorizontalScroll() ?? true) {
        case true:
            if offset.x == 0 {
                nextIndex = (currentIndex - 1 + dataCount) % dataCount
                scrollView.contentOffset = CGPoint(x: bounds.width, y: 0)
            } else if offset.x == bounds.width * 2 {
                nextIndex = (currentIndex + 1) % dataCount
                scrollView.contentOffset = CGPoint(x: bounds.width, y: 0)
            }
        case false:
            if offset.y == 0 {
                nextIndex = (currentIndex - 1 + dataCount) % dataCount
                scrollView.contentOffset = CGPoint(x: 0, y: bounds.height)
            } else if offset.y == bounds.height * 2 {
                nextIndex = (currentIndex + 1) % dataCount
                scrollView.contentOffset = CGPoint(x: 0, y: bounds.height)
            }
        }
        delegate?.onScroll(from: storeCurrentIndex, to: nextIndex, progress: 1.0)
        willScrollIndex = -1
        currentIndex = nextIndex
    }
}
