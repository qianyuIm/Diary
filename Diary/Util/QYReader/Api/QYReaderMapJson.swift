//
//  QYReaderMapJson.swift
//  Diary
//
//  Created by cyd on 2021/2/3.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
extension Response {
    func mapReaderObject<D: HandyJSON>(_ type: D.Type,
                                       atKeyPath keyPath: String? = nil) throws -> D {
        let json = try JSON(data: data)
        // 判断status
        let code = json["status"].intValue
        let status = QYBaseStatusItem()
        status.msg = json["info"].rawString()
        if code != 1 {
            throw QYHandyJSONMapError.dataError(errorStatus: status)
        }
        let jsonString = json.rawString()
        if let obj = D.deserialize(from: jsonString, designatedPath: keyPath) {
            return obj
        }
        throw QYHandyJSONMapError.mapError(errorDescribe: kMapException)
    }
    func mapReaderArray<D: HandyJSON>(_ type: [D].Type, atKeyPath keyPath: String? = nil) throws -> [D] {
        let json = try JSON(data: self.data)
        // 判断status
        let code = json["status"].intValue
        let status = QYBaseStatusItem()
        status.msg = json["info"].rawString()
        if code != 1 {
            throw QYHandyJSONMapError.dataError(errorStatus: status)
        }
        let jsonString = json.rawString()
        if let objs = [D].deserialize(from: jsonString, designatedPath: keyPath) as? [D] {
            return objs
        }
        throw QYHandyJSONMapError.mapError(errorDescribe: kMapException)
    }
}
extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func mapReaderObject<D: HandyJSON>(_ type: D.Type,
                                       atKeyPath keyPath: String? = nil) -> Single<D> {
        return flatMap { response -> Single<D> in
            return Single.just(try response.mapReaderObject(type, atKeyPath: keyPath))
        }
    }
    
    func mapReaderArray<D: HandyJSON>(_ type: [D].Type,
                                      atKeyPath keyPath: String? = nil) -> Single<[D]> {
        
        return flatMap { response -> Single<[D]> in
            return Single.just(try response.mapReaderArray(type, atKeyPath: keyPath))
        }
    }
}

extension ObservableType where Element == Response {
    
   func mapReaderObject<D: HandyJSON>(_ type: D.Type,
                                      atKeyPath keyPath: String? = nil) -> Observable<D> {
        return flatMap { response -> Observable<D> in
            return Observable.just(try response.mapReaderObject(type, atKeyPath: keyPath))
        }
    }
    func mapReaderArray<D: HandyJSON>(_ type: [D].Type,
                                      atKeyPath keyPath: String? = nil) -> Observable<[D]> {
        return flatMap { response -> Observable<[D]> in
            return Observable.just(try response.mapReaderArray(type, atKeyPath: keyPath))
        }
    }
}
