//
//  QYRouterHelp.swift
//  Diary
//
//  Created by cyd on 2021/1/27.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import Foundation
class QYRouterHelp {
    class func registerHandler(_ response: JMLinkResponse?) {
        guard let response = response else { return }
        logDebug(response.url)
        logDebug(response.params)
    }
    class func handlerRemoteNotification(_ userInfo: [AnyHashable : Any]) {
        
    }
}
