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
    case getWeekForecast(pageNo: Int, pageSize: Int, regionID: String, time: String)
}

extension WeatherAPIService {
    var url: URL {
        switch self {
        case .getForecast:
            return URL(string: "\(weatherServer)/1360000/VilageFcstInfoService_2.0/getVilageFcst")!
        case .getWeekForecast:
            return URL(string: "\(weatherServer)/1360000/MidFcstInfoService/getMidTa")!
        }
    }
    
    var param: Parameters {
        switch self {
        case let .getForecast(pageNo, pageSize, baseDate, baseTime, x, y):
            return ["pageNo":pageNo,
                    "numOfRows":pageSize,
                    "serviceKey":"bsjGYN5zW8tUCTzH76e0BQLRPu7OPVqlPesn1va78+xHAfMVaJkX0sOMWbT8e0guca9KXJ5ZW/3I+qoDdiGNfg==",
                    "dataType":"JSON",
                    "base_date":baseDate,
                    "base_time":baseTime,
                    "nx":x,
                    "ny":y]
        case let .getWeekForecast(pageNo, pageSize, regionID, time):
            return ["serviceKey": "bsjGYN5zW8tUCTzH76e0BQLRPu7OPVqlPesn1va78%2BxHAfMVaJkX0sOMWbT8e0guca9KXJ5ZW%2F3I%2BqoDdiGNfg%3D%3D",
                    "pageNo":pageNo,
                    "numOfRows":pageSize,
                    "dataType":"JSON",
                    "regId":regionID,
                    "tmFc":time]
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
