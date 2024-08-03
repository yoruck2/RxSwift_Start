//
//  PasswordViewController.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: RxBaseViewController {
    
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요 :)")
    let nextButton = SignUpButton(title: "다음")
    let descriptionLabel = UILabel()
    
    override func bind() {
            
        let validation = passwordTextField.rx.text
            .orEmpty
            .map { text -> (Bool, String) in
                if text.contains(" ") {
                    return (false, "공백은 안됩니다!!")
                } else if text.count < 8 {
                    return (false, "8자 이상 입력해주세요!!")
                } else {
                    return (true, "")
                }
            }
        
        validation
            .bind(with: self) { owner, result in
                let (isValid, message) = result
                owner.nextButton.isEnabled = isValid
                owner.descriptionLabel.text = message
            }
            .disposed(by: disposeBag)
        
        // 공백 아예 입력 안되게 하는 방법
//        let validation = passwordTextField.rx.text
//            .orEmpty
//            .map {
//                if $0.contains(" ") {
//                    self.passwordTextField.text?.popLast()
//                }
//                return $0.count >= 8 && !$0.contains(" ")
//            }
//        
//        validation
//            .bind(with: self) { owner, value in
//                owner.nextButton.isEnabled = value
//                owner.descriptionLabel.text = value ? "" : "8자 이상 입력해주세요"
//            }
//            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?
                    .pushViewController(PhoneViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    override func configureHierarchy() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
    }
    override func configureLayout() {
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
            make.leading.equalTo(passwordTextField).inset(10)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        navigationItem.title = "Password"
    }
}
