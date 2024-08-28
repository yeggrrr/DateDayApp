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
    var selectedImages = PublishSubject<[UIImage]>()
    var selectedImageList: [UIImage] = []
    var selectData = PublishSubject<SelectData>()
    var selectLocationData: SelectData?
    
    var successUploadImages = PublishSubject<[String]>()
    
    let viewModel = writeViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configure()
        bind()
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
        writeView.hashTagCollectionView.showsHorizontalScrollIndicator = false
        
        // starRatingView
        writeView.starRatingView.didTouchCosmos = didTouchCosmos
    }
    
    private func bind() {
        let input = writeViewModel.Input(searchLocationButtonTap: writeView.searchLocationButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.hashTagList
            .bind(to: writeView.hashTagCollectionView.rx.items(cellIdentifier: WriteCell.id, cellType: WriteCell.self)) { (row, element, cell) in
                cell.hashTagLabel.text = element.atelierName
            }
            .disposed(by: disposeBag)
        
        writeView.hashTagCollectionView.rx.modelSelected(HashTagModel.self)
            .bind(with: self) { owner, value in
                owner.writeView.reviewTextView.text.append(" \(value.atelierName)")
            }
            .disposed(by: disposeBag)
        
        output.searchLocationButtonTap
            .bind(with: self) { owner, _ in
                let vc = SearchLocationViewController()
                vc.delegate = self
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        selectData
            .bind(with: self) { owner, selectedData in
                owner.writeView.titleLabel.text = selectedData.placeName
            }
            .disposed(by: disposeBag)
        
        successUploadImages
            .bind(with: self) { owner, files in
                guard let locationData = owner.selectLocationData else { return }
                guard let ratingValue = owner.writeView.ratingLabel.text else { return }
                
                let uploadPostQuery = UploadPostQuery(
                    title: locationData.placeName,
                    content: owner.writeView.reviewTextView.text + " #\(locationData.placeName)",
                    content1: ratingValue,
                    content2: locationData.longitude,
                    content3: locationData.latitude,
                    content4: locationData.placeURL,
                    content5: locationData.categoryName,
                    files: files)
                
                NetworkManager.shared.uploadPost(uploadQuery: uploadPostQuery)
                    .subscribe(with: self) { owner, result in
                        switch result {
                        case .success(_):
                            owner.okShowAlert(title: "업로드 성공!", message: "") { _ in
                                let vc = DateDayTabBarController(showLoginAlert: false)
                                owner.setRootViewController(vc)
                            }
                        case .failure(let failure):
                            switch failure {
                            case .missingRequiredValue:
                                owner.showToast(message: "유효하지 않은 값타입입니다.")
                            case .mismatchOrInvalid:
                                owner.showToast(message: "인증할 수 없는 엑세스 토큰입니다.")
                            case .forbidden:
                                owner.showToast(message: "접근권한이 없습니다.")
                            case .serverErrorNotSavedOrCannotSearch:
                                owner.showToast(message: "생성된 게시글이 없습니다.")
                            case .accessTokenExpiration:
                                owner.updateToken()
                            default:
                                break
                            }
                        }
                    } onFailure: { owner, error in
                        print("error: \(error)")
                    } onDisposed: { owner in
                        print("Disposed")
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    private func rightBarButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setTitle("공유하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        button.rx.tap
            .bind(with: self) { owner, _ in
                owner.selectedImages.onNext(owner.selectedImageList)
            }
            .disposed(by: disposeBag)
        
        selectedImages
            .bind(with: self) { owner, images in
                NetworkManager.shared.uploadImage(images: images)
                    .subscribe(with: self) { owner, result in
                        switch result {
                        case .success(let success):
                            owner.successUploadImages.onNext(success.files)
                        case .failure(let failure):
                            switch failure {
                            case .missingRequiredValue:
                                owner.showToast(message: "잘못된 요청입니다.")
                            case .mismatchOrInvalid:
                                owner.showToast(message: "인증할 수 없는 엑세스 토큰입니다.")
                            case .forbidden:
                                owner.showToast(message: "접근권한이 없습니다.")
                            case .accessTokenExpiration:
                                owner.updateToken()
                            default:
                                break
                            }
                        }
                    } onFailure: { owner, error in
                        print("error: \(error)")
                    } onDisposed: { owner in
                        print("Disposed")
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)

        return UIBarButtonItem(customView: button)
    }
    
    private class func formatValue(_ value: Double) -> String {
        return String(format: "%.1f", value)
    }
    
    private func didTouchCosmos(_ rating: Double) {
        writeView.ratingLabel.text = WriteViewController.formatValue(rating)
        writeView.ratingLabel.textColor = .black
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        writeView.ratingLabel.text = WriteViewController.formatValue(rating)
        writeView.ratingLabel.textColor = .black
    }
}

// MARK: UITextViewDelegate
extension WriteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
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

extension WriteViewController: SelectDataDelegate {
    func sendSelectedData(selectedData: SelectData) {
        selectData.onNext(selectedData)
        selectLocationData = selectedData
    }
}
