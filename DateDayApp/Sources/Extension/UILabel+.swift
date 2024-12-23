//
//  UILabel+.swift
//  DateDayApp
//
//  Created by YJ on 8/17/24.
//

import UIKit

extension UILabel {
    // Line spacing
    func setLineSpacing(_ lineSpacing: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        let attributedString: NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
    
    func setUI(txt: String = "", txtAlignment: NSTextAlignment = .left, font: UIFont, numOfLines: Int = 0, txtColor: UIColor) {
        text = txt
        self.textAlignment = txtAlignment
        self.font = font
        numberOfLines = numOfLines
        textColor = txtColor
    }
}
