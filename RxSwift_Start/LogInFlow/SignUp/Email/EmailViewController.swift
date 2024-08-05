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

final class EmailViewController: RxBaseViewController {
    
    let viewModel = EmailViewModel()
    
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요 :)")
    let nextButton = SignUpButton(title: "다음")
    let descriptionLabel = UILabel()
    
    override func bind() {
        let input = EmailViewModel.Input(email: emailTextField.rx.text.orEmpty,
                                         tap: nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.isEmailValid
            .bind(with: self) { owner, isValid in
                owner.descriptionLabel.text = isValid ? Phrase.validEmail : Phrase.invalidEmail
                owner.descriptionLabel.textColor = isValid ? .black : .red
                owner.nextButton.isEnabled = isValid
            }
            .disposed(by: disposeBag)
        
        output.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?
                    .pushViewController(PasswordViewController(), animated: true)
            }
            .disposed(by: disposeBag)
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
