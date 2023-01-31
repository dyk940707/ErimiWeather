//
//  DateManager.swift
//  ErimiWeather
//
//  Created by 김도윤 on 2023/01/30.
//

import Foundation

class DateManager {
    //MARK: 날짜 포맷 변환기 (오늘)
    /**
    날짜 포맷 변환기 (오늘)
       
     ## What is this?
     오늘날짜를 원하는 포맷으로 변환하여 반환한다.
       
     ## Why Use?
     귀찮으니까
     
     ## example
     ```
    customDateFormatter_today(format: "yyyy-MM-dd") // "2021-05-23"
     ```
       
     - Parameters:
          - format: 원하는 포맷
       
     - returns: 반환된 날짜(String)
     */
    class func customDateFormatter_today(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let today = dateFormatter.string(from: Date())
        return today
    }
}
