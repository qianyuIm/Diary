//
//  QYDataBaseManager.swift
//  Diary
//
//  Created by cyd on 2021/1/27.
//  Copyright © 2021 qianyuIm. All rights reserved.
//  数据库

import Foundation
import GRDB
/// 数据库表明 汇总
struct QYDataBaseTableName {
    /// 阅读时长统计
    static let readerStatistical = "reader_statistical"
}
class QYDataBaseManager {
    static let shared = QYDataBaseManager()
    private var dbPath: String {
        let filePath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!.appending("/QYDataBase.db")
        return filePath
    }
    var dbQueue: DatabaseQueue {
        return try! DatabaseQueue(path: dbPath)
    }
    
    private init() {}
}
extension QYDataBaseManager {}
