//
//  DetailViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit
import iamport_ios

final class DetailViewController: UIViewController {
    // MARK: UI
    private let detailView = DetailView()
    
    // MARK: Properties
    var postID = BehaviorSubject(value: "")
    private var InterestBtnInitialState: Bool?
    private var isChangeInterestBtnState: Bool?
    weak var delegate: ButtonStateDelegate?
    
    private let viewModel = DetailViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        InterestBtnInitialState = detailView.interestButton.isSelected
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let currentInterestBtnState = detailView.interestButton.isSelected
        
        if InterestBtnInitialState == currentInterestBtnState {
            isChangeInterestBtnState = false
        } else {
            isChangeInterestBtnState = true
        }
        
        delegate?.buttonStateChangedOrNot(isChanged: isChangeInterestBtnState)
    }
    
    // MARK: Functions
    private func configure() {
        // collectionView
        detailView.collectionView.register(DetailCell.self, forCellWithReuseIdentifier: DetailCell.id)
        detailView.collectionView.isPagingEnabled = true
    }
    
    private func bind() {
        let input = DetailViewModel.Input(
            moveToDetailButtonTap: detailView.moveToDetailButton.rx.tap,
            reservationButtonTap: detailView.reservationButton.rx.tap,
            interestButtonTap: detailView.interestButton.rx.tap,
            likeButtonTap: detailView.likeButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        // Detail 정보
        postID
            .bind(with: self) { owner, value in
                owner.viewModel.postID.onNext(value)
                NetworkManager.shared.viewSpecificPost(postID: value)
                    .subscribe(with: self) { owner, result in
                        switch result {
                        case .success(let success):
                            if let latitude = Double(success.latitude),
                               let longitude = Double(success.longitude) {
                                owner.detailView.createAnnotaion(title: success.title, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                            }
                            
                            owner.viewModel.imageFiles.onNext(success.imageFiles)
                            owner.viewModel.isInterestIdList.onNext(success.interest)
                            owner.viewModel.isLikeIdList.onNext(success.likes)
                            owner.viewModel.detailData.onNext(success)
                            owner.navigationItem.title = success.title
                            owner.detailView.reviewLabel.text = success.content
                            let createdAt = DateFormatter.dateToContainLetter(dateString: success.createdAt)
                            owner.detailView.createdAtLabel.text = "\(createdAt) 작성됨"                            
                        case .failure(let failure):
                            switch failure {
                            case .accessTokenExpiration:
                                owner.updateToken()
                            default:
                                break
                            }
                        }
                    } onFailure: { owner, error in
                        print("error: \(error)")
                    } onDisposed: { owner in
                        print("DetailVC bind - Disposed")
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        // Detail 이미지
        output.imageDatas
            .bind(to: detailView.collectionView.rx.items(cellIdentifier: DetailCell.id, cellType: DetailCell.self)) { (row, element, cell) in
                cell.postImageView.image = UIImage(data: element)
            }
            .disposed(by: disposeBag)
        
        output.isInterestIdList
            .bind(with: self) { owner, interestedList in
                interestedList.forEach { userID in
                    if userID == UserDefaultsManager.shared.saveLoginUserID {
                        owner.detailView.interestButton.isSelected = true
                    }
                }
            }
            .disposed(by: disposeBag)
        
        output.isLikeIdList
            .bind(with: self) { owner, likedList in
                likedList.forEach { userID in
                    if userID == UserDefaultsManager.shared.saveLoginUserID {
                        owner.detailView.likeButton.isSelected = true
                    }
                }
            }
            .disposed(by: disposeBag)
        
        // 관심 목록 추가 버튼
        Observable.combineLatest(output.interestButtonTap, postID)
            .bind(with: self) { owner, value in
                
                owner.detailView.interestButton.isSelected.toggle()
                let buttonStatus = owner.detailView.interestButton.isSelected
                
                NetworkManager.shared.postInterestStatus(interestStatus: buttonStatus, postID: value.1)
                    .subscribe(with: self) { owner, result in
                        switch result {
                        case .success(let success):
                            owner.detailView.interestButton.isSelected = success.likeStatus
                            input.interestStatus.onNext(success.likeStatus)
                        case .failure(let failure):
                            switch failure {
                            case .accessTokenExpiration:
                                owner.updateToken()
                            default:
                                break
                            }
                        }
                    } onFailure: { owner, error in
                        print("error: \(error)")
                    } onDisposed: { owner in
                        print("DetailVC - interestButtonTap Disposed")
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.interestStatus
            .bind(with: self) { owner, value in
                if value {
                    owner.showToast(message: "관심 목록에 추가되었습니다! :)", heightY: 500, delayTime: 0.5)
                }
            }
            .disposed(by: disposeBag)
        
        // 좋아요 버튼 클릭
        Observable.combineLatest(output.likeButtonTap, postID)
            .bind(with: self) { owner, value in
                owner.detailView.likeButton.isSelected.toggle()
                let buttonStatus  = owner.detailView.likeButton.isSelected
                
                NetworkManager.shared.postLikeStatus(likeStatus: buttonStatus, postID: value.1)
                    .subscribe(with: self) { owner, result in
                        switch result {
                        case .success(let success):
                            owner.detailView.likeButton.isSelected = success.likeStatus
                            input.likeStatus.onNext(success.likeStatus)
                        case .failure(let failure):
                            switch failure {
                            case .accessTokenExpiration:
                                owner.updateToken()
                            default:
                                break
                            }
                        }
                    } onFailure: { owner, error in
                        print("error: \(error)")
                    } onDisposed: { owner in
                        print("DetailVC - interestButtonTap Disposed")
                    }
                    .disposed(by: owner.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        output.likdStatus
            .bind(with: self) { owner, value in
                if value {
                    owner.showImageToast(imageSysName: "heart.fill")
                }
            }
            .disposed(by: disposeBag)
        
        // 페이원 결제 요청
        output.reservationButtonTap
            .withLatestFrom(viewModel.detailData)
            .bind(with: self) { owner, value in
                owner.requestPayment(itemName: value.title)
            }
            .disposed(by: disposeBag)
        
        // 결제 완료 메세지
        output.paymentSuccessfulMessage
            .bind(with: self) { owner, value in
                owner.showToast(message: value)
            }
            .disposed(by: disposeBag)
        
        // 결제 실패 시, 메세지
        output.paymentResultMessage
            .bind(with: self) { owner, value in
                owner.showToast(message: value)
            }
            .disposed(by: disposeBag)
        
        // 토큰 업데이트
        output.tokenExpiredMessage
            .bind(with: self) { owner, value in
                owner.showToast(message: value)
            }
            .disposed(by: disposeBag)
        
        // WebView 이동
        Observable.combineLatest(output.moveToDetailButtonTap, viewModel.detailData)
            .bind(with: self) { owner, value in
                let vc = DetailWebViewController()
                vc.detailLink = value.1.detailURL
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    // 페이원 결제 메서드
    func requestPayment(itemName: String) {
        let payment = IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: "ios_\(APIKey.secretkey)_\(Int(Date().timeIntervalSince1970))",
            amount: "100").then {
                $0.pay_method = PayMethod.card.rawValue
                $0.name = itemName
                $0.buyer_name = "김예진"
                $0.app_scheme = "sesac"
            }
        
        guard let navigationController = navigationController else { return }
        
        Iamport.shared.payment(
            navController: navigationController,
            userCode: APIKey.userCode,
            payment: payment)
        { [weak self] iamportResponse in
            print("결제가 완료됨.")
            self?.viewModel.impUID.onNext(iamportResponse?.imp_uid)
        }
    }
}

// MARK: ButtonStateDelegate
protocol ButtonStateDelegate: AnyObject {
    func buttonStateChangedOrNot(isChanged: Bool?)
}
