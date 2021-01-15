//
//  AppDelegate+Internal.swift
//  Diary
//
//  Created by cyd on 2021/1/15.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
extension AppDelegate {
    func initializeRouter() {
        QYRouter.initRouter()
    }
    func initializeRoot() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let tabbar = QYTabbarController()
        window?.rootViewController = tabbar
        window?.makeKeyAndVisible()
    }
}
