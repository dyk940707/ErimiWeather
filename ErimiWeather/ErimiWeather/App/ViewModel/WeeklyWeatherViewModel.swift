//
//  WeeklyWeatherViewModel.swift
//  ErimiWeather
//
//  Created by 김도윤 on 2023/02/06.
//

import Foundation
import RxSwift

class WeeklyWeatherViewModel {
    
    let weatherAPIManager: WeatherAPIManager
    var weeklyForecast: Observable<WeekForecastModel>
    
    private let disposeBag = DisposeBag()
    private var weeklyForecastSubject = PublishSubject<WeekForecastModel>()

    init(service: WeatherAPIManager) {
        weeklyForecast = weeklyForecastSubject.asObservable()
        weatherAPIManager = service
        weeklyForecastAPI()
    }
    
    func weeklyForecastAPI() {
        weatherAPIManager.weekForecast(pageNo: 1, pageSize: 20, regionID: "", time: "")
            .subscribe { data in
                
            }
            .disposed(by: disposeBag)
    }
    
    func weeklyForecastListFetch() {
        
    }
}
