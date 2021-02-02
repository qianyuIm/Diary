//
//  QYTabbarController.swift
//  Diary
//
//  Created by cyd on 2021/1/15.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit

class QYTabbarController: QYCurvedTabbarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let home = subController(QYHomeController(style: .plain),
                                 normalIcon: QYIconFontDiaryIcons.tabHome,
                                 selectedIcon: QYIconFontDiaryIcons.tabHome)
        let bookShelf = subController(QYBookShelfController(),
                                      normalIcon: QYIconFontDiaryIcons.tabBookSelf,
                                      selectedIcon: QYIconFontDiaryIcons.tabBookSelf)
        let discovery = subController(QYDiscoveryController(),
                                      normalIcon: QYIconFontDiaryIcons.tabDiscovery,
                                      selectedIcon: QYIconFontDiaryIcons.tabDiscovery)
        let video = subController(QYVideoController(),
                                  normalIcon: QYIconFontDiaryIcons.tabVideo,
                                  selectedIcon: QYIconFontDiaryIcons.tabVideo)
        let mine = subController(QYMineController(),
                                 normalIcon: QYIconFontDiaryIcons.tabMine,
                                 selectedIcon: QYIconFontDiaryIcons.tabMine)
        viewControllers = [home, bookShelf, discovery, video, mine]
        selectedIndex = 1
    }
    func normalImage(_ icon: QYIconFontDiaryIcons) -> UIImage? {
        return icon.image(size: 24, foregroundColor: QYColor.tabbarNormalIconColor)
    }
    func selectedImage(_ icon: QYIconFontDiaryIcons) -> UIImage? {
        return icon.image(size: 24, foregroundColor: QYColor.tabbarSelectedIconColor)
    }
    func subController(_ controller: QYBaseController,
                    normalIcon: QYIconFontDiaryIcons,
                    selectedIcon: QYIconFontDiaryIcons) -> QYNavigationController {
        let normalImage = self.normalImage(normalIcon)
        let selectedImage = self.selectedImage(selectedIcon)
        controller.tabBarItem = QYCurvedTabbarItem(normalImage, selectedImage: selectedImage)
        let na = QYNavigationController(rootViewController: controller)
        return na
    }
}
