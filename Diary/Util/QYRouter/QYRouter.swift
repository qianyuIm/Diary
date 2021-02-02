//
//  QYRouter.swift
//  Qianyu
//
//  Created by cyd on 2020/12/30.
//

import Foundation
import URLNavigator

/// 全局导航
let router = QYRouter.default
/// 可以作为参数回调
typealias QYRouterContextCompletionHandler = ((_ any: Any?) -> Void)
/// 路由 context
struct QYRouterContext {
    var message: Any?
    var completionHandler: QYRouterContextCompletionHandler?
}
class QYRouter {
    static var `default` = Navigator()
    class func initRouter() {
        QYRouterInternal.initRouter()
        QYRouterExternal.initRouter()
    }
}
