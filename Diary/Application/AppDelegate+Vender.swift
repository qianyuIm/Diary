//
//  AppDelegate+Vender.swift
//  Qianyu
//
//  Created by cyd on 2020/12/28.
//

import Foundation
import SwiftyBeaver
#if DEBUG
import MLeaksFinder
import FLEX
#endif
import SDWebImageWebPCoder
extension AppDelegate {
    func configurationVenders(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        setupSwiftyBeaver()
        setupLeaksFinder()
        setupFLEX()
        setupSdWebImage()
        setupReachability()
    }
}

private extension AppDelegate {
    func setupSwiftyBeaver() {
        let console = ConsoleDestination()
        let file = FileDestination()
//        let cloud = SBPlatformDestination(appID: "E9QvpZ",
//                                          appSecret: "dgk3ia495p8ptyUZadYrf90qKNccusro",
//                                          encryptionKey: "n0MdqbYlscczDdFabXUydjelovwqankE")
        QYLogger.addDestination(console)
        QYLogger.addDestination(file)
//        QYLogger.addDestination(cloud)
        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        logDebug(filePath)
    }
    func setupJiguang(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let entity = JPUSHRegisterEntity()
        if #available(iOS 12.0, *) {
            entity.types = Int(JPAuthorizationOptions.alert.rawValue) | Int(JPAuthorizationOptions.badge.rawValue) | Int(JPAuthorizationOptions.sound.rawValue) | Int(JPAuthorizationOptions.providesAppNotificationSettings.rawValue)
        } else {
            entity.types = Int(JPAuthorizationOptions.alert.rawValue) | Int(JPAuthorizationOptions.badge.rawValue) | Int(JPAuthorizationOptions.sound.rawValue)
        }
        
        entity.categories = QYJPUSHHelper.notificationCategories()
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setup(withOption: launchOptions, appKey: QYKey.jpushKey, channel: QYConfigs.channel, apsForProduction: false)
        JPUSHService.registrationIDCompletionHandler { (resCode, registrationID) in
            logDebug("registrationID == \(registrationID ?? "")")
        }
        #if DEBUG
        JPUSHService.setAlias(QYConfigs.alias, completion: nil, seq: 0)
        #else
        JPUSHService.setLogOFF()
        #endif
        
        /// linkConfig
        let linkConfig = JMLinkConfig()
        linkConfig.appKey = QYKey.jpushKey
        linkConfig.channel = QYConfigs.channel
        JMLinkService.setup(with: linkConfig)
        if #available(iOS 14.0, *) {
            JMLinkService.pasteBoardEnable(false)
        }
        JMLinkService.registerHandler { (respone) in
            QYRouterHelp.registerHandler(respone)
        }
    }
    func setupLeaksFinder() {
        #if DEBUG
        NSObject.addClassNames(toWhitelist: ["UITextField",
                                             "FLEXNavigationController",
                                             "FLEXObjectExplorerViewController",
                                             "FLEXTableView",
                                             "FLEXScopeCarousel",
                                             "FLEXHierarchyViewController"])
        #endif
    }
    func setupFLEX() {
        #if DEBUG
        FLEXManager.shared.showExplorer()
        #endif
    }
    func setupSdWebImage() {
        let webPCoder = SDImageWebPCoder.shared
        SDImageCodersManager.shared.addCoder(webPCoder)
        SDWebImageDownloader.shared.setValue("image/webp,image/*,*/*;q=0.8", forHTTPHeaderField:"Accept")
    }
    func setupReachability() {
        QYReachabilityHelper.shared.startNotifier()
    }
}
//MARK:推送 -- JPUSHRegisterDelegate
extension AppDelegate: JPUSHRegisterDelegate {
    /// 前台
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) == true {
            JPUSHService.handleRemoteNotification(userInfo)
        } else {
            logDebug("前台本地通知")
            QYJPUSHHelper.handlerRemoteNotification(userInfo)
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue) | Int(UNNotificationPresentationOptions.sound.rawValue))
    }
    /// 后台
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) == true {
            JPUSHService.handleRemoteNotification(userInfo)
            QYJPUSHHelper.handlerRemoteNotification(userInfo)
        } else {
            logDebug("后台本地通知")
            QYJPUSHHelper.handlerRemoteNotification(userInfo)
        }
        completionHandler()
    }
    /// setting
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        logDebug(notification.request.content.userInfo)
    }
    
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {
        logDebug(info as Any)
    }
    
    
}
