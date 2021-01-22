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
        let home = subController(QYHomeController(),
                                 normal: "tab-home",
                                 selected: "tab-home")
        let bookShelf = subController(QYBookShelfController(),
                                      normal: "tab-bookShelf",
                                      selected: "tab-bookShelf")
        let discovery = subController(QYDiscoveryController(),
                                          normal: "tab-discovery",
                                          selected: "tab-discovery")
        let video = subController(QYVideoController(),
                                          normal: "tab-video",
                                          selected: "tab-video")
        let mine = subController(QYMineController(),
                                          normal: "tab-mine",
                                          selected: "tab-mine")
        viewControllers = [home, bookShelf, discovery, video, mine]
//        selectedIndex = 3
    }
    func subController(_ controller: QYBaseController,
                    normal: String,
                    selected: String) -> QYNavigationController {
        let image = UIImage(named: normal)
        let selectedImage = UIImage(named: selected)
        controller.tabBarItem = QYCurvedTabbarItem(image, selectedImage: selectedImage)
        let na = QYNavigationController(rootViewController: controller)
        return na
    }
}
