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
        let tokenExpiredMessage = PublishSubject<String>()
    }
    
    struct Output {
        let paymentListData: PublishSubject<[PaymentListModel.PaymentData]>
        let tokenExpiredMessage: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        
        NetworkManager.shared.viewPaymentList()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.paymentListData.onNext(success.data)
                case .failure(let failure):
                    switch failure {
                    case .accessTokenExpiration:
                        input.tokenExpiredMessage.onNext("엑세스 토큰이 만료되었습니다.")
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
            paymentListData: paymentListData,
            tokenExpiredMessage: input.tokenExpiredMessage)
    }
    
    func updateData() {
        NetworkManager.shared.viewPaymentList()
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
