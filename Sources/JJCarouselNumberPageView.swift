//
//  JJCarouselNumberPageView.swift
//  JJCarouselView
//
//  Created by 郑桂杰 on 2022/4/8.
//

import UIKit

/// 数字化轮播图page指示器。具体变现为:   1/6
public final class JJCarouselNumberPageView: UIView, JJCarouselViewPageable {
    public var hidesForSinglePage: Bool = true
    
    public var numberOfPages: Int = 0 {
        didSet {
            isHidden = (numberOfPages > 1) ? false : hidesForSinglePage
            totalLabel.text = "\(numberOfPages)"
            totalLabel.sizeToFit()
        }
    }
    
    public var currentPage: Int = 0 {
        didSet {
            currentLabel.text = "\(currentPage + 1)"
            currentLabel.sizeToFit()
        }
    }
    
    public var pageIndicatorTintColor: UIColor? {
        didSet {
            totalLabel.textColor = pageIndicatorTintColor
        }
    }
    
    public var dotTintColor: UIColor? = UIColor.white {
        didSet {
            dotLabel.textColor = dotTintColor
        }
    }
    
    public var currentPageIndicatorTintColor: UIColor? {
        didSet {
            currentLabel.textColor = currentPageIndicatorTintColor
        }
    }
    
    /// 字体大小
    public var font = UIFont.systemFont(ofSize: 11) {
        didSet {
            dotLabel.font = font
            currentLabel.font = font
            totalLabel.font = font
            currentLabel.sizeToFit()
            dotLabel.sizeToFit()
            totalLabel.sizeToFit()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private lazy var currentLabel = UILabel()
    private lazy var dotLabel = UILabel()
    private lazy var totalLabel = UILabel()
    
    public func size(forNumberOfPages pageCount: Int) -> CGSize {
        return sizeThatFits(.zero)
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let w = dotLabel.bounds.width + totalLabel.bounds.width * 2
        let h = max(currentLabel.bounds.height, totalLabel.bounds.width)
        return CGSize(width: w + 16, height: h + 8)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height * 0.5
        
        dotLabel.frame = CGRect(x: (bounds.width - dotLabel.bounds.width) * 0.5, y: (bounds.height - dotLabel.bounds.height) * 0.5, width: dotLabel.bounds.width, height: dotLabel.bounds.height)

        currentLabel.frame = CGRect(x: dotLabel.frame.minX - currentLabel.frame.width - 2, y:  (bounds.height - currentLabel.bounds.height) * 0.5, width: currentLabel.bounds.width, height: currentLabel.bounds.height)
        
        totalLabel.frame = CGRect(x: dotLabel.frame.maxX + 2, y:  (bounds.height - totalLabel.bounds.height) * 0.5, width: totalLabel.bounds.width, height: totalLabel.bounds.height)
    }
    
    private func setup() {
        dotLabel.text = "/"
        currentLabel.text = " "
        totalLabel.text = " "
        pageIndicatorTintColor = .white
        currentPageIndicatorTintColor = .white
        dotTintColor = .white
        font = UIFont.systemFont(ofSize: 11)
        currentLabel.textAlignment = .right
        totalLabel.textAlignment = .left
        [currentLabel, dotLabel, totalLabel].forEach { self.addSubview($0) }
        clipsToBounds = true
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
}
