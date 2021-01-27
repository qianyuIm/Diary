//
//  QYHomeController.swift
//  Diary
//
//  Created by cyd on 2021/1/15.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit

class QYHomeController: QYBaseController {
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.navigationItem.title = "首页"
        self.tabBarItem.badgeValue = "8"
        let sender = UIButton(type: .custom)
        sender.addTarget(self, action: #selector(click), for: .touchUpInside)
        sender.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        sender.backgroundColor = .red
        view.addSubview(sender)
    }
    @objc func click() {
        let one = QYReaderStatisticalItem()
        let date = Date()
        one.date = dateFormatter.string(from: date)
        one.timeInterval = 12345
        QYReaderStatisticalItem.insert(statisticalItem: one)
        one.timeInterval = 123454
        QYReaderStatisticalItem.insert(statisticalItem: one)
        let two = QYReaderStatisticalItem()
        two.date = "2019-12-11"
        two.timeInterval = 12345
        QYReaderStatisticalItem.insert(statisticalItem: two)
        let three = QYReaderStatisticalItem()
        three.date = "2019-12-13"
        three.timeInterval = 12345
        QYReaderStatisticalItem.insert(statisticalItem: three)
        let four = QYReaderStatisticalItem()
        four.date = "2020-1-13"
        four.timeInterval = 12345
        QYReaderStatisticalItem.insert(statisticalItem: four)
        let all = QYReaderStatisticalItem.queryAll()
        all?.forEach({ (item) in
            logDebug(item.date)
        })
    }
    
}
