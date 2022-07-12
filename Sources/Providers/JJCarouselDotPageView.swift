//
//  JJCarouselDotPageView.swift
//  JJCarouselView
//
//  Created by zgjff on 2022/4/8.
//

import UIKit

/// 圆点轮播图page指示器。
public final class JJCarouselDotPageView: UIView, JJCarouselViewPageable {
    public var hidesForSinglePage: Bool = true
    public var numberOfPages: Int = 0 {
        didSet {
            isHidden = (numberOfPages > 1) ? false : hidesForSinglePage
            if numberOfPages != oldValue {
                dotLayers.forEach { $0.removeFromSuperlayer() }
                dotLayers = []
                createDotLayers()
            }
        }
    }
    
    public var currentPage: Int = 0 {
        didSet {
            if currentPage != oldValue {
                resetDotViewsColor()
            }
        }
    }
    
    public var pageIndicatorTintColor: UIColor? = UIColor.gray
    
    public var currentPageIndicatorTintColor: UIColor? = UIColor.white
    
    /// 圆点大小
    public var dotViewSize = CGSize(width: 6, height: 6)
    
    /// 圆点间距
    public var dotSpace: CGFloat = 4
    
    /// 轮播图滑动时,是否使用过渡混合色。默认`true`
    public var usingTransitionColorWhileScroll = true
    
    public func size(forNumberOfPages pageCount: Int) -> CGSize {
        return sizeThatFits(.zero)
    }
    
    public func onScroll(from fromIndex: Int, to toindex: Int, progress: Float) {
        if !usingTransitionColorWhileScroll {
            return
        }
        let currentColor = currentPageIndicatorTintColor ?? .clear
        let pageColor = pageIndicatorTintColor ?? .clear
        let fc = currentColor.mix(secondColor: pageColor, secondColorRatio: progress)
        dotLayers[fromIndex].backgroundColor = fc.cgColor
        let tc = pageColor.mix(secondColor: currentColor, secondColorRatio: progress)
        dotLayers[toindex].backgroundColor = tc.cgColor
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        if numberOfPages <= 1 {
            return dotViewSize
        }
        let w = (dotViewSize.width + dotSpace) * CGFloat(numberOfPages) - dotSpace
        return CGSize(width: w, height: dotViewSize.height)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let ty = (bounds.height - dotViewSize.height) * 0.5
        for (idx, pl) in dotLayers.enumerated() {
            pl.frame = CGRect(x: (dotViewSize.width + dotSpace) * CGFloat(idx), y: ty, width: dotViewSize.width, height: dotViewSize.height)
        }
    }
    
    private var dotLayers: [CALayer] = []
    
    private func createDotLayers() {
        if numberOfPages <= 0 {
            return
        }
        for idx in 0..<numberOfPages {
            let l = CALayer()
            l.frame = CGRect(origin: .zero, size: dotViewSize)
            l.cornerRadius = dotViewSize.height * 0.5
            l.masksToBounds = true
            l.backgroundColor = idx == currentPage ? currentPageIndicatorTintColor?.cgColor : pageIndicatorTintColor?.cgColor
            layer.addSublayer(l)
            dotLayers.append(l)
        }
    }
    
    private func resetDotViewsColor() {
        for (idx, pl) in dotLayers.enumerated() {
            pl.backgroundColor = idx == currentPage ? currentPageIndicatorTintColor?.cgColor : pageIndicatorTintColor?.cgColor
        }
    }
}
