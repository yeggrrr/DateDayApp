//
//  SelectPhotoViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/19/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectPhotoViewController: UIViewController {
    // MARK: UI
    let selectPhotoView = SelectPhotoView()
    
    // MARK: Properties
    let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = selectPhotoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        navigationItem.rightBarButtonItem = rightBarButtonItem()
        navigationItem.title = "사진 선택"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    private func rightBarButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        button.rx.tap
            .bind(with: self) { owner, _ in
                let vc = WriteViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: button)
    }
}
