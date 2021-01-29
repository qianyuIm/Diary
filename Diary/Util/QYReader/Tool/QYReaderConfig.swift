//
//  QYReaderConfig.swift
//  Diary
//
//  Created by cyd on 2021/1/27.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
import DefaultsKit
extension DefaultsKey {
    /// 阅读配置
    static let kLastReadConfigKey = Key<QYReaderConfig>("qy_lastReadConfigKey")
}

class QYReaderConfig: Codable {
    // MARK:---主题
    /// 主题类型
    var themeType: QYReaderThemeType = .default
    /// 自定义主题路径
    var themeCustomFile: URL? = nil
    /// 主题集合
    var themeItems: [QYReaderThemeItem] = []
    /// 用于记录之前的主题
    var previousThemeItem: QYReaderThemeItem
    private static var _shared: QYReaderConfig?
    class func shared() -> QYReaderConfig {
        guard let shared = _shared else {
            let defaults = Defaults()
            let hasConfig = defaults.has(.kLastReadConfigKey)
            if hasConfig {
                _shared = defaults.get(for: .kLastReadConfigKey)!
            } else {
                _shared = QYReaderConfig()
            }
            return _shared!
        }
        return shared
    }
    private init() {
        previousThemeItem = QYReaderThemeItem(themeType: themeType,
                                                 themeCustomFile: themeCustomFile)
        
    }
    /// 更新数据
    func update() {
        Defaults().set(self, for: .kLastReadConfigKey)
    }
    
}
