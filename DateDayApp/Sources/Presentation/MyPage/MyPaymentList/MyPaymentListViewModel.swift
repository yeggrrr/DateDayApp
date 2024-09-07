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
    private let disposeBag = DisposeBag()
    
    struct Input {
        let paymentListData = PublishSubject<[PaymentListModel.PaymentData]>()
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
                    input.paymentListData.onNext(success.data)
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
            paymentListData: input.paymentListData,
            tokenExpiredMessage: input.tokenExpiredMessage)
    }
}
