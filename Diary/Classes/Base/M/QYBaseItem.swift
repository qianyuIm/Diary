//
//  QYBaseItem.swift
//  Diary
//
//  Created by cyd on 2021/1/28.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
/// 全局错误状态Item
class QYBaseStatusItem: HandyJSON {
    var retCode: Int?
    var msg: String?
    var code: String?
    required init() {}
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.retCode <-- ["retCode", "RetCode"]
    }
}
class QYBaseItem: NSObject {

}
