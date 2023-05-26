//
//  ViewModel.swift
//  WeatherReports
//
//  Created by Inpyo Hong on 2023/05/26.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import PKHUD
import Moya
import RxDataSources

struct WeatherDataSection {
    var header: String
    var items: [List]
}

extension WeatherDataSection: SectionModelType {
    typealias Item = List
    
    init(original: WeatherDataSection, items: [List]) {
        self = original
        self.items = items
    }
}

class ViewModel {
    let disposeBag = DisposeBag()
    var dataSource: RxTableViewSectionedReloadDataSource<WeatherDataSection>!
    let sectionSubject = BehaviorRelay(value: [WeatherDataSection]())
    
    var headerViewHeight: CGFloat = 50
    let sectionTitles = ["Seoul", "Chicago", "London"]
    
    var weatherResults: PublishRelay<[[List]]> = PublishRelay<[[List]]>()
    var serverError: PublishRelay<Void> = PublishRelay<Void>()
    
    var weatherApi: WeatherAPIProvider {
        var configuration: URLSessionConfiguration {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 3
            config.timeoutIntervalForResource = 3
            config.requestCachePolicy = .useProtocolCachePolicy
            return config
        }
        
        let sessionConfig = Session(configuration: configuration, startRequestsImmediately: false)
        let logOptions: NetworkLoggerPlugin.Configuration = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        
        let plugIn: [PluginType] = [NetworkLoggerPlugin(configuration: logOptions)]
        let provider = WeatherAPIProvider(provider: MoyaProvider<OpenWeather>(session:sessionConfig, plugins: plugIn))
        
        return provider
    }
    
    func getWeatherReports() {
        let seoul = weatherApi.request(OpenWeather.daily(cityName: "Seoul")).map(WeatherResult.self).asObservable()
        let london = weatherApi.request(OpenWeather.daily(cityName: "London")).map(WeatherResult.self).asObservable()
        let chicago = weatherApi.request(OpenWeather.daily(cityName: "Chicago")).map(WeatherResult.self).asObservable()
        
        Observable.zip(seoul, london, chicago)
            .subscribe(onNext: { [unowned self](seoulResult, londonResult, chicagoResult) in
                HUD.hide(afterDelay: 1.0)
                
                var result: [WeatherDataSection] = [WeatherDataSection]()
                
                result.append(WeatherDataSection(header: sectionTitles[0], items: seoulResult.list))
                result.append(WeatherDataSection(header: sectionTitles[1], items: londonResult.list))
                result.append(WeatherDataSection(header: sectionTitles[2], items: chicagoResult.list))
                
                self.sectionSubject.accept(result)
                
            }, onError: { [unowned self] error in
                HUD.hide(afterDelay: 1.0)
                
                print(error.localizedDescription)
                self.serverError.accept(())
            })
            .disposed(by: disposeBag)
    }
    
}
