//
//  QYScreenshotTrackHelper.swift
//  Diary
//
//  Created by cyd on 2021/1/27.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
class QYScreenshotTrackHelper: NSObject {
    class func track() {
        NotificationCenter.default.addObserver(self, selector: #selector(screenshotTrack), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    @objc class func screenshotTrack() {
        logDebug("截图了")
    }
}

