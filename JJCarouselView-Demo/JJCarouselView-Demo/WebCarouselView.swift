//
//  WebCarouselView.swift
//  JJCarouselView-Demo
//
//  Created by zgjff on 2022/4/8.
//

import UIKit

final class WebCarouselView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .purple
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .orange
        titleLabel.text = " "
        titleLabel.sizeToFit()
        addSubview(titleLabel)
        descLabel.font = UIFont.systemFont(ofSize: 15)
        descLabel.textColor = .gray
        descLabel.text = " "
        descLabel.sizeToFit()
        addSubview(descLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 16, y: 30, width: bounds.width - 32, height: titleLabel.frame.height)
        descLabel.frame = CGRect(x: titleLabel.frame.minX, y: titleLabel.frame.maxY + 30, width: titleLabel.frame.width, height: descLabel.frame.height)
    }
    
    private(set) lazy var titleLabel = UILabel()
    private(set) lazy var descLabel = UILabel()
}
