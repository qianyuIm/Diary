//
//  QYReaderModel.swift
//  Diary
//
//  Created by cyd on 2021/2/3.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import Foundation
import HandyJSON

class QYReaderModel: HandyJSON {
    var book_id: String?
    var Name: String?
    var Img: String?
    var Author: String?
    var LastChapter: String?
    var LastChapterId: String?
    var Score: NSNumber?
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
class QYReaderVoteModel: HandyJSON {
    var book_id: Int?
    var TotalScore: Int?
    var VoterCount: Int?
    var Score: NSNumber?
    required init() {}
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.book_id <-- "Id"
    }
}

