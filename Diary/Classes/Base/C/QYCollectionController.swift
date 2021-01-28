//
//  QYCollectionController.swift
//  Diary
//
//  Created by cyd on 2021/1/28.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit

class QYCollectionController: QYBaseController {
    private(set) var layout: UICollectionViewLayout = UICollectionViewLayout()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = QYColor.backgroundColor
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.ext.register(UICollectionViewCell.self)
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        return collectionView
    }()
    init(collectionViewLayout layout: UICollectionViewLayout) {
        self.layout = layout
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func makeUI() {
        super.makeUI()
        view.addSubview(collectionView)
    }
    override func makeConstraints() {
        super.makeConstraints()
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    override func loadingStateDidChanged() {
        collectionView.reloadEmptyDataSet()
    }
}
