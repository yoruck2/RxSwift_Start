//
//  Color.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/2/24.
//

import UIKit

enum Color {
    static let blue: UIColor = .abledBlue
    static let gray: UIColor = .unabledGray
    static let red: UIColor = .invalidRed
}

enum Phrase {
    
    static let onlyNumeric = "숫자만 입력해주세요"
    static let minimumNumberCount = "10자 이상으로 입력해주세요"
    static let validNumber = ""
    
    static let validAge = "가입 가능한 나이입니다."
    static let invalidAge = "만 17세 이상만 가입 가능합니다."
    
    static let validEmail = "가능한 이메일 입니다!"
    static let duplicatedEmail = "이미 가입된 이메일 입니다."
    static let invalidEmail = "이메일 형식에 맞게 입력해주세요."
    
    static let invalidBirthday = "만 17세 이상만 가입 가능합니다."
    
    static let signUpComplete = "회원가입이 완료 되었습니다!\n환영합니다!"
}
