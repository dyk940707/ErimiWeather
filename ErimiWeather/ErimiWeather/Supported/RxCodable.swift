//
//  RxCodable.swift
//  ErimiWeather
//
//  Created by 김도윤 on 2023/01/30.
//

import Foundation
import RxSwift

public extension ObservableType where Element == Data {
  func map<T>(_ type: T.Type, using decoder: JSONDecoder? = nil) -> Observable<T> where T: Decodable {
    return self.map { data -> T in
      let decoder = decoder ?? JSONDecoder()
      return try decoder.decode(type, from: data)
    }
  }
}

public extension ObservableType where Element == String {
  func map<T>(_ type: T.Type, using decoder: JSONDecoder? = nil) -> Observable<T> where T: Decodable {
    return self
      .map { string in string.data(using: .utf8) ?? Data() }
      .map(type, using: decoder)
  }
}

extension ObservableType {

    public func mapObject<T: Codable>(type: T.Type) -> Observable<T> {
        return flatMap { data -> Observable<T> in
            let responseTuple = data as? (HTTPURLResponse, Data)

            guard let jsonData = responseTuple?.1 else {
                throw NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Could not decode object"]
                )
            }

            let decoder = JSONDecoder()
            let object = try decoder.decode(T.self, from: jsonData)

            return Observable.just(object)
        }
    }

    public func mapArray<T: Codable>(type: T.Type) -> Observable<[T]> {
        return flatMap { data -> Observable<[T]> in
            let responseTuple = data as? (HTTPURLResponse, Data)

            guard let jsonData = responseTuple?.1 else {
                throw NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Could not decode object"]
                )
            }

            let decoder = JSONDecoder()
            let objects = try decoder.decode([T].self, from: jsonData)

            return Observable.just(objects)
        }
    }
}
