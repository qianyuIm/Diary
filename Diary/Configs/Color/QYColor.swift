//
//  QYColor.swift
//  Tool
//
//  Created by cyd on 2020/12/25.
//

import UIKit
struct QYColor {
    /// tabbar
    static let tabbarColor = color("#252528")
    /// tabbar
    static let tabbarShadowColor = color("#252528")
    /// tabbar
    static let tabbarNormalIconColor = color("#DDDDDD")
    /// tabbar
    static let tabbarSelectedIconColor = color("#DDDDDD")
    /// navigationBar
    static let navigationBarBarTintColor = color("#252528")
    /// navigationBar
    static let navigationBarTintColor = color("#DDDDDD")
    /// navigationBar
    static let navigationBarTitleTextColor = color("#DDDDDD")
    /// backgroundColor
    static let backgroundColor = color("#323232")
    /// 主色 F83245
    static let mainColor = color("#F83245")
    /// placeholder
    static let placeholder = color("#EEEEEE")
    /// 黑色
    static let blackColor = color("000000")
    /// 333
    static let color333 = color("#333333")
    /// 666
    static let color666 = color("#666666")
    /// 999
    static let color999 = color("#999999")
    /// 随机色
    static var random: UIColor {
        return UIColor.ext.random
    }
    static func color(_ hexString: String,
                      alpha: CGFloat = 1) -> UIColor {
        return UIColor.ext.color(hexString, alpha: alpha)
    }
}
