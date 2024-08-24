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
    let viewModel = writeViewModel()
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
        // navigation
        navigationItem.rightBarButtonItem = rightBarButtonItem()
        navigationItem.title = "리뷰 작성"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        
        // textView
        writeView.reviewTextView.delegate = self
        
        // collectionView
        writeView.hashTagCollectionView.register(WriteCell.self, forCellWithReuseIdentifier: WriteCell.id)
    }
    
    private func bind() {
        let input = writeViewModel.Input()
        let output = viewModel.transform(input: input)
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

extension WriteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        print(text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .secondaryLabel else { return }
                textView.text = nil
                textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == writeView.reviewTextView {
            guard let text = textView.text else { return }
            if text.isEmpty {
                textView.text = writeView.placeholder
                textView.textColor = .lightGray
            }
        }
    }
}
