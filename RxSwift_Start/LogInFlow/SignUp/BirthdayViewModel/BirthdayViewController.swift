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

final class BirthdayViewController: RxBaseViewController {
    
    let viewModel = BirthdayViewModel()
    
    let birthDayPicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko-KR")
        $0.maximumDate = Date()
    }
    let infoLabel = UILabel().then {
        $0.text = Phrase.invalidBirthday
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
        
        let input = BirthdayViewModel.Input(birthday: birthDayPicker.rx.date,
                                            tap: nextButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.validation.bind(with: self) { owner, value in
            owner.nextButton.isEnabled = value
            owner.infoLabel.text = value ? Phrase.validAge : Phrase.invalidAge
            owner.infoLabel.textColor = value ? Color.blue : Color.gray
        }
        .disposed(by: disposeBag)
        
        output.year
            .map { "\($0)년" }
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)        
        output.month
            .map { "\($0)월" }
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
        output.day
            .map { "\($0)일" }
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.tap
            .bind(with: self) { owner, _ in
                owner.showAlert()
            }
            .disposed(by: disposeBag)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "회원가입 완료",
                                      message: Phrase.signUpComplete,
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "로그인 하러 가기",
                               style: .default) { [weak self] _ in
            //            (self?.tabBarController as! RxStartTabBarController).replaceViewController(at: 0, with: SignInViewController())
            self?.changeRootVC(RxStartTabBarController())
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

