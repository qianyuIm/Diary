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
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configurationVenders(launchOptions)
        configNavigationBar()
        initializeRouter()
        initializeRoot()
        return true
    }
    //MARK: 3D touch
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcutItem(shortcutItem))
    }
}

