//
//  JokeViewController.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/12/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class JokeViewController: RxBaseViewController {
    
    let viewModel = JokeViewModel()
    
    let jokeLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    let randomJokeButton = SignUpButton(title: "농담해줘!")
    
    override func bind() {
        let input = JokeViewModel.Input(tapRandomJokeButton: randomJokeButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.jokeText
            .map { $0.joke }
            .bind(to: jokeLabel.rx.text)
            .disposed(by: disposeBag)
    }
    override func configureLayout() {
        view.addSubview(jokeLabel)
        view.addSubview(randomJokeButton)
        
        jokeLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.center.equalToSuperview()
        }
        randomJokeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(200)
            make.horizontalEdges.equalToSuperview().inset(60)
        }
    }
}
