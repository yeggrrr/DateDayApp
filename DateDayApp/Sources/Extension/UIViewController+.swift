//
//  UIViewController+.swift
//  DateDayApp
//
//  Created by YJ on 8/17/24.
//

import UIKit

extension UIViewController {
    // Custom ToastAlert
    func showToast(message : String) {
        let toastLabel = UILabel(
            frame: CGRect(x: self.view.frame.size.width / 2 - 160,
                          y: self.view.frame.size.height - 100,
                          width: 320,
                          height: 40))
        
        toastLabel.backgroundColor = UIColor.systemGray.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.2, options: .curveLinear, animations: {
            toastLabel.alpha = 0.0
        }, completion: { isCompleted in
            toastLabel.removeFromSuperview()
        })
    }
}
