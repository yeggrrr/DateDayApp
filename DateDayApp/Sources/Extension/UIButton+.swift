//
//  UIButton+.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import UIKit

extension UIButton {
    func roundUI(title: String, bgColor: UIColor, borderColor: CGColor, borderWidth: CGFloat = 1) {
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        backgroundColor = bgColor
        layer.cornerRadius = 20
        layer.borderColor = borderColor
        layer.borderWidth = borderWidth
    }
    
    func basicUI(title: String, color: UIColor) {
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
    }
}
