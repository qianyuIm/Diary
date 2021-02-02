//
//  AppDelegate+Internal.swift
//  Diary
//
//  Created by cyd on 2021/1/15.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
import UINavigation_SXFixSpace

extension AppDelegate {
    func initializeRouter() {
        QYRouter.initRouter()
    }
    func configNavigationBar() {
        UINavigationConfig.shared()?.sx_disableFixSpace = true
//        UINavigationConfig.shared()?.sx_defaultFixSpace = 16
        let navigationBar = UINavigationBar.appearance()
        navigationBar.shadowImage = UIImage()
        navigationBar.barTintColor = QYColor.navigationBarBarTintColor
        navigationBar.tintColor = QYColor.navigationBarTintColor
        navigationBar.barStyle = .black
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: QYFont.fontSemibold(18), NSAttributedString.Key.foregroundColor: QYColor.navigationBarTitleTextColor]
    }
    func initializeRoot() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let tabbar = QYTabbarController()
        window?.rootViewController = tabbar
        window?.makeKeyAndVisible()
        screenshotTrack()
        alertPrivacyPolicy()
        displayAd()
    }
    /// 监听截屏
    func screenshotTrack() {
        QYScreenshotTrackHelper.track()
    }
    /// 启动隐私协议
    func alertPrivacyPolicy() {
        QYAlert.alertPrivacyPolicy()
    }
    /// 启动广告
    func displayAd() {
        launchAd.start()
    }
    
}
extension AppDelegate {
    /// 3D touch
    func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        return QYShortcutItemHelper.handleShortcutItem(shortcutItem)
    }
}
