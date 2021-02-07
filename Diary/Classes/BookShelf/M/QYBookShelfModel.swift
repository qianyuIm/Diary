//
//  QYBookShelfItem.swift
//  Diary
//
//  Created by cyd on 2021/2/7.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import Foundation
import GRDB

class QYBookShelfModel: Codable {
    var rowId: Int64?
    var book_id: String?
    var book_name: String?
    var book_img: String?
    /// 加入时间戳
    var joinTime: TimeInterval?
    /// 设置行名
    private enum Columns: String, CodingKey, ColumnExpression {
        case book_id
        /// 加入时间
        case joinTime
    }
}
extension QYBookShelfModel: MutablePersistableRecord, FetchableRecord {
    private static let dbQueue = QYDataBaseManager.shared.dbQueue
    /// 按时间顺序查找
    static func orderedByJoinTime() -> QueryInterfaceRequest<QYBookShelfModel> {
        return QYBookShelfModel.order(Columns.joinTime.desc)
    }
    static var databaseTableName: String {
        return QYDataBaseTableName.readerBookShelf
    }
    func didInsert(with rowID: Int64, for column: String?) {
        rowId = rowID
    }
    /// 建表
    static func createTableIfNeeded() {
        try? dbQueue.inDatabase({ (db) in
            if try db.tableExists(databaseTableName) {
                return
            }
            try db.create(table: databaseTableName, temporary: false, ifNotExists: true, body: { (tb) in
                tb.autoIncrementedPrimaryKey("rowId")
                tb.column(Columns.book_id.rawValue, .text)
                tb.column("book_name", .text)
                tb.column("book_img", .text)
                tb.column(Columns.joinTime.rawValue, .double)
            })
        })
    }
    /// 插入数据
    static func insert(bookShelfModel: QYBookShelfModel) {
        // 判断是否存在
        guard query(bookShelfModel.book_id) == nil else {
            update(bookShelfModel)
            return
        }
        // 建表
        createTableIfNeeded()
        bookShelfModel.joinTime = Date().timeIntervalSince1970
        try? dbQueue.inTransaction { (db) -> Database.TransactionCompletion in
            do {
                var bookShelfModel = bookShelfModel
                try bookShelfModel.insert(db)
                return .commit
            } catch {
                return .rollback
            }
        }
    }
    /// 查询数据
    static func query(_ book_id: String?) -> QYBookShelfModel? {
        guard let book_id = book_id else { return nil }
        // 建表
        createTableIfNeeded()
        do {
            return try dbQueue.unsafeRead({ (db) -> QYBookShelfModel? in
                return try QYBookShelfModel
                    .filter(Column(Columns.book_id.rawValue) == book_id)
                    .fetchOne(db)
            })
        } catch {
            return nil
        }
    }
    static func queryAll() -> [QYBookShelfModel]? {
        // 建表
        createTableIfNeeded()
        do {
            return try dbQueue.read({ (db) -> [QYBookShelfModel]? in
                let request = QYBookShelfModel.orderedByJoinTime()
                return try request.fetchAll(db)
            })
        } catch {
            return nil
        }
    }
    /// 更新数据
    static func update(_ bookShelfModel: QYBookShelfModel) {
        // 建表
        createTableIfNeeded()
        // 事务 更新场景
        try? dbQueue.inTransaction { (db) -> Database.TransactionCompletion in
            do {
                try bookShelfModel.update(db)
                return .commit
            } catch {
                return .rollback
            }
        }
    }
    static func delete(book_id: String?) {
        guard let bookShelfItem = query(book_id) else {
            return
        }
        // 删除
        delete(bookShelfItem: bookShelfItem)
    }
    static func delete(bookShelfItem: QYBookShelfModel) {
        // 建表
        createTableIfNeeded()
        // 事务 更新场景
        try? dbQueue.inTransaction { (db) -> Database.TransactionCompletion in
            do {
                let aa  = try bookShelfItem.delete(db)
                logDebug("isdelete = \(aa)")
                return .commit
            } catch {
                return .rollback
            }
        }
    }
    
}
