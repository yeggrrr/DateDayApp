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
        
        toastLabel.backgroundColor = UIColor.primaryDark.withAlphaComponent(0.7)
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
    
    func okShowAlert(title: String, message: String, completion: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: completion)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    func updateToken() {
        // 로그인 시, 저장한 시간
        let stringSaveTime = UserDefaultsManager.shared.saveTime
        // 저장한 시간 Date로 변환
        guard let dateSaveTime = DateFormatter.stringToDateFormatter.date(from: stringSaveTime) else { return }
        // 저장 시간 9분 45초 후, Date 정보
        let justBeforeTokenExpiration = Date(timeInterval: 585, since: dateSaveTime)
        // 만약, 9분 45초가 지났다면?
        if justBeforeTokenExpiration < Date() {
            print("곧 만료됨! 갱신 준비!")
            NetworkManager.shared.tokenUpdate { result in
                switch result {
                case .success(let success):
                    UserDefaultsManager.shared.token = success.accessToken
                case .failure(let failure):
                    switch failure {
                    case .refreshTokenExpiration:
                        self.setRootViewController(LoginViewController())
                    default:
                        break
                    }
                }
            }
        } else {
            print("아직 만료 안됨! 굳이 갱신 X")
        }
    }
}
