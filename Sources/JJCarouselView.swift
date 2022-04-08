//
//  JJCarouselView.swift
//  JJCarouselView
//
//  Created by 郑桂杰 on 2022/4/8.
//

import UIKit

public final class JJCarouselView<Cell: UIView, Object: Equatable>: UIView, UIScrollViewDelegate {
    /// 配置
    public var config = Config()
    
    /// 数据源
    public var datas: [Object] = [] {
        didSet {
            onGetDatas(old: oldValue, new: datas)
        }
    }
    
    /// 点击回调
    public var onTap: ((Object, Int) -> ())?
    
    /// 用于设置轮播图的
    public var pageView: JJCarouselViewPageable = JJCarouselDotPageView() {
        didSet {
            oldValue.removeFromSuperview()
            pageView.numberOfPages = datas.count
            insertSubview(pageView, aboveSubview: scrollView)
        }
    }
    
    internal var currentFrame = CGRect.zero {
        didSet {
            if currentFrame != oldValue {
                onChangeFrame()
            }
        }
    }
    
    internal var currentIndex = 0 {
        didSet {
            onChangeCurrentIndex()
        }
    }
    
    /// 初始化
    /// - Parameters:
    ///   - frame: frame
    ///   - initialize: 初始化单个内容容器的方法。如果`nil`,则按照其初始化方法`init(frame: CGRect)`来初始化
    public init(frame: CGRect, initialize: (() -> Cell)?) {
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
        super.init(frame: frame)
        scrollView.isScrollEnabled = false
        scrollView.delegate = self
        addSubview(scrollView)
        [firstContainer, secondContainer, thirdContainer].forEach { [unowned self] obj in
            obj.cell.isHidden = true
            obj.onTap = { [unowned self] idx in
                self.onTap?(self.datas[idx], idx)
            }
            self.scrollView.addSubview(obj.cell)
        }
        addSubview(pageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 组件
    internal let scrollView: UIScrollView
    internal let firstContainer: CellContainer
    internal let secondContainer: CellContainer
    internal let thirdContainer: CellContainer
    
    // MARK: - 属性
    internal var preScrollcontentOffset = CGPoint.zero
    internal var timer: Timer?
    internal var didEnterBackgroundObserver: NSObjectProtocol?
    internal var willEnterForegroundObserver: NSObjectProtocol?
    
    // MARK: - cycle Life
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        currentFrame = bounds
        layoutCells()
    }
    
    deinit {
        destoryTimer()
    }
    
    // MARK: - UIScrollViewDelegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        if offset == preScrollcontentOffset {
            return
        }
        switch config.direction {
        case .horizontal:
            if offset.x == 0 {
                currentIndex = (currentIndex - 1 + datas.count) % datas.count
                scrollView.contentOffset = CGPoint(x: bounds.width, y: 0)
            } else if offset.x == bounds.width * 2 {
                currentIndex = (currentIndex + 1) % datas.count
                scrollView.contentOffset = CGPoint(x: bounds.width, y: 0)
            }
        case .vertical:
            if offset.y == 0 {
                currentIndex = (currentIndex - 1 + datas.count) % datas.count
                scrollView.contentOffset = CGPoint(x: 0, y: bounds.height)
            } else if offset.y == bounds.height * 2 {
                currentIndex = (currentIndex + 1) % datas.count
                scrollView.contentOffset = CGPoint(x: 0, y: bounds.height)
            }
        }
        preScrollcontentOffset = offset
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if config.autoLoop {
            pauseTimer()
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(resumeTimer), object: nil)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if config.autoLoop {
            perform(#selector(resumeTimer), with: nil, afterDelay: config.loopTimeInterval)
        }
    }
    
    // MARK: - 私有方法
    
    /// 重启定时器
    @IBAction internal func resumeTimer() {
        timer?.fireDate = Date()
    }
}
