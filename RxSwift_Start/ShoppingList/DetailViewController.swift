//
//  DetailViewController.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/4/24.
//

import UIKit

class DetailViewController: RxBaseViewController {
    
    let textField = SignTextField(placeholderText: "")
    let confirmButton = SignUpButton(title: "수정하기")
    
    var item: ShoppingItem?
    var itemUpdateHandler: ((ShoppingItem) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    override func bind() {
        confirmButton.rx.tap
            .bind { [weak self] in
                guard let self,
                      var item else { return }
                item.name = self.textField.text ?? ""
                let updatedItem = item
                self.itemUpdateHandler?(updatedItem)
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    override func configureLayout() {
        view.addSubview(textField)
        view.addSubview(confirmButton)
        
        textField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(textField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
