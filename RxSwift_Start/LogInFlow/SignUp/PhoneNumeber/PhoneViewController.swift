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

class PhoneViewController: RxBaseViewController {
    
    let phoneTextField = SignTextField(placeholderText: "전화번호를 입력해 주세요 :)")
    let nextButton = SignUpButton(title: "다음")
    let descriptionLabel = UILabel()
    
    let inputPhoneNumberText = BehaviorRelay(value: "010")
    let descriptionLabelText = BehaviorRelay(value: "")
    
    override func bind() {

        // BehaviorRelay는 BehaviorSubject를 래핑함
        // 일반적으로 UI 바인딩이나 간단한 상태 관리에는 BehaviorRelay를 사용하는 것이 권장된다 이유는 다음과 같습니다:
        
        // 사용이 더 간단하고 안전합니다.
        // 에러나 완료 상태가 필요 없는 경우가 많습니다.
        // 값에 쉽게 접근할 수 있습니다.
        phoneTextField.rx.text.onNext(inputPhoneNumberText.value)
        
        phoneTextField.rx.text.orEmpty
            .bind(to: inputPhoneNumberText)
            .disposed(by: disposeBag)
        
        let isNumberValid = inputPhoneNumberText
            .map(checkIsNumber)
        
        let isLengthValid = inputPhoneNumberText
            .map(checkLength)
        
        Observable.combineLatest(isNumberValid, isLengthValid)
            .bind(with: self) { owner, result in
                let (isNumber, isLength) = result
                
                guard isNumber else {
                    owner.nextButton.isEnabled = false
                    owner.descriptionLabel.text = "숫자만 입력해주세요"
                    return
                }
                guard isLength else {
                    owner.nextButton.isEnabled = false
                    owner.descriptionLabel.text = "10자 이상으로 입력해주세요"
                    return
                }
                    owner.nextButton.isEnabled = true
                    owner.descriptionLabel.text = ""
            }
            .disposed(by: disposeBag)
        //        inputPhoneNumberText
        //            .map(checkIsNumber)
//            .bind { value in
//                self.nextButton.isEnabled = value
//                self.descriptionLabel.text = value ? "" : "숫자만 입력해주세요"
//            }
//            .disposed(by: disposeBag)
//        
//        inputPhoneNumberText
//            .map(checkLength)
//            .bind { value in
//                self.nextButton.isEnabled = value
//                self.descriptionLabel.text = value ? "" : "10자 이상으로 입력해주세요"
//            }
//            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?
                    .pushViewController(BirthdayViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }

    func checkIsNumber(_ text: String) -> Bool {
        return Int(text) != nil
    }
    
    func checkLength(_ text: String) -> Bool {
        return text.count >= 10
    }
    
    override func configureHierarchy() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
    }
    override func configureLayout() {
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        descriptionLabel.snp.makeConstraints { make in
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
