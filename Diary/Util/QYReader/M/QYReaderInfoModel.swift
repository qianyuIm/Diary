//
//  QYReaderInfoModel.swift
//  Diary
//
//  Created by cyd on 2021/2/2.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
import HandyJSON
class QYReaderInfoModel: HandyJSON {
    var book_id: String?
    var Name: String?
    // woyouyigeshenfenbianjiqi.jpg
    var Img: String?
    var Author: String?
    var Desc: String?
    var Cid: Int?
    var CName: String?
    var LastTime: String?
    var FirstChapterId: Int?
    var LastChapter: String?
    var LastChapterId: Int?
    var BookStatus: String?
    var SameUserBooks: [QYReaderModel]?
    var SameCategoryBooks: [QYReaderModel]?
    var BookVote: QYReaderVoteModel?
    var book_img: String? {
        if Img == nil {
            return Img
        }
        return "https://imgapixs.pysmei.com//BookFiles/BookImages/" + Img!
    }
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.book_id <-- ("Id", TransformOf<String, Int>(fromJSON: { (rawValue) -> String? in
                if let _height = rawValue {
                    return "\(_height)"
                }
                return nil
            }, toJSON: { (rawValue) -> Int? in
                if let _str = rawValue {
                    return Int(_str) ?? 0
                }
                return nil
            }))
    }
}
