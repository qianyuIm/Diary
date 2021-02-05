//
//  QYInch+reader.swift
//  Diary
//
//  Created by cyd on 2021/2/3.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import Foundation
extension QYInch {
    /// 详情左
    static let infoLeft = value(12)
    /// 详情右
    static let infoRight = value(12)
    /// 小说详情 header
    struct readerInfoHeader {
        /// 距离顶部高度
        static let top = QYInch.value(20) + QYInch.navigationHeight
        /// 封面高度
        static let coverImageHeight = QYInch.value(130)
        /// 封面宽度
        static let coverImageWidth = QYInch.value(100)
        /// 封面与底部间距
        static let coverImageBottom = QYInch.value(20)
        /// 距离底部高度
        static let bottom = QYInch.value(20)
        /// 整体高度 40 为预留label高度
        static let height = top + coverImageHeight + coverImageBottom + bottom
    }
    /// 相同作者
    struct readerInfoUser {
        static let top = QYInch.value(15)
        /// 封面高度
        static let coverImageHeight = QYInch.value(100)
        /// 封面宽度
        static let coverImageWidth = QYInch.value(80)
        static let bottom = QYInch.value(15)
        static let height = top + coverImageHeight + bottom

    }
    /// 相同类型
    struct readerInfoCategory {
        static let top = QYInch.value(12)
        /// 封面高度
        static let coverImageHeight = QYInch.value(100)
        /// 封面宽度
        static let coverImageWidth = QYInch.value(80)
        static let itemSize = CGSize(width: (QYInch.screenWidth / 3).ext.floor, height: top + coverImageHeight + QYInch.value(30))
    }
}
extension QYInch {
    /// 封面距上
    static let infoHeaderCoverImageTop = value(20)
    /// 封面宽度
    static let infoHeaderCoverImageWidth = value(100)
    /// 封面高度
    static let infoHeaderCoverImageHeight = value(130)
    /// 封面距上
    static let infoHeaderCoverImageBottom = value(20)
    
    /// 详情简介top
    static let infoHeaderIntroTop = value(20)
    /// 详情简介bottom
    static let infoHeaderIntroBottom = value(20)
    /// 作者还写过 top
    static let infoHeaderSameUserTop = value(20)
    /// 作者还写过 bottom
    static let infoHeaderSameUserBottom = value(20)
    /// 作者还写过 cover bottom
    static let infoHeaderSameUserCollectionCoverImageBottom = value(12)
    /// 作者还写过 cover top
    static let infoHeaderSameUserCollectionCoverImageTop = value(12)
    /// 作者还写过 cover Height
    static let infoHeaderSameUserCollectionCoverImageHeight = value(120)
    /// 作者还写过 cover Width
    static let infoHeaderSameUserCollectionCoverImageWidth = value(120)

}
