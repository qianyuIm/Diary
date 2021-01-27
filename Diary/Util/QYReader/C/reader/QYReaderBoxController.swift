//
//  QYReaderBoxController.swift
//  Diary
//
//  Created by cyd on 2021/1/26.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit

class QYReaderBoxController: UIViewController {
    let statistical = QYReaderStatistical.shared
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        statistical.track()
        setupConfig()
        setupTheme()
    }
    func setupConfig() {
        QYReaderConfig.shared().switchTheme()
    }
    func setupTheme() {
        view.theme_backgroundColor = themeColorPicker(.readBackgroundColor)
    }
    deinit {
        
        statistical.unTrack()
    }

}
