//
//  JJCarouselDotPageView.swift
//  JJCarouselView
//
//  Created by 郑桂杰 on 2022/4/8.
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
    
    public var dotViewSize = CGSize(width: 6, height: 6)
    
    public var dotSpace: CGFloat = 4
    
    public func size(forNumberOfPages pageCount: Int) -> CGSize {
        return sizeThatFits(.zero)
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        if numberOfPages <= 1 {
            return dotViewSize
        }
        let w = (dotViewSize.width + dotSpace) * CGFloat(numberOfPages) - dotSpace
        return CGSize(width: w, height: dotViewSize.height + 8)
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
