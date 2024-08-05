//
//  CapsuleButton.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/2/24.
//

import UIKit

final class SignUpButton: UIButton {
    
    override var isEnabled: Bool {
        
        // MARK: observable 내부적으로 결국 didSet으로 바인딩을 하고있긴 하다 -
        didSet {
            backgroundColor = isEnabled ? Color.blue : Color.gray
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = Color.blue
        layer.cornerRadius = 10
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
