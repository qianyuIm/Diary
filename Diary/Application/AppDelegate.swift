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
        initializeRoot()
        return true
    }

}

