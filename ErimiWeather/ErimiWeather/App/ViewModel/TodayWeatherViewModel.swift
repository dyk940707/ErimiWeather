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
    var todayForecastTypeListSubject = PublishSubject<[String]>()
    
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
                                        baseTime: baseTimeFetch(),
                                        x: LocationManager.lat,
                                        y: LocationManager.lng)
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
            
            var todayType: [String] = []

            for p in response.indices {
                if response[p].category == "PTY" {
                    todayType.append(response[p].fcstValue!)
                }
            }
            self.todayForecastTypeListSubject.onNext(todayType)
        }
        .disposed(by: disposeBag)
    }
    
    func baseTimeFetch() -> String {
        let currentTime = DateManager.customDateFormatter_today(format: "HHmm")
        let intTime = Int(currentTime)!
        var baseTime = "0"
        switch intTime {
        case 200 ... 500:
            print("02-05")
            baseTime = "0200"
        case 500...800:
            print("05-08")
            baseTime = "0500"
        case 800...1100:
            print("08-11")
            baseTime = "0800"
        case 1100...1400:
            print("11-14")
            baseTime = "1100"
        case 1400...1700:
            print("14-17")
            baseTime = "1400"
        case 1700...2000:
            print("17-20")
            baseTime = "1700"
        case 2000...2300:
            print("20-23")
            baseTime = "2000"
        default:
            print("그외")
            baseTime = "0200"
        }
        return String(baseTime)
    }
}
