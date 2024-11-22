//
//  MyPaymentListViewModel.swift
//  DateDayApp
//
//  Created by YJ on 9/7/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPaymentListViewModel: BaseViewModel {
    let paymentListData = PublishSubject<[PaymentListModel.PaymentData]>()
    private let disposeBag = DisposeBag()
    
    struct Input {
        let refreshTokenExpiration = PublishSubject<Void>()
    }
    
    struct Output {
        let refreshTokenExpiration: PublishSubject<Void>
        let paymentListData: PublishSubject<[PaymentListModel.PaymentData]>
    }
    
    func transform(input: Input) -> Output {
        NetworkManager.shared.callRequest(api: Router.paymentList, type: PaymentListModel.self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.paymentListData.onNext(success.data)
                case .failure(let failure):
                    switch failure {
                    case .refreshTokenExpiration:
                        input.refreshTokenExpiration.onNext(())
                    default:
                        break
                    }
                }
            } onFailure: { owner, error in
                print("error: \(error)")
            } onDisposed: { owner in
                print("viewPayment Disposed")
            }
            .disposed(by: disposeBag)
        
        return Output(
            refreshTokenExpiration: input.refreshTokenExpiration,
            paymentListData: paymentListData
        )
    }
    
    func updateData() {
        NetworkManager.shared.callRequest(api: Router.paymentList, type: PaymentListModel.self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.paymentListData.onNext(success.data)
                case .failure(let failure):
                    switch failure {
                    case .accessTokenExpiration:
                        print("토큰 만료")
                    default:
                        break
                    }
                }
            } onFailure: { owner, error in
                print("error: \(error)")
            } onDisposed: { owner in
                print("viewPayment Disposed")
            }
            .disposed(by: disposeBag)
    }
}
