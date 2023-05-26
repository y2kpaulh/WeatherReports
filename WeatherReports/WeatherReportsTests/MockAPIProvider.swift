//
//  MockAPIProvider.swift
//  WeatherReportsTests
//
//  Created by Inpyo Hong on 2023/05/29.
//

@testable import WeatherReports
import RxSwift
import XCTest

 class MockWeatherAPIProvider {
    var shouldFail = false
    let disposeBag = DisposeBag()
     
    func request<T>(from endpoint: OpenWeather, ofType type: T.Type) -> Observable<T> where T: Decodable {
        if shouldFail {
            return Observable.error(NSError(domain: "", code: -1, userInfo: nil))
        }
        
        guard type == T.self else { return Observable.empty() }
        let mockResponse = endpoint.sampleData
        
        guard let result = try? JSONDecoder().decode(T.self, from: mockResponse) else {
            return Observable.empty()
        }
        
        return Observable.just(result)
    }
}
