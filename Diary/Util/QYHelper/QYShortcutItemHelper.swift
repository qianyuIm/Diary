//
//  QYShortcutItemHelper.swift
//  Diary
//
//  Created by cyd on 2021/1/27.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import Foundation
enum QYShortcutItem: String {
    /// wifi 传书
    case touchWifiUploadBook
    /// 新书查找
    case touchBookSearch
}
class QYShortcutItemHelper {
    
    class func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool{
        guard let shortCutAction = QYShortcutItem(rawValue: shortcutItem.type) else { return false }
        switch shortCutAction {
        case .touchWifiUploadBook:
            return true
        case .touchBookSearch:
            return true
        }
    }
}
