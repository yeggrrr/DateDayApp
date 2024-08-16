//
//  BaseViewModel.swift
//  DateDayApp
//
//  Created by YJ on 8/16/24.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
