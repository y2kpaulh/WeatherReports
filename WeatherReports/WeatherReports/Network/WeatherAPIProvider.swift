//
//  WeatherAPIProvider.swift
//  WeatherReports
//
//  Created by Inpyo Hong on 2023/05/27.
//

import Foundation
import Moya
import RxMoya
import RxSwift


final public class WeatherAPIProvider {
    let provider: MoyaProvider<OpenWeather>
    let disposeBag = DisposeBag()

    init(provider: MoyaProvider<OpenWeather> = .init(), isStub: Bool = false, testRespCode: Int = 200) {
        
        if(isStub){
            let customEndpointClosure = { (target: OpenWeather) -> Endpoint in
                return Endpoint(url: URL(target: target).absoluteString,
                                sampleResponseClosure: { .networkResponse(testRespCode, target.sampleData) },
                                method: target.method,
                                task: target.task,
                                httpHeaderFields: target.headers)
            }
            
            self.provider = MoyaProvider<OpenWeather>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        } else {
            self.provider = provider
        }
    }
}

extension WeatherAPIProvider {
    func request(_ request: OpenWeather) -> Single<Moya.Response> {
                
        return Single<Moya.Response>.create { single in
            let task = self.provider.rx.request(request)
                    .flatMap { response -> Single<Moya.Response> in
                        return Single.just(response)
                    }
                    .debug()
                    .subscribe(onSuccess: { response in
                        single(.success(response))
                    }, onFailure: { error in
                        single(.failure(error))
                    })
            
            return Disposables.create { task.disposed(by: self.disposeBag)}
        }
    }

}
