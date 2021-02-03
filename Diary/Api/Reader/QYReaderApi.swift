//
//  QYReaderApi.swift
//  Diary
//
//  Created by cyd on 2021/2/2.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import Foundation
import Moya
enum QYReaderApi {
    /// 热搜
    case hotSearch
    /// 查找小说
    case search(String)
    /// 小说信息
    case readerInfo(String)
    /// 章节信息
    case chapterInfo(String,String)
    /// 章节列表
    case chapters(String)
    /// 字体列表
    case fontList
}
extension QYReaderApi: TargetType {
    var baseURL: URL {
        switch self {
        case .hotSearch:
            return URL(string: "https://scxs.pysmei.com")!
        case .search:
            return URL(string: "https://souxs.leeyegy.com")!
        case .readerInfo, .chapters:
            return URL(string: "https://infosxs.pysmei.com")!
        case .chapterInfo:
            return URL(string: "https://contentxs.pysmei.com/")!
        case .fontList:
            return URL(string: "https://scxs.pysmei.com")!
        }
    }
    
    var path: String {
        switch self {
        case .hotSearch:
            return "/StaticFiles/NewHotBook.html"
        case .search:
            return "search.aspx"
        case .readerInfo(let book_id):
            // 去除后三位在加一
            let idx1 = book_id.startIndex;
            let idx2 = book_id.index(book_id.endIndex, offsetBy: -3);
            let file_id = book_id[idx1 ..< idx2]
            let file_num = "\((Int(file_id) ?? 0) + 1)"
            return "/BookFiles/Html/\(file_num)/\(book_id)/info.html"
        case .chapters(let book_id):
            // https://infosxs.pysmei.com/BookFiles/Html/310/309647/index.html
            // 去除后三位在加一
            let idx1 = book_id.startIndex;
            let idx2 = book_id.index(book_id.endIndex, offsetBy: -3);
            let file_id = book_id[idx1 ..< idx2]
            let file_num = "\((Int(file_id) ?? 0) + 1)"
            return "/BookFiles/Html/\(file_num)/\(book_id)/index.html"
        case .chapterInfo(let book_id, let chapter_id):
            // https://contentxs.pysmei.com//BookFiles/Html/170/169753/8820058.html
            // 去除后三位在加一
            let idx1 = book_id.startIndex;
            let idx2 = book_id.index(book_id.endIndex, offsetBy: -3);
            let file_id = book_id[idx1 ..< idx2]
            let file_num = "\((Int(file_id) ?? 0) + 1)"
            return "/BookFiles/Html/\(file_num)/\(book_id)/\(chapter_id).html"
        case .fontList:
            return "/prov8/base/fontlist.html"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        switch self {
        case .readerInfo:
            return QYHelper.localJsonData(with: "readerInfo")
        default:
            return QYHelper.localJsonData(with: "")
        }
    }
    
    var task: Task {
        switch self {
        case .hotSearch, .readerInfo,
             .chapterInfo, .chapters,
             .fontList:
            return .requestPlain
        case .search(let key):
            return .requestParameters(parameters: ["key" : key,
                                                   "page": 1,
                                                   "siteid": "app2"], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
