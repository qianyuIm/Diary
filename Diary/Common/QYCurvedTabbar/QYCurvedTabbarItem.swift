//
//  QYCurvedTabbarItem.swift
//  Diary
//
//  Created by cyd on 2021/1/19.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit

class QYCurvedTabbarItem: UITabBarItem {
    lazy var contentView: QYCurvedTabbarItemContentView = {
        return QYCurvedTabbarItemContentView()
    }()
    override var selectedImage: UIImage? {
        didSet {
            contentView.selectedImage = selectedImage
        }
    }
    override var image: UIImage? {
        didSet {
            contentView.image = image
        }
    }
    override var badgeValue: String? {
        get { return contentView.badgeValue }
        set(newValue) { contentView.badgeValue = newValue }
    }
    override var badgeColor: UIColor? {
        get { return contentView.badgeColor }
        set(newValue) { contentView.badgeColor = newValue }
    }
    init(_ image: UIImage? = nil,
         selectedImage: UIImage? = nil) {
        super.init()
        self.image = image
        self.selectedImage = selectedImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
