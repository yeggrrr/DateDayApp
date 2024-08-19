//
//  UISearchBar+.swift
//  DateDayApp
//
//  Created by YJ on 8/19/24.
//

import UIKit

extension UISearchBar {
    func setUI(placeholder: String) {
        showsCancelButton = true
        backgroundColor = .white
        barTintColor = .black
        searchBarStyle = .minimal
        searchTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        searchTextField.leftView?.tintColor = .black
        searchTextField.textColor = .black
        keyboardType = .asciiCapable
        keyboardAppearance = .light
    }
}