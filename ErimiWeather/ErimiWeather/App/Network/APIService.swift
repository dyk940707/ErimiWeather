//
//  APIService.swift
//  ErimiWeather
//
//  Created by 김도윤 on 2023/01/30.
//

import Foundation
import Alamofire

enum WeatherAPIService {
    
    case getForecast(pageNo: Int, pageSize: Int, baseDate: String, baseTime: String, x: Double, y: Double)
    
}

extension WeatherAPIService {
    var url: URL {
        switch self {
        case .getForecast:
            return URL(string: "\(weatherServer)/1360000/VilageFcstInfoService_2.0/getVilageFcst")!
        }
    }
    
    var param: Parameters {
        switch self {
        case let .getForecast(pageNo, pageSize, baseDate, baseTime, x, y):
            return ["pageNo":pageNo,
                    "numOfRows":pageSize,
                    "serviceKey":weatherServiceKey,
                    "dataType":"JSON",
                    "base_date":baseDate,
                    "base_time":baseTime,
                    "nx":x,
                    "ny":y]
        }
    }
    
    var encoding: URLEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        default:
            return []
        }
    }
}
