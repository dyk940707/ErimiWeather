//
//  APIManager.swift
//  ErimiWeather
//
//  Created by 김도윤 on 2023/01/30.
//

import Foundation
import RxSwift
import RxAlamofire

protocol WeatherAPIProtocol {
    func todayForecast(pageNo: Int, pageSize: Int, baseDate: String, baseTime: String, x: Double, y: Double) -> Observable<TodayForecastModel>
}

class WeatherAPIManager: WeatherAPIProtocol {
    let disposeBag = DisposeBag()
    static let share = WeatherAPIManager()
    
    func todayForecast(pageNo: Int, pageSize: Int, baseDate: String, baseTime: String, x: Double, y: Double) -> Observable<TodayForecastModel> {
        let service: WeatherAPIService = .getForecast(pageNo: pageNo, pageSize: pageSize, baseDate: baseDate, baseTime: baseTime, x: x, y: y)
        let ob = requestData(.get, service.url,
                             parameters: service.param,
                             encoding: service.encoding,
                             headers: service.header)
            .mapObject(type: TodayForecastModel.self)
            .compactMap { $0 }
            .debug()
        return ob
    }
}
