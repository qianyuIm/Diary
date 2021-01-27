//
//  QYIconFontDiary.swift
//  Diary
//
//  Created by cyd on 2021/1/25.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import Foundation
import EFIconFont

let QYDiaryIcons = EFIconFont.diaryIcons
extension EFIconFont {
    static let diaryIcons = QYIconFontDiaryIcons.self
}
extension QYIconFontDiaryIcons: EFIconFontCaseIterableProtocol {
    static var name: String {
        return "iconfont"
    }
    var unicode: String {
        return self.rawValue
    }
}

enum QYIconFontDiaryIcons: String {
    //MARK: -- Tabbar
    case tabHome = "\u{e6af}"
    case tabBookSelf = "\u{e690}"
    case tabDiscovery = "\u{e607}"
    case tabVideo = "\u{e600}"
    case tabMine = "\u{e729}"
    
    //MARK: -- NavigationBar
    case navigationBarLeftFixedSpaceBack = "\u{e62e}"
    case navigationBarSearch = "\u{e699}"
    case navigationBarAdd = "\u{e62c}"
    case navigationBarSet = "\u{e683}"
    case navigationBarMore = "\u{e605}"


}
