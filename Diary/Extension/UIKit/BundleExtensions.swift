//
//  BundleExtensions.swift
//  Diary
//
//  Created by cyd on 2021/1/27.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
extension QianyuWrapper where Base: Bundle {
    static func bundle(with name: String) -> Bundle? {
        // .app/xx.bundle
        if let bundlePath = Bundle.main.resourcePath?.appending("/\(name).bundle") {
            let bundle = Bundle(path: bundlePath)
            return bundle
        }
       // .app/Frameworks/xx.framework/xx.bundle
        if var associateBundleURL = Bundle.main.url(forResource: "Frameworks", withExtension: nil) {
            associateBundleURL.appendPathComponent(name)
            associateBundleURL.appendPathExtension("framework")
            let associateBunle = Bundle(url: associateBundleURL)
            if let bundlePath = associateBunle?.path(forResource: name, ofType: "bundle") {
                return Bundle(path: bundlePath)
            }
        }
        return nil
    }
}
