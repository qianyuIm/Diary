//
//  QYReaderBaseModel.swift
//  Diary
//
//  Created by cyd on 2021/2/3.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import Foundation
import HandyJSON
class QYReaderBaseModel<T>: HandyJSON {
    var data: T?
    var status: Int = 1
    var info: String?
    required init() {}
}

