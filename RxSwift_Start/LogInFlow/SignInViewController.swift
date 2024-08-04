//
//  SignInViewController.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum JackError: Error {
    case invalidEmail
}

class SignInViewController: RxBaseViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let signInButton = SignUpButton(title: "로그인")
    let signUpButton = SignUpButton(title: "회원가입")

    
    var emailData = PublishSubject<String>()
    let basicColor = Observable.just(UIColor.systemBlue)
    
    override func bind() {
        
        emailData
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?
                    .pushViewController(EmailViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        
        
        // layer에 접근을 위해 cgColor로 한번 더 감싸기!
//        basicColor
//            .map { $0.cgColor }
//            .bind(to: emailTextField.layer.rx.borderColor)
//            .disposed(by: disposeBag)
//        basicColor
//            .bind(to: nextButton.rx.backgroundColor,
//                  emailTextField.rx.textColor,
//                  emailTextField.rx.tintColor)
//            .disposed(by: disposeBag)
    }
    
    override func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
