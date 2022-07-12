//
//  UIColor+Extension.swift
//  JJCarouselView
//
//  Created by 郑桂杰 on 2022/4/21.
//

import UIKit

extension UIColor {
    func mix(secondColor color: UIColor, secondColorRatio ratio: Float) -> UIColor {
        let rio = CGFloat(ratio > 1 ? 1 : (ratio < 0) ? 0 : ratio)
        
        var fr: CGFloat = 0
        var fg: CGFloat = 0
        var fb: CGFloat = 0
        var fa: CGFloat = 0
        
        var sr: CGFloat = 0
        var sg: CGFloat = 0
        var sb: CGFloat = 0
        var sa: CGFloat = 0
        
        guard getRed(&fr, green: &fg, blue: &fb, alpha: &fa),
              color.getRed(&sr, green: &sg, blue: &sb, alpha: &sa) else {
            return color
        }
        let r = fr * (1 - rio) + sr * rio
        let g = fg * (1 - rio) + sg * rio
        let b = fb * (1 - rio) + sb * rio
        let a = fa * (1 - rio) + sa * rio
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    static func random() -> UIColor {
        return UIColor(hue: CGFloat(arc4random() % 256) / 256.0, saturation: CGFloat(arc4random() % 128) / 256.0 + 0.5, brightness: CGFloat(arc4random() % 128) / 256.0 + 0.5, alpha: 1)
    }
}
