//
//  QYRequest.swift
//  qianyu
//
//  Created by cyd on 2020/12/7.
//

import UIKit
import Moya
/// 服务器异常 请求超时
let kServerException = "请求异常!"
let kMapException = "数据解析异常"

enum QYHandyJSONMapError: Swift.Error {
    case mapError(errorDescribe: String)
    case dataError(errorStatus: QYBaseStatusItem?)
    var errorDescribe: String {
        switch self {
        case .mapError(errorDescribe: let error):
            return error
        case .dataError(errorStatus: let status):
            return status?.msg ?? kServerException
        }
    }
}

extension Error {
    var asHandyJSONMapError: QYHandyJSONMapError? {
        self as? QYHandyJSONMapError
    }
}
let timeoutClosure = {(endpoint: Endpoint,
                       closure: MoyaProvider.RequestResultClosure) -> Void in
    do {
        var urlRequest = try endpoint.urlRequest()
        urlRequest.timeoutInterval = 15
        closure(.success(urlRequest))
    } catch MoyaError.requestMapping(let url) {
        closure(.failure(MoyaError.requestMapping(url)))
    } catch MoyaError.parameterEncoding(let error) {
        closure(.failure(MoyaError.parameterEncoding(error)))
    } catch {
        closure(.failure(MoyaError.underlying(error, nil)))
    }
}
let apiProvider = MoyaProvider<MultiTarget>(requestClosure: timeoutClosure)
let apiLocalProvider = MoyaProvider<MultiTarget>(requestClosure: timeoutClosure, stubClosure: { (target) -> StubBehavior in
    return StubBehavior.delayed(seconds: 0.5)
})
/// 是否本地json数据
let isLocalRequest: Bool = true

extension Moya.TargetType {
    func request() -> Single<Moya.Response> {
        /// 包装下
        let target = MultiTarget(self)
        switch target {
        // 本地数据
        case .target(QYReaderApi.readerInfo):
            return apiLocalProvider.rx.request(target)
        default:
            // 网络数据
            return apiProvider.rx.request(target)
        }
    }
}


