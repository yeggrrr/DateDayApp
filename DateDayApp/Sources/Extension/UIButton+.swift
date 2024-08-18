//
//  UIButton+.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import UIKit

extension UIButton {
    func roundUI(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        layer.cornerRadius = 20
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
    }
    
    func basicUI(title: String, color: UIColor) {
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
    }
}
