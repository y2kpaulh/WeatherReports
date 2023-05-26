//
//  WeatherReportsTests.swift
//  WeatherReportsTests
//
//  Created by Inpyo Hong on 2023/05/27.
//

import XCTest
import RxSwift
import RxMoya
import Moya
@testable import WeatherReports

final class WeatherReportsTests: XCTestCase {
    var sut: MockWeatherAPIProvider!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        self.sut = MockWeatherAPIProvider()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }
    
    func testExample() throws {
        measure {
            // Put the code you want to measure the time of here.
            let expectation = XCTestExpectation(description: #function)
           
            sut.request(from: .daily(cityName: "Seoul"), ofType: WeatherResult.self)
                .subscribe(onNext: { result in
                    expectation.fulfill()

                    XCTAssertEqual(result.city.name, "Seoul")
                    XCTAssertEqual(result.list.count, 5)
                })
                .disposed(by: sut.disposeBag)

            wait(for: [expectation], timeout: 1.0)
        }
    }
    
    func testFailureExample() throws {
        measure {
            sut.shouldFail = true
            let expectation = XCTestExpectation(description: #function)
           
            sut.request(from: .daily(cityName: "Seoul"), ofType: WeatherResult.self)
                .subscribe(onError: { error in
                    expectation.fulfill()
                })
                .disposed(by: sut.disposeBag)
            
            wait(for: [expectation], timeout: 1.0)
        }
    }
}
