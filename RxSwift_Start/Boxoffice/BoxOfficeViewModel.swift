//
//  BoxOfficeViewModel.swift
//  SeSACRxThreads
//
//  Created by dopamint on 8/7/24.
//

import Foundation
import RxSwift
import RxCocoa

//extension Date {
//    static let formatter = DateFormatter()
//    func formatToKoreanDate() -> String {
//        String.formatter.dateFormat = "yyyyMMdd"
//        let resultDate = String.formatter.string(from: self)
//        return resultDate
//    }
//}

class BoxOfficeViewModel {
    let disposeBag = DisposeBag()
    
    // 테이블뷰 데이터
//    private let movieList = Observable.just(["테스트1", "테스트2", "테스트3"])    
    // 컬렉션뷰 데이터
    private var recentList = ["테스트1", "테스트2", "테스트3","aasf"]
    
    struct Input {
        // 테이블뷰 셀 클릭시 들어오는 글자, 컬렉션뷰에 업데이트
        let recentText: PublishSubject<String>
        let searchButtonTap: ControlEvent<Void> // searchBar.rx.searchButtonClicked
        let searchText: ControlProperty<String> // searchBar.rx.text.orEmpty
    }
    
    struct Output {
        let movieList: PublishSubject<[DailyBoxOfficeList]> // 테이블뷰
        let recentList: BehaviorSubject<[String]> // 컬렉션뷰
    }
    
    func transform(input: Input) -> Output {
        
        let recentList = BehaviorSubject(value: recentList)
        let boxOfficeList = PublishSubject<[DailyBoxOfficeList]>()
        
        input.recentText
            .subscribe(with: self) { owner, value in
                print(value)
                owner.recentList.append(value)
                // recentList의 값을 바꿔야 하기 때문에 subject로 선언한거임
                recentList.onNext(owner.recentList)
            }.disposed(by: disposeBag)
        
        // MARK: Observable 안에 Observable이 또 있다!
        // >> Observable<Obsevable<Value>>
        input.searchButtonTap // 옵저버블
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map {
                guard let inputText = Int($0) else {
                    return 2323433
                }
                return inputText
            }
            .map { "\($0)" }
            .debug("ss")
            .flatMap { value in  // flatMap 으로 옵저버블 안에 옵저버블 벗기기
                NetworkManager.shared.callBoxOffice(date: value)
            }
            .subscribe(with: self) { owner, movie in
                boxOfficeList.onNext(movie.boxOfficeResult.dailyBoxOfficeList)
                
            } onError: { owner, error in
                print("\(error)")
            } onCompleted: { owner in
                print("completed")
            } onDisposed: { owner in
                print("disposed")
            }
            .disposed(by: disposeBag)

        // MARK: flatMap 안쓴버전 -
//        input.searchButtonTap // 옵저버블
//            .throttle(.seconds(1), scheduler: MainScheduler.instance)
//            .withLatestFrom(input.searchText)
//            .distinctUntilChanged()
//            .map {
//                guard let inputText = Int($0) else {
//                    return 2323433
//                }
//                return inputText
//            }
//            .map { "\($0)" }
//            .debug("ss")
//            .map { value in
//                NetworkManager.shared.callBoxOffice(date: value) // 옵저버블 안에 옵저버블
//            }
//            .debug("옵저버블 안에 옵저버블")
//            .subscribe(with: self) { owner, value in
//                value // Observable<Movie>
//                    .subscribe(with: self) { owner, movie in
//                        boxOfficeList.onNext(movie.boxOfficeResult.dailyBoxOfficeList)
//                    }.disposed(by: self.disposeBag)
//            } onError: { owner, error in
//                print("\(error)")
//            } onCompleted: { owner in
//                print("completed")
//            } onDisposed: { owner in
//                print("disposed")
//            }
//            .disposed(by: disposeBag)
        
        input.searchText
            .subscribe(with: self) { owner, _ in
                print("뷰모델 글자 인식")
            }.disposed(by: disposeBag)
        
        
        return Output(movieList: boxOfficeList,
                      recentList: recentList)
    }
}
