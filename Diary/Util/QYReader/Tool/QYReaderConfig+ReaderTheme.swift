//
//  QYReaderConfig+ReaderTheme.swift
//  Diary
//
//  Created by cyd on 2021/1/27.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import Foundation
import SwiftTheme
import HandyJSON

func themeColorPicker(_ wrapper: QYReaderThemeWrapper) -> ThemeColorPicker {
    return wrapper.rawValue.colorPicker
}
func themeImagePicker(_ wrapper: QYReaderThemeWrapper) -> ThemeImagePicker {
    return wrapper.rawValue.imagePicker
}
extension QYReaderConfig {
    /// 主题类型
    enum QYReaderThemeType: Int, Codable {
        case `default`
        case green
        case yellow
        case pink
        case night
        /// 自定义
        case custom
    }
    enum QYReaderTheme {
        case `default`
        case green
        case yellow
        case pink
        case night
        /// 自定义
        case custom(URL)
        static func theme(for themeType: QYReaderThemeType,
                   themeCustomFile: URL? = nil) -> QYReaderTheme {
            switch themeType {
            case .default:
                return .default
            case .green:
                return .green
            case .yellow:
                return .yellow
            case .pink:
                return .pink
            case .night:
                return .night
            case .custom:
                return .custom(themeCustomFile!)
            }
        }
    }
    /// 单个主题
    struct QYReaderThemeItem: Codable, Equatable {
        var themeType: QYReaderThemeType
        var themeCustomFile: URL?
        init(themeType: QYReaderThemeType,
             themeCustomFile: URL? = nil) {
            self.themeType = themeType
            self.themeCustomFile = themeCustomFile
        }
        static func == (lhs: QYReaderConfig.QYReaderThemeItem, rhs: QYReaderConfig.QYReaderThemeItem) -> Bool {
            return (lhs.themeType == rhs.themeType) && (lhs.themeCustomFile == rhs.themeCustomFile)
        }
    }
    /// 当前的主题
    var currentTheme: QYReaderTheme {
        return QYReaderTheme.theme(for: themeType, themeCustomFile: themeCustomFile)
    }
    /// 是否黑暗主题
    var isNightTheme: Bool {
        return themeType == .night
    }
    /// 配置主题
    func switchTheme(for themeType: QYReaderThemeType? = nil,
                     themeCustomFile: URL? = nil) {
        if themeType != nil {
            self.previousThemeItem = QYReaderThemeItem(themeType: self.themeType,
                                                          themeCustomFile: themeCustomFile)
        }
        self.themeType = (themeType != nil) ? themeType! : self.themeType
        self.themeCustomFile = themeCustomFile
        let theme = QYReaderTheme.theme(for: self.themeType,
                                        themeCustomFile: self.themeCustomFile)
        addCustomThemeItem(themeCustomFile: self.themeCustomFile)
        /// 必须先保存 再设置
        update()
        swictTo(theme)
    }
    /// 配置夜间主题
    func switchNight() {
        switchTheme(for: .night)
    }
}
private extension QYReaderConfig {
    static var QYReaderBundle = Bundle.ext.bundle(with: "QYReader")
    static var defaultThemeFile: URL? {
        guard let bundle = QYReaderBundle else {
            logError("请查看主题配置")
            return nil
        }
        guard let plistPath = bundle.path(forResource: "defaultTheme", ofType: nil) else {
            logError("请查看主题配置")
            return nil
        }
        let plistFile = URL(fileURLWithPath: plistPath)
        return plistFile
    }
    private func swictTo(_ theme: QYReaderTheme) {
        switch theme {
        case .default:
            if let defaultThemeFile = QYReaderConfig.defaultThemeFile {
                switct(for: .sandbox(defaultThemeFile), themeName: "default")
            }
        case .green:
            if let defaultThemeFile = QYReaderConfig.defaultThemeFile {
                switct(for: .sandbox(defaultThemeFile), themeName: "green")
            }
        case .yellow:
            if let defaultThemeFile = QYReaderConfig.defaultThemeFile {
                switct(for: .sandbox(defaultThemeFile), themeName: "yellow")
            }
        case .pink:
            if let defaultThemeFile = QYReaderConfig.defaultThemeFile {
                switct(for: .sandbox(defaultThemeFile), themeName: "pink")

            }
        case .night:
            if let defaultThemeFile = QYReaderConfig.defaultThemeFile {
                switct(for: .sandbox(defaultThemeFile), themeName: "night")
            }
        case .custom(let plistFile):
            let fileName = plistFile.lastPathComponent
            switct(for: .sandbox(plistFile), themeName: fileName)
        }
    }
    private func switct(for themePath: ThemePath,
                               themeName: String) {
        guard let plistPath = themePath.plistPath(name: themeName) else {
            print("SwiftTheme WARNING: Can't find plist '\(themeName)' at: \(themePath)")
            return
        }
        guard let plistDict = NSDictionary(contentsOfFile: plistPath) else {
            print("SwiftTheme WARNING: Can't read plist '\(themeName)' at: \(themePath)")
            return
        }
        ThemeManager.setTheme(dict: plistDict, path: themePath)
    }
    /// 用于扩展网络皮肤
    private func addCustomThemeItem(themeCustomFile: URL?) {
        guard themeCustomFile != nil else {
            return
        }
        let customFiles = self.themeItems.map { (item) -> URL? in
            return item.themeCustomFile
        }.compactMap { $0 }
        if !customFiles.contains(themeCustomFile!) {
            let add = QYReaderThemeItem(themeType: .custom,
                                           themeCustomFile: themeCustomFile)
            self.themeItems.append(add)
        }
    }
}
private extension String {
    var colorPicker: ThemeColorPicker {
        return ThemeColorPicker(keyPath: self)
    }
    var imagePicker: ThemeImagePicker {
        return ThemeImagePicker(keyPath: self)
    }
}
struct QYReaderThemeWrapper: Codable {
    let rawValue: String
    init(_ rawValue: String) {
        self.rawValue = rawValue
    }
    //MARK: -- color
    /// 阅读背景色
    static let readBackgroundColor = QYReaderThemeWrapper("color.readBackgroundColor")
    /// 阅读字体颜色
    static let readTextColor = QYReaderThemeWrapper("color.readTextColor")
    /// menu背景色
    static let menuBackgroundColor = QYReaderThemeWrapper("color.menuBackgroundColor")
    /// menuLine背景色
    static let menuLineBackgroundColor = QYReaderThemeWrapper("color.menuLineBackgroundColor")
    /// menuNormalTextColor
    static let menuNormalTextColor = QYReaderThemeWrapper("color.menuNormalTextColor")
    /// menuNormalTitleTextColor
    static let menuNormalTitleTextColor = QYReaderThemeWrapper("color.menuNormalTitleTextColor")
    /// menuSelectTextColor
    static let menuSelectTextColor = QYReaderThemeWrapper("color.menuSelectTextColor")
    /// menuNightSelectTextColor
    static let menuNightSelectTextColor = QYReaderThemeWrapper("color.menuNightSelectTextColor")
    /// minimumTrackTintColor
    static let minimumTrackTintColor = QYReaderThemeWrapper("color.minimumTrackTintColor")
    /// maximumTrackTintColor
    static let maximumTrackTintColor = QYReaderThemeWrapper("color.maximumTrackTintColor")
    /// readBottomTextColor
    static let readBottomTextColor = QYReaderThemeWrapper("color.readBottomTextColor")
    /// readFontSizeTextColor
    static let readFontSizeTextColor = QYReaderThemeWrapper("color.readFontSizeTextColor")
    /// readFontSizeBackgroundColor
    static let readFontSizeBackgroundColor = QYReaderThemeWrapper("color.readFontSizeBackgroundColor")
    //MARK: -- image
    /// navigationBackImage
    static let navigationBackImage = QYReaderThemeWrapper("image.navigationBackImage")
    /// readCoverImage
    static let readCoverImage = QYReaderThemeWrapper("image.readCoverImage")
    /// readItemSelectImage
    static let readItemSelectImage = QYReaderThemeWrapper("image.readItemSelectImage")
    /// readItemImage
    static let readItemImage = QYReaderThemeWrapper("image.readItemImage")
    /// readLightLowImage
    static let readLightLowImage = QYReaderThemeWrapper("image.readLightLowImage")
    /// readLightHightImage
    static let readLightHightImage = QYReaderThemeWrapper("image.readLightHightImage")
    /// readSettingSelectImage
    static let readSettingSelectImage = QYReaderThemeWrapper("image.readSettingSelectImage")
    /// readSettingImage
    static let readSettingImage = QYReaderThemeWrapper("image.readSettingImage")
    /// readProgressImage
    static let readProgressImage = QYReaderThemeWrapper("image.readProgressImage")
    /// readProgressSelectImage
    static let readProgressSelectImage = QYReaderThemeWrapper("image.readProgressSelectImage")
    /// readNightImage
    static let readNightImage = QYReaderThemeWrapper("image.readNightImage")
    /// readNightSelectImage
    static let readNightSelectImage = QYReaderThemeWrapper("image.readNightSelectImage")
    /// readListImage
    static let readListImage = QYReaderThemeWrapper("image.readListImage")
    /// readListSelectImage
    static let readListSelectImage = QYReaderThemeWrapper("image.readListSelectImage")
    /// readListPositiveImage
    static let readListPositiveImage = QYReaderThemeWrapper("image.readListPositiveImage")
    /// navigationBackImage
    static let readListReversalImage = QYReaderThemeWrapper("image.readListReversalImage")
    /// readSliderImage
    static let readSliderImage = QYReaderThemeWrapper("image.readSliderImage")
    /// readVoiceImage
    static let readVoiceImage = QYReaderThemeWrapper("image.readVoiceImage")
    /// readAutoImage
    static let readAutoImage = QYReaderThemeWrapper("image.readAutoImage")
}

