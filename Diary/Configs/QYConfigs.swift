//
//  QYConfigs.swift
//  Qianyu
//
//  Created by cyd on 2020/12/30.
//

import UIKit
/// 本地图片
typealias LocalImage = R.image
/// 本地字符创
typealias LocalString = R.string.localizable

struct QYConfigs {
    /// 路由
    static let routerSchemes = "qianyuDiary://"
    /// 小说路由
    static let readerSchemes = routerSchemes + "reader/"
    static let channel = "pgy"
    private static var _version: String?
    static var version: String {
        guard let version = _version else {
            _version = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "1.0"
            return _version!
        }
        return version
    }
    /// app 名称
    static let appName = "Diary"
    static let alias = "Diary"
    static let groupId = "group.com.qianyuIm.QYKit"
    struct Notification {
        /// 只有 category 匹配才会使用 NotificationContentExtension
        static let contentExtensionCategory = "contentExtensionCategory"
        static let serviceExtensionCategory = "serviceExtensionCategory"
        static let notInterestedActionIdentifier = "notInterestedAction"
        static let openActionIdentifier = "openAction"
        static let mediaType = "mediaType"
        static let mediaUrl = "mediaUrl"
        static let mediaHeight = "mediaHeight"
        static let amount = "amount"
        /// 原生目标路径 与 targetUrl 互斥
        static let targetPage = "targetPage"
        /// H5目标路径 与 targetPage 互斥
        static let targetUrl = "targetUrl"
    }
}
