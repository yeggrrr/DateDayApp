//
//  WriteViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class WriteViewController: UIViewController {
    // MARK: UI
    let writeView = WriteView()
    
    // MARK: Properties
    let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configure()
        
    }
    
    private func configure() {
        navigationItem.rightBarButtonItem = rightBarButtonItem()
        navigationItem.title = "리뷰 작성"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    private func rightBarButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setTitle("공유하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        button.rx.tap
            .bind(with: self) { owner, _ in
                print("포스트 업로드")
            }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: button)
    }
}
