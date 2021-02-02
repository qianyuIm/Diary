//
//  QYRouterInternal.swift
//  Qianyu
//
//  Created by cyd on 2020/12/30.
//

import Foundation
enum QYRouterInternal {
    /// 小说详情
    case readerInfo
}
extension QYRouterInternal {
    var path: String {
        switch self {
        case .readerInfo:
            return QYConfigs.readerSchemes + "info"
        }
    }
    static func initRouter() {
        router.register(QYRouterInternal.readerInfo.path) { (url, values, context) -> UIViewController? in
            guard let context = context as? QYRouterContext,
                  let bookId = context.message as? Int else {
                return nil
            }
            let readerInfo = QYReaderInfoController(bookId: bookId)
            return readerInfo
        }
    }
}
