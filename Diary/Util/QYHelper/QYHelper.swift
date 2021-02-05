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
    
    /// 主线程异步执行
    /// - Parameter completion:
    class func mainAsync(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            completion()
        }
    }
    
    /// 根据总数和列数得出行数 总数为0则行数为0
    /// - Parameters:
    ///   - count: 总数
    ///   - column: 列数
    /// - Returns:
    class func rowNumber(for count: Int,
             column: Int) -> Int {
        if count == 0 {
            return 0
        }
        return (count - 1) / column + 1
    }
}
