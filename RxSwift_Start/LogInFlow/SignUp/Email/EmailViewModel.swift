//
//  EmailViewModel.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/6/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EmailViewModel {
    struct Input {
        let email: ControlProperty<String>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let isEmailValid: Observable<Bool>
        let tap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let isEmailValid = input.email
            .map(matchesEmailPattern)
        
        return Output(
            isEmailValid: isEmailValid,
            tap: input.tap
        )
    }
    
    private func matchesEmailPattern(_ string: String) -> Bool {
        do {
            let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let regex = try NSRegularExpression(pattern: emailPattern)
            let range = NSRange(location: 0, length: string.utf16.count)
            return regex.firstMatch(in: string, options: [], range: range) != nil
        } catch {
            print(error)
            return false
        }
    }
}


