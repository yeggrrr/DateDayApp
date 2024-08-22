//
//  SelectPhotoViewModel.swift
//  DateDayApp
//
//  Created by YJ on 8/23/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SelectPhotoViewModel: BaseViewModel {
    
    struct Input {
        let addImageButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let addImageButtonTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output(addImageButtonTap: input.addImageButtonTap)
    }
}
