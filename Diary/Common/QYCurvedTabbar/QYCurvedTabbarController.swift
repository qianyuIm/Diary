//
//  QYCurvedTabbarController.swift
//  Diary
//
//  Created by cyd on 2021/1/19.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit

class QYCurvedTabbarController: UITabBarController {
    fileprivate var ignoreNextSelection = false
    override var selectedViewController: UIViewController? {
        willSet {
            guard let newValue = newValue else {
                // if newValue == nil ...
                return
            }
            guard !ignoreNextSelection else {
                ignoreNextSelection = false
                return
            }
            guard let tabBar = self.tabBar as? QYCurvedTabbar,
                  let _ = tabBar.items,
                  let index = viewControllers?.firstIndex(of: newValue) else {
                return
            }
            tabBar.select(itemAtIndex: index, animated: false)
        }
    }
    override var selectedIndex: Int {
        willSet {
            guard !ignoreNextSelection else {
                ignoreNextSelection = false
                return
            }
            guard let tabBar = self.tabBar as? QYCurvedTabbar,
                  let _ = tabBar.items else {
                return
            }
            tabBar.select(itemAtIndex: newValue, animated: false)
        }
    }
    /// Customize set tabBar use KVC.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tabBar = { () -> QYCurvedTabbar in
            let tabBar = QYCurvedTabbar()
            tabBar.delegate = self
            tabBar.tabBarController = self
            return tabBar
        }()
        self.setValue(tabBar, forKey: "tabBar")
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item) else {
            return;
        }
        if let selected = viewControllers?[idx] {
            ignoreNextSelection = true
            selectedIndex = idx
            delegate?.tabBarController?(self, didSelect: selected)
        }
    }
}
