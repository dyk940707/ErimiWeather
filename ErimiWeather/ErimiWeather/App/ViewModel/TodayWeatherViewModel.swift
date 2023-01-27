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
    
    private let currentWeatherSubject = BehaviorSubject(value: "")
    private let currentTmpSubject = BehaviorSubject(value: 0.0)
    
    init() {
        currentTmp = currentTmpSubject.asObservable()
        currentWeather = currentWeatherSubject.asObservable()
    }
}
