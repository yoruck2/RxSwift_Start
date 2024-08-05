//
//  BirthdayViewModel.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/6/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let birthday: ControlProperty<Date>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let year: BehaviorRelay<Int>
        let month: BehaviorRelay<Int>
        let day: BehaviorRelay<Int>
        let validation: BehaviorRelay<Bool>
        let tap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let ageLimitForDay = 6210 // 만 17살이 살아온 일수
        let validation = BehaviorRelay(value: false)
        
        let year = BehaviorRelay(value: 2024)
        let month = BehaviorRelay(value: 8)
        let day = BehaviorRelay(value: 1)
        
        input.birthday
            .bind(with: self) { _, date in
                let component = Calendar.current.dateComponents(
                    [.day, .month, .year], from: date)
                
                year.accept(component.year!)
                month.accept(component.month!)
                day.accept(component.day!)
            }
            .disposed(by: disposeBag)
        
        input.birthday
            .bind(with: self) { [weak self] _, date in
                guard let self else { return }
                validation.accept(livedDays(from: date) >= ageLimitForDay)
            }
            .disposed(by: disposeBag)
        
        return Output(year: year,
                      month: month,
                      day: day,
                      validation: validation,
                      tap: input.tap)
    }
    
    private func livedDays(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
    }
}
