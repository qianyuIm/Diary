//
//  AppDelegate.swift
//  Diary
//
//  Created by cyd on 2021/1/15.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let launchAd = QYLaunchAd()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configurationVenders(launchOptions)
        configNavigationBar()
        initializeRouter()
        initializeRoot()
        for index in 0..<100 {
            let row = getRows(index)
            logDebug("count = \(index), row = \(row)")
        }
        return true
    }
    //MARK: 3D touch
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcutItem(shortcutItem))
    }
    func getRows(_ count: Int) -> Int {
        if count == 0 {
            return 0
        }
        return (count - 1) / 3 + 1
    }
}

