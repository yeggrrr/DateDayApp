//
//  UIStackView+.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import UIKit

extension UIStackView {
    func setUI(axis: NSLayoutConstraint.Axis, distribution: Distribution, alignment: Alignment, spacing: CGFloat = 0) {
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
    }
    
    func basicUI(axis: NSLayoutConstraint.Axis = .horizontal, spacing: CGFloat = 5) {
        self.axis = axis
        self.spacing = spacing
    }
}
