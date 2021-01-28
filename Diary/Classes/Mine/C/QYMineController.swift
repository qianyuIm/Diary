//
//  QYMineController.swift
//  Diary
//
//  Created by cyd on 2021/1/19.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit

class QYMineController: QYBaseController {
    lazy var setBarButtonItem: UIBarButtonItem = {
        let setImage = QYIconFontDiaryIcons.navigationBarSet.image(size: 23, foregroundColor: QYColor.navigationBarTintColor)
        let setBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        setBarButton.setImage(setImage, for: .normal)
        setBarButton.addTarget(self, action: #selector(setBarButtonItemDidTap), for: .touchUpInside)
        setBarButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        let setView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        setView.addSubview(setBarButton)
        let setBarButtonItem = UIBarButtonItem(customView: setView)
        return setBarButtonItem
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "我的"
        self.navigationItem.leftBarButtonItem = setBarButtonItem
        
    }
    @objc func setBarButtonItemDidTap() {}
}
