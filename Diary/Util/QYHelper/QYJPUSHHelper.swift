//
//  QYJPUSHHelp.swift
//  Diary
//
//  Created by cyd on 2021/1/27.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit

class QYJPUSHHelper {
    class func notificationCategories() -> Set<UNNotificationCategory> {
        var categories = Set<UNNotificationCategory>()
        let notInterestedAction = UNNotificationAction(identifier: QYConfigs.Notification.notInterestedActionIdentifier, title: "不感兴趣", options: .destructive)
        let openAction = UNNotificationAction(identifier: QYConfigs.Notification.openActionIdentifier, title: "点开查看", options: .foreground)
        //给category设置action
        let contentExtensionCategory = UNNotificationCategory(identifier: QYConfigs.Notification.contentExtensionCategory, actions: [notInterestedAction, openAction], intentIdentifiers: [], options: [])
        //给category设置action
        let serviceExtensionCategory = UNNotificationCategory(identifier: QYConfigs.Notification.serviceExtensionCategory, actions: [notInterestedAction, openAction], intentIdentifiers: [], options: [])
        categories.insert(contentExtensionCategory)
        categories.insert(serviceExtensionCategory)

        return categories
    }
    class func handlerRemoteNotification(_ userInfo: [AnyHashable : Any]) {
        logDebug("通知来了---->\(userInfo)")
        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
}
