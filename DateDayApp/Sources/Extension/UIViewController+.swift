//
//  UIViewController+.swift
//  DateDayApp
//
//  Created by YJ on 8/17/24.
//

import UIKit

extension UIViewController {
    // 화면 전환
    func setRootViewController(_ viewController: UIViewController) {
        if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
        let window = scene.window {
            window.rootViewController = viewController
            UIView.transition(with: window, duration: 0.5, options: [.transitionFlipFromRight], animations: nil, completion: nil)
        }
    }
    
    // Custom ToastAlert
    func showToast(message : String, heightY: CGFloat = 100, delayTime: TimeInterval = 0.5) {
        let toastLabel = UILabel(
            frame: CGRect(x: view.frame.size.width / 2 - 160,
                          y: view.frame.size.height - heightY,
                          width: 320,
                          height: 40))
        
        toastLabel.backgroundColor = UIColor.primaryButtonBg.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: delayTime, options: .curveLinear, animations: {
            toastLabel.alpha = 0.0
        }, completion: { isCompleted in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showImageToast(imageSysName: String, delayTime: TimeInterval = 0.5) {
        let safeArea = view.safeAreaLayoutGuide
        let toastView = UIView()
        
        let imageView = UIImageView(image: UIImage(systemName: imageSysName))
        imageView.tintColor = UIColor.white.withAlphaComponent(0.7)
        
        toastView.backgroundColor = .clear
        toastView.alpha = 1.0
        toastView.layer.cornerRadius = 20
        toastView.clipsToBounds = true
        
        view.addSubview(toastView)
        toastView.addSubview(imageView)
        toastView.snp.makeConstraints {
            $0.centerX.equalTo(safeArea.snp.centerX)
            $0.centerY.equalTo(safeArea.snp.centerY).offset(-80)
            $0.height.width.equalTo(100)
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalTo(toastView.snp.edges).inset(5)
        }

        UIView.animate(withDuration: 3.0, delay: delayTime, options: .curveLinear, animations: {
            toastView.alpha = 0.0
        }, completion: { isCompleted in
            toastView.removeFromSuperview()
        })
    }
    
    func okShowAlert(title: String, message: String, completion: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: completion)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    func okCanelShowAlert(title: String, message: String = "", completion: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "예", style: .default, handler: completion)
        let cancelButton = UIAlertAction(title: "아니오", style: .cancel)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
}
