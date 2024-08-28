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
}
