//
//  QYHomeController.swift
//  Diary
//
//  Created by cyd on 2021/1/15.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit

class QYHomeController: QYBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "首页"
        self.tabBarItem.badgeValue = "8"
        let sender = UIButton(type: .custom)
        sender.addTarget(self, action: #selector(click), for: .touchUpInside)
        sender.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        sender.backgroundColor = .red
        view.addSubview(sender)
    }
    @objc func click() {
        self.tabBarItem.badgeValue = "121"
    }
    
}
