//
//  UIButton+.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import UIKit

extension UIButton {
    func roundUI(title: String, titleColor: UIColor = .black, bgColor: UIColor, font: UIFont, borderColor: CGColor, borderWidth: CGFloat = 1) {
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = font
        backgroundColor = bgColor
        layer.cornerRadius = 20
        layer.borderColor = borderColor
        layer.borderWidth = borderWidth
    }
    
    func basicUI(title: String, color: UIColor) {
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
    }
    
    func squareUI(bgColor: UIColor, title: String, titleColor: UIColor, cornerRadius: CGFloat, borderColor: CGColor, borderWidth: CGFloat) {
        backgroundColor = bgColor
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor
        layer.borderWidth = borderWidth
    }
    
    func markUpdateUI() {
        tintColor = .primaryButtonBg
        backgroundColor = .primaryButtonBg
        layer.cornerRadius = 5
        setImage(UIImage(systemName: "bookmark")?.withTintColor(.white, renderingMode: .alwaysOriginal),
                                for: .normal)
        setImage(UIImage(systemName: "bookmark")?.withTintColor(.white, renderingMode: .alwaysOriginal),
                                for: .highlighted)
        setImage(UIImage(systemName: "bookmark.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal),
                                for: .selected)
        setBackgroundColor(color: .primaryButtonBg, forState: .normal)
        setBackgroundColor(color: .primaryButtonBg, forState: .highlighted)
        setBackgroundColor(color: .primaryButtonBg, forState: .selected)
    }
}

extension UIButton {
    // 이미지 상태별 배경색상 변경
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}
