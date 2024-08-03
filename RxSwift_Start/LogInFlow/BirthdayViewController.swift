//
//  BirthdayViewController.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/2/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class BirthdayViewController: RxBaseViewController {
    
    let birthDayPicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko-KR")
        $0.maximumDate = Date()
    }
    let infoLabel = UILabel().then {
        $0.text = "만 17세 이상만 가입 가능합니다."
    }
    let containerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 10
    }
    
    let yearLabel = UILabel()
    let monthLabel = UILabel()
    let dayLabel = UILabel()
    
    let nextButton = SignUpButton(title: "가입하기")
    
    var validation = BehaviorRelay(value: false)
    let infoLabelText = PublishSubject<String>()
    let year = BehaviorRelay(value: 2024)
    let month = BehaviorRelay(value: 8)
    let day = BehaviorRelay(value: 1)
    let ageLimitForDay = 6210 // 만 17살이 살아온 일수
    
    func livedDays(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
    }
    
    override func bind() {
        
        // MARK: 구독을 나누는 방법 -
//        // 구독자 ( infoLabelText 내용 바꾸기 )
//        validation
//            .map { $0 ? Phrase.validAge : Phrase.invalidAge }
//            .bind(to: infoLabelText)
//            .disposed(by: disposeBag)
//
//        // 구독자 ( 레이블에 반영하기 )
//        infoLabelText
//            .bind(to: infoLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        // 구독자 ( infoLabelText 색깔바꾸기 )
//        validation
//            .map { $0 ? Color.blue : Color.gray }
//            .bind(to: infoLabel.rx.textColor)
//            .disposed(by: disposeBag)
//
//        // 구독자 ( 버튼 활성화여부 반영하기 )
//        validation
//            .bind(to: nextButton.rx.isEnabled)
//            .disposed(by: disposeBag)
        
        validation.bind(with: self) { owner, value in
            owner.nextButton.isEnabled = value
            owner.infoLabel.text = value ? Phrase.validAge : Phrase.invalidAge
            owner.infoLabel.textColor = value ? Color.blue : Color.gray
        }
        .disposed(by: disposeBag)
        
        birthDayPicker.rx.date
            .bind(with: self) { owner, date in
                
                let component = Calendar.current.dateComponents(
                    [.day, .month, .year], from: date)
                
                if let year = component.year,
                   let month = component.month,
                   let day = component.day {
                    owner.year.accept(year)
                    owner.month.accept(month)
                    owner.day.accept(day)
                }
                
                let isValid = owner.livedDays(from: date) >= owner.ageLimitForDay
                owner.validation.accept(isValid)
            }
            .disposed(by: disposeBag)
        
        year
            .map { "\($0)년" }
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        month.bind(with: self) { owner, value in
            owner.monthLabel.text = "\(value)월"
        }
        .disposed(by: disposeBag)
        
        day.bind(with: self) { owner, value in
            owner.dayLabel.text = "\(value)일"
        }
        .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAlert()
            }
            .disposed(by: disposeBag)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "회원가입 완료",
                                      message: "회원가입이 완료 되었습니다!\n환영합니다!",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "로그인 하러 가기",
                               style: .default) { [weak self] _ in
            self?.changeRootVC(LogInViewController())
        }
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    override func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

