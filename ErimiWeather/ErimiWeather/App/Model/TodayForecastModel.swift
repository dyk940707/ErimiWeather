//
//  TodayForecastModel.swift
//  ErimiWeather
//
//  Created by 김도윤 on 2023/01/30.
//

import Foundation

// MARK: - WeatherResponseModel
struct TodayForecastModel: Codable {
    let response: Response?
    // MARK: - Response
    struct Response: Codable {
        let header: Header?
        let body: Body?
        
        // MARK: - Body
        struct Body: Codable {
            let dataType: String?
            let items: Items?
            let pageNo, numOfRows, totalCount: Int?
            // MARK: - Items
            struct Items: Codable {
                let item: [Item]?
                
                // MARK: - Item
                struct Item: Codable {
                    let baseDate, baseTime, category, fcstDate: String?
                    let fcstTime, fcstValue: String?
                    let nx, ny: Int?
                }
            }
        }
        
        // MARK: - Header
        struct Header: Codable {
            let resultCode, resultMsg: String?
        }
    }
}
