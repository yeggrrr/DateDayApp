//
//  UITextView+.swift
//  DateDayApp
//
//  Created by YJ on 8/24/24.
//

import UIKit

extension UITextView {
    func setUI(font: UIFont, text: String) {
        self.font = font
        self.text = text
        self.textColor = .secondaryLabel
        textContainer.lineFragmentPadding = 10
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
    }
}
