//
//  MyIntroduceViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MyIntroduceViewController: UIViewController {
    // MARK: UI
    private let myIntroduceView = MyIntroduceView()
    
    // MARK: Properties
    let introduceText = BehaviorSubject(value: "")
    private let disposeBag = DisposeBag()

    // MARK: View Life Cycle
    override func loadView() {
        view = myIntroduceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        introduceText
            .bind(with: self) { owner, value in
                owner.myIntroduceView.introduceLabel.text = value
            }
            .disposed(by: disposeBag)
    }
}
