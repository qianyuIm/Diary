//
//  QYReaderStatistical.swift
//  Diary
//
//  Created by cyd on 2021/1/26.
//  Copyright © 2021 qianyuIm. All rights reserved.
//  阅读时长统计

import Foundation
import GRDB
class QYReaderStatisticalItem: Codable, Equatable {
    /// yyyy-MM-dd
    var date: String?
    var timeInterval: TimeInterval = 0
    static func == (lhs: QYReaderStatisticalItem, rhs: QYReaderStatisticalItem) -> Bool {
        return lhs.date == rhs.date
    }
    /// 设置行名
    private enum Columns: String, CodingKey, ColumnExpression {
        /// yyyy-MM-dd
        case date
        /// 时长
        case timeInterval
    }
}
extension QYReaderStatisticalItem: MutablePersistableRecord, FetchableRecord {
    private static let dbQueue = QYDataBaseManager.shared.dbQueue
    /// 按时间顺序查找
    static func orderedByDate() -> QueryInterfaceRequest<QYReaderStatisticalItem> {
        return QYReaderStatisticalItem.order(Columns.date.desc)
    }
    /// 建表
    static func createTableIfNeeded() {
        try? dbQueue.inDatabase({ (db) in
            if try db.tableExists(databaseTableName) {
                return
            }
            try db.create(table: databaseTableName, temporary: false, ifNotExists: true, body: { (tb) in
                tb.column(Columns.date.rawValue, .text)
                tb.column(Columns.timeInterval.rawValue, .double)
            })
        })
    }
    static var databaseTableName: String {
        return QYDataBaseTableName.readerStatistical
    }
    /// 插入数据
    static func insert(statisticalItem: QYReaderStatisticalItem) {
        // 判断是否存在
        guard query(statisticalItem.date) == nil else {
            logDebug("重复更新")
            update(statisticalItem)
            return
        }
        // 建表
        createTableIfNeeded()
        try? dbQueue.inTransaction { (db) -> Database.TransactionCompletion in
            do {
                var statisticalItem = statisticalItem
                try statisticalItem.insert(db)
                return .commit
            } catch {
                return .rollback
            }
        }
    }
    /// 查询数据
    static func query(_ date: String?) -> QYReaderStatisticalItem? {
        guard let date = date else { return nil }
        // 建表
        createTableIfNeeded()
        do {
            return try dbQueue.unsafeRead({ (db) -> QYReaderStatisticalItem? in
                return try QYReaderStatisticalItem
                    .filter(Column(Columns.date.rawValue) == date)
                    .fetchOne(db)
            })
        } catch {
            return nil
        }
    }
    static func queryAll() -> [QYReaderStatisticalItem]? {
        // 建表
        createTableIfNeeded()
        do {
            return try dbQueue.read({ (db) -> [QYReaderStatisticalItem]? in
                let request = QYReaderStatisticalItem.orderedByDate()
                return try request.fetchAll(db)
            })
        } catch {
            return nil
        }
    }
    /// 更新数据
    static func update(_ statisticalItem: QYReaderStatisticalItem) {
        // 建表
        createTableIfNeeded()
        // 事务 更新场景
        try? dbQueue.inTransaction { (db) -> Database.TransactionCompletion in
            do {
                try statisticalItem.update(db)
                return .commit
            } catch {
                return .rollback
            }
        }
    }
}
class QYReaderStatistical {
    var timeInterval: TimeInterval?
    private var statisticalItems: [QYReaderStatisticalItem] = []
    /// 最新数据
    private var latestStatisticalItem: QYReaderStatisticalItem?
    /// 会话的间隔时间，默认是10秒，即按home键之后30秒内回到应用算同一次会话
    var sessionContinueTime: TimeInterval = 10
    static let shared = QYReaderStatistical()
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

    }
    /// 统计
    func track() {
        logDebug("统计")
    }
    /// 统计失效
    func unTrack() {
        logDebug("统计失效")
    }
    /// 进入后台
    @objc func enterBackground() {
        
    }
    /// 进入前台
    @objc func enterForeground() {
        
    }
}
