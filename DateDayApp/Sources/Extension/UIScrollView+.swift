//
//  UIScrollView+.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import UIKit

extension UIScrollView {
    func signUpUI() {
        backgroundColor = .systemGray6
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
        showsVerticalScrollIndicator = false
    }
}
