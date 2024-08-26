//
//  UIView+.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import UIKit
import Cosmos

extension UIView {
    func basicUI(bgColor: UIColor = .white, cornerRadius: CGFloat = 0, borderWidth: CGFloat = 1, borderColor: CGColor = UIColor.black.cgColor) {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
        backgroundColor = bgColor
    }
}

extension CosmosView {
    func myCosmosUI() {
        rating = 5
        settings.fillMode = .half
        settings.starSize = 35
        settings.starMargin = 10
        settings.emptyBorderWidth = 1
        settings.filledColor = .primaryButtonBg
        settings.emptyBorderColor = .primaryBorder
        settings.filledBorderColor = .primaryBorder
    }
}
