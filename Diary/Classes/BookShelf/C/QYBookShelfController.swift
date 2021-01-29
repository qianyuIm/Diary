//
//  QYBookShelfController.swift
//  Diary
//
//  Created by cyd on 2021/1/19.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit

class QYBookShelfController: QYBaseController {
    lazy var searchBarButtonItem: UIBarButtonItem = {
        let searchImage = QYIconFontDiaryIcons.navigationBarSearch.image(size: 27, foregroundColor: QYColor.navigationBarTintColor)
        let searchBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        searchBarButton.setImage(searchImage, for: .normal)
        searchBarButton.addTarget(self, action: #selector(searchBarButtonItemDidTap), for: .touchUpInside)
        searchBarButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        let searchView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        searchView.addSubview(searchBarButton)
        let searchBarButtonItem = UIBarButtonItem(customView: searchView)
        return searchBarButtonItem
    }()
    lazy var addBarButtonItem: UIBarButtonItem = {
        let addImage = QYIconFontDiaryIcons.navigationBarAdd.image(size: 27, foregroundColor: QYColor.navigationBarTintColor)
        let addBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        addBarButton.setImage(addImage, for: .normal)
        addBarButton.addTarget(self, action: #selector(addBarButtonItemDidTap), for: .touchUpInside)
        let addView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        addView.addSubview(addBarButton)
        let addBarButtonItem = UIBarButtonItem(customView: addView)
        return addBarButtonItem
    }()
    lazy var statisticalTimeBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "本周读分钟", style: .plain, target: nil, action: nil)
        return item
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "书架"
        self.navigationItem.leftBarButtonItem = statisticalTimeBarButtonItem
        self.navigationItem.rightBarButtonItems = [addBarButtonItem, searchBarButtonItem]
    }
    @objc func searchBarButtonItemDidTap() {
        let box = QYReaderBoxController()
        self.navigationController?.pushViewController(box, animated: true)
    }
    @objc func addBarButtonItemDidTap() {
        QYAlert.alert(title: "123", message: "123", cancel: "123", done: "123", doneAction: nil, cancelAction: nil)
    }
}
