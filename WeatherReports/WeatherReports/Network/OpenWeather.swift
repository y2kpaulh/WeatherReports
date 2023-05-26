//
//  OpenWeather.swift
//  WeatherReports
//
//  Created by Inpyo Hong on 2023/05/26.
//

import Foundation
import Moya

enum OpenWeather {
    case daily(cityName: String)
}

// MARK: - TargetType Protocol Implementation
extension OpenWeather: TargetType {
    var baseURL: URL { URL(string: "https://api.openweathermap.org/data/2.5")! }
    
    var path: String {
        switch self {
        case .daily:
            return "/forecast/daily"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .daily:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .daily(let city):
            return .requestParameters(parameters: ["q" : city, "appid": Config.apiKey, "cnt": 5, "units": "metric"], encoding: URLEncoding.queryString)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .daily(let city):
            return Data(
                         """
                         {"city":{"id":1835848,"name":"\(city)","coord":{"lon":126.9778,"lat":37.5683},"country":"KR","population":10349312,"timezone":32400},"cod":"200","message":0.0642619,"cnt":5,"list":[{"dt":1685156400,"sunrise":1685132113,"sunset":1685184206,"temp":{"day":18.33,"min":17.65,"max":20.97,"night":17.94,"eve":17.67,"morn":19.13},"feels_like":{"day":18.65,"night":18.24,"eve":18,"morn":18.69},"pressure":1018,"humidity":93,"weather":[{"id":501,"main":"Rain","description":"moderate rain","icon":"10d"}],"speed":1.71,"deg":82,"gust":2.88,"clouds":100,"pop":1,"rain":13.3},{"dt":1685242800,"sunrise":1685218482,"sunset":1685270651,"temp":{"day":18.97,"min":17.92,"max":19.14,"night":18.28,"eve":18.3,"morn":18.19},"feels_like":{"day":19.38,"night":18.75,"eve":18.74,"morn":18.47},"pressure":1013,"humidity":94,"weather":[{"id":502,"main":"Rain","description":"heavy intensity rain","icon":"10d"}],"speed":3.5,"deg":220,"gust":11.76,"clouds":100,"pop":1,"rain":35.13},{"dt":1685329200,"sunrise":1685304853,"sunset":1685357095,"temp":{"day":20.75,"min":18.17,"max":23.83,"night":19.87,"eve":23.51,"morn":18.2},"feels_like":{"day":21.18,"night":20.34,"eve":23.87,"morn":18.63},"pressure":1011,"humidity":88,"weather":[{"id":502,"main":"Rain","description":"heavy intensity rain","icon":"10d"}],"speed":1.12,"deg":200,"gust":1.98,"clouds":100,"pop":0.87,"rain":10.74},{"dt":1685415600,"sunrise":1685391226,"sunset":1685443539,"temp":{"day":27.14,"min":18.27,"max":29.08,"night":24.34,"eve":27.38,"morn":18.27},"feels_like":{"day":26.97,"night":24.27,"eve":27.33,"morn":18.61},"pressure":1011,"humidity":40,"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"speed":2.86,"deg":268,"gust":3.16,"clouds":93,"pop":0.16},{"dt":1685502000,"sunrise":1685477600,"sunset":1685529981,"temp":{"day":25.36,"min":20.52,"max":25.36,"night":21.82,"eve":24.96,"morn":20.52},"feels_like":{"day":25.02,"night":21.47,"eve":24.53,"morn":20.12},"pressure":1009,"humidity":41,"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"}],"speed":3.08,"deg":174,"gust":2.65,"clouds":98,"pop":0.51,"rain":0.94}]}
                         """.utf8
            )
            
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data { Data(self.utf8) }
}
