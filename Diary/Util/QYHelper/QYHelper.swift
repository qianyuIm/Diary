//
//  QYHelper.swift
//  Diary
//
//  Created by cyd on 2021/2/3.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import Foundation
class QYHelper {
    
    /// 获取本地json数据
    /// - Parameter jsonName:  json 文件名
    /// - Returns:
    class func localJsonData(with jsonName: String) -> Data {
        let jsonPath = Bundle.main.path(forResource: jsonName, ofType: "json")
        let jsonUrl = URL(fileURLWithPath: jsonPath!)
        let data = try? Data(contentsOf: jsonUrl)
        return data ?? "".data(using: String.Encoding.utf8)!
    }
}
