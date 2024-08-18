//
//  UITextField+.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import UIKit

extension UITextField {
    func setUI(placeholder: String, keyboardType: UIKeyboardType, tintColor: UIColor = .black ) {
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.tintColor = tintColor
    }
}
