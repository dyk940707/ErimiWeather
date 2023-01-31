//
//  TodayWeatherViewModel.swift
//  ErimiWeather
//
//  Created by 김도윤 on 2023/01/27.
//

import Foundation
import RxSwift

class TodayWeatherViewModel {
    
    var currentWeather: Observable<String>
    var currentTmp: Observable<Double>
    let weatherAPIManager: WeatherAPIManager
    var todayForecast: Observable<TodayForecastModel>
    
    private let disposeBag = DisposeBag()
    private let currentWeatherSubject = BehaviorSubject(value: "")
    private let currentTmpSubject = BehaviorSubject(value: 0.0)
    private var todayForecastSubject = PublishSubject<TodayForecastModel>()
        
    var todayForecastListSubject = PublishSubject<[TodayForecastListModel]>()
    
    init(service: WeatherAPIManager) {
        currentTmp = currentTmpSubject.asObservable()
        currentWeather = currentWeatherSubject.asObservable()
        todayForecast = todayForecastSubject.asObservable()
        weatherAPIManager = service
        todayForecastAPI()
        todayForecastListFetch()
    }
    
    func todayForecastAPI() {
        weatherAPIManager.todayForecast(pageNo: 1,
                                        pageSize: 180,
                                        baseDate: DateManager.customDateFormatter_today(format: "yyyyMMdd"),
                                        baseTime: "0800",
                                        x: 37,
                                        y: 126)
        .subscribe { ele in
            self.todayForecastSubject.onNext(ele)
        }
        .disposed(by: disposeBag)
    }
    
    func todayForecastListFetch() {
        self.todayForecast.subscribe { data in
            let response = data.element?.response?.body?.items?.item ?? []
            var todayFo: [TodayForecastListModel] = []
            for i in response.indices {
                if response[i].category == "TMP" {
                    todayFo.append(TodayForecastListModel(time: response[i].fcstTime ?? "", tmp: response[i].fcstValue ?? ""))
                }
            }
            self.todayForecastListSubject.onNext(todayFo)
            
        }
        .disposed(by: disposeBag)
    }
}
