//
//  PasswordViewModel.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/6/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PasswordViewModel {
    struct Input {
        let password: ControlProperty<String>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let validationResult: Observable<(Bool, String)>
        let tap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let validationResult = input.password
            .map { text -> (Bool, String) in
                if text.contains(" ") {
                    return (false, "공백은 안됩니다!!")
                } else if text.count < 8 {
                    return (false, "8자 이상 입력해주세요!!")
                } else {
                    return (true, "")
                }
            }
        
        return Output(
            validationResult: validationResult,
            tap: input.tap
        )
    }
}
