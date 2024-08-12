//
//  NetworkManager.swift
//  SeSACRxThreads
//
//  Created by dopamint on 8/8/24.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
    case decodingError
}

final class NetworkManager {
    
    let disposeBag = DisposeBag()
    static let shared = NetworkManager()
    private init() {}
    
    let url = "https://v2.jokeapi.dev/joke/Programming?type=singleaasd"
    
    // Obsevable 객체로 Alamofire 통신
    func fetchJoke() -> Observable<Joke> {
        return Observable.create { observer -> Disposable in
            AF.request(self.url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Joke.self) { response in
                    switch response.result {
                    case .success(let success):
                        observer.onNext(success)
                        observer.onCompleted() // MARK: 이 줄이 없으면 통신 스트림이 계속 유지됨.. -
                        // 큰 옵저버블(유저 인터렉션) 안에 작은 옵저버블(통신) 이 생겼다 사라졌다 하는 구조
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }.debug("JOKE API 통신")
    }
    
    
    // Single 객체로 Alamofire 통신
    func fetchJokeWithSingle() -> Single<Joke> {
        return Single.create { observer -> Disposable in
            AF.request(self.url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Joke.self) { response in
                    switch response.result {
                    case .success(let success):
                        observer(.success(success))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            return Disposables.create()
        }.debug("JOKE API 통신")
    }
    // Single 객체로 Alamofire 통신 + Result Type 활용
    func fetchJokeWithResult() {
        
    }
    
    
    
    
    func callBoxOffice(date: String) -> Observable<Movie>{
        let url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=23a93cbbbc8fdc2ae474716728465cca&targetDt=\(date)"
        
        let result = Observable<Movie>.create { observer in
            // url 에러
            guard let url = URL(string: url) else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    observer.onError(APIError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
                    observer.onError(APIError.statusError)
                    return
                }
                
                if let data = data,
                   let appData = try? JSONDecoder().decode(Movie.self, from: data) {
                    //                    Single 내부도 이렇게 되어있다
                    observer.onNext(appData)
                    observer.onCompleted() // 요청 될 때마다 disposed 될 수 있게 메모리 누수 방지
                } else {
                    observer.onError(APIError.decodingError)
                }
                
            }.resume()
            
            return Disposables.create()
        }
            .debug("박스오피스 조회")
        return result
    }
}
