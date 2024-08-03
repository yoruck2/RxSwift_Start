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
    let nextButton = SignUpButton(title: "다음")
    let validationButton = SignUpButton(title: "ㅇㅇ")
    
    var emailData = PublishSubject<String>()
    let basicColor = Observable.just(UIColor.systemBlue)
    
    /*
     텍스트필드 글자수가 4자리 이상이면 초록 컬러, 버튼 클릭 가능하게
     4자리 미만이면 빨간 컬러, 버튼 disabled
     */
    
    func testPublishSubject() {
        let example = PublishSubject<String>()
        let list: Array<String> = []
        
        example.onNext("a")
        example.onNext("b")
        example.on(.next("a"))
        
        example
            .subscribe { value in
                print("publish = \(value)")
            } onError: { error in
                print("publish = \(error)")
            } onCompleted: {
                print("publish = completed")
            } onDisposed: {
                print("publish = diposed")
            }
            .disposed(by: disposeBag)
        
        example.onCompleted()
        example.onNext("c")
        example.onNext("d")
    }
    
    override func bind() {
        testPublishSubject()
//        emailData.on(.next("sdfsdf")) // 구독 전 -> PublishSubject 라면 무시됨
        
        emailData
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
        
//        emailData.on(.next("sdfsdf")) // 구독 후
        
        validationButton.rx.tap.bind(with: self) { owner, _ in
            owner.emailData.onNext("b@b.com")
        }
        .disposed(by: disposeBag)
        
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?
                    .pushViewController(PasswordViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        
        
        // layer에 접근을 위해 cgColor로 한번 더 감싸기!
        basicColor
            .map { $0.cgColor }
            .bind(to: emailTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        basicColor
            .bind(to: nextButton.rx.backgroundColor,
                  emailTextField.rx.textColor,
                  emailTextField.rx.tintColor)
            .disposed(by: disposeBag)
    }
    
//    func configure() {
//        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
//        signUpButton.setTitleColor(Color.black, for: .normal)
//    }
    
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
