//
//  JokeViewModel.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/12/24.
//

import Foundation
import RxSwift
import RxCocoa

class JokeViewModel: BaseViewModel {
    
    struct Input {
        let tapRandomJokeButton: ControlEvent<Void>
    }
    
    struct Output {
        let jokeText: Observable<Joke>
    }
    
    func transform(input: Input) -> Output {
        let result = input.tapRandomJokeButton
            .flatMap {
                NetworkManager.shared.fetchJoke()
                    .catch { error in
//                        return Single<Joke>.never()
                        return Observable.just(Joke(id: 0, joke: "실패"))
//                            .asSingle()
                    }
            }
        return Output(jokeText: result)
    }
    
}
