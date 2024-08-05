//
//  PhoneViewController.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PhoneViewController: RxBaseViewController {
    
    let viewModel = PhoneViewModel()
    
    let phoneTextField = SignTextField(placeholderText: "전화번호를 입력해 주세요 :)")
    let nextButton = SignUpButton(title: "다음")
    let validtionLabel = UILabel()
    
    override func bind() {
        let input = PhoneViewModel.Input(phoneNumber: phoneTextField.rx.text,
                                         tap: nextButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.initialNumber
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        // 뷰모델에 생성 안하고 바로 넣기
//        phoneTextField.rx.text.startWith("010")
//            .bind(to: phoneTextField.rx.text)
//            .disposed(by: disposeBag)
        
        output.validationResults
            .bind(with: self) { owner, value in
                owner.validtionLabel.text = value.0
                owner.nextButton.isEnabled = value.1
            }
            .disposed(by: disposeBag)

        output.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?
                    .pushViewController(BirthdayViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    override func configureHierarchy() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
        view.addSubview(validtionLabel)
    }
    override func configureLayout() {
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        validtionLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(5)
            make.leading.equalTo(phoneTextField).inset(10)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}


