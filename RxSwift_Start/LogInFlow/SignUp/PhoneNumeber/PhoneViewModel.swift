//
//  PhoneViewModel.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/6/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneViewModel {
    
    struct Input {
        let phoneNumber: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    struct Output {
        let initialNumber: Observable<String>
        let validationResults: Observable<(String, Bool)>
        let tap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let initialNumber = Observable.just("010")
        
        let numericValidation = input.phoneNumber.orEmpty
            .map { Int($0) != nil }
        
        let countValidation = input.phoneNumber.orEmpty
            .map { $0.count >= 10 }
        
        let validationResults = Observable.combineLatest(numericValidation, countValidation)
            .map { isNumber, isLength in
                if !isNumber {
                    return (Phrase.onlyNumeric, false)
                } else if !isLength {
                    return (Phrase.minimumNumberCount, false)
                } else {
                    return (Phrase.validNumber, true)
                }
            }
        
        return Output(initialNumber: initialNumber, validationResults: validationResults,
                      tap: input.tap)
    }
}
