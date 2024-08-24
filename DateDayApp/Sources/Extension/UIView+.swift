//
//  UIView+.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import UIKit
import Cosmos

extension UIView {
    func basicUI(cornerRadius: CGFloat = 0) {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        backgroundColor = .white
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
