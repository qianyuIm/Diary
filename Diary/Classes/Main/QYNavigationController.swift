//
//  QYNavigationController.swift
//  Diary
//
//  Created by cyd on 2021/1/15.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
import HBDNavigationBar
extension UIViewController {
    /// 导航按钮返回点击
    @objc func popViewControllerByBackButtonDidClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
class QYNavigationController: HBDNavigationController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let count = self.viewControllers.count
        if count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            /// image 向左偏移 页面效果
            let image = QYIconFontDiaryIcons.navigationBarBack.image(size: 24, foregroundColor: QYColor.navigationBarTintColor)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backwardAction))
        }
        super.pushViewController(viewController, animated: animated)
    }
    @objc func backwardAction() {
        let topVc = self.topViewController
        topVc?.popViewControllerByBackButtonDidClick()
    }
}
