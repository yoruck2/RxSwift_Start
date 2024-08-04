//
//  EmailViewController.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class EmailViewController: RxBaseViewController {
    
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요 :)")
    
    let inputEmailText = BehaviorRelay(value: "")
    let nextButton = SignUpButton(title: "다음")
    let descriptionLabel = UILabel()
    
    // TODO: 중복확인 / 초기에 descriptionLabel 비우기
    override func bind() {
//        emailTextField.rx.text.onNext(inputEmailText.value)
        
        emailTextField.rx.text.orEmpty
            .bind(to: inputEmailText)
            .disposed(by: disposeBag)
        
        let isEmailValid = inputEmailText
            .map(matchesEmailPattern)
//            .onNext(inputEmailText.value)
//            .map(matchesPattern(inputEmailText.value))
        
        isEmailValid
            .bind(with: self) { owner, result in
                owner.descriptionLabel.text = result ? Phrase.validEmail : Phrase.invalidEmail
                owner.descriptionLabel.textColor = result ? .black : .red
                owner.nextButton.isEnabled = result
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?
                    .pushViewController(PasswordViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func matchesEmailPattern(_ string: String) -> Bool {
        do {
            let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let regex = try NSRegularExpression(pattern: emailPattern)
            let range = NSRange(location: 0, length: string.utf16.count)
            return regex.firstMatch(in: string, options: [], range: range) != nil
        } catch {
            print("Invalid regex pattern: \(error.localizedDescription)")
            return false
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(emailTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
    }
    override func configureLayout() {
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(5)
            make.leading.equalTo(emailTextField).inset(10)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        navigationItem.title = "email"
    }
}
