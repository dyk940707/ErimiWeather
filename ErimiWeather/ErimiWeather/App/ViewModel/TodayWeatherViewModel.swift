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
                    todayFo.append(TodayForecastListModel(time: response[i].fcstTime ?? "", tmp: response[i].fcstValue ?? "", state: "", sky: ""))
                }
            }
            var todayState: [String] = []
            var todaySky: [String] = []
            
            for h in response.indices {
                if response[h].category == "PTY" {
                    print("날씨타입")
                    todayState.append(response[h].fcstValue ?? "")
                }
            }
            for o in response.indices {
                if response[o].category == "SKY" {
                    print("하늘타입")
                    todaySky.append(response[o].fcstValue ?? "")
                }
            }
            
            for k in todayFo.indices {
                switch todayState[k] {
                case "1":
                    todayState[k] = "비"
                case "2":
                    todayState[k] = "비/눈"
                case "3":
                    todayState[k] = "눈"
                case "4":
                    todayState[k] = "소나기"
                default:
                    todayState[k] = ""
                }
                todayFo[k].state = todayState[k]
                
                switch todaySky[k] {
                case "1":
                    todaySky[k] = "맑음"
                case "3":
                    todaySky[k] = "구름많음"
                case "4":
                    todaySky[k] = "흐림"
                default:
                    todaySky[k] = ""
                }
                todayFo[k].sky = todaySky[k]

                
                print(todayState)
                print(todayFo)
            }
            self.todayForecastListSubject.onNext(todayFo)

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
