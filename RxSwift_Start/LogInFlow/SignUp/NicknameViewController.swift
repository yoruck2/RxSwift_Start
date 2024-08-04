//
//  NicknameViewController.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NicknameViewController: RxBaseViewController {
    
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요 :)")
    let nextButton = SignUpButton(title: "다음")
    let descriptionLabel = UILabel()
    
    
    
    override func configureHierarchy() {
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
    }
    override func configureLayout() {
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(5)
            make.leading.equalTo(nicknameTextField).inset(10)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        navigationItem.title = "Password"
    }
}
