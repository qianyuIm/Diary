//
//  QYReaderInfoController.swift
//  Diary
//
//  Created by cyd on 2021/2/2.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
import GKPageSmoothView
import JXSegmentedView
class QYReaderInfoController: QYVMController<QYReaderInfoViewModel> {

    private var bookId: Int
    init(bookId: Int) {
        self.bookId = bookId
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var headerView: QYReaderInfoHeaderView = {
        let header = QYReaderInfoHeaderView()
        return header
    }()
    private let segmentedViewHeight: CGFloat = QYInch.value(60)
    lazy var segmentedView: UIView = {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: QYInch.screenWidth, height: segmentedViewHeight))
        titleView.addSubview(segmentedTitleView)
        
        let topView = UIView()
        topView.backgroundColor = .red
        topView.ext.addRoundCorners(.allCorners, radius: 3)
        titleView.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(QYInch.value(60))
            make.height.equalTo(QYInch.value(6))
        }
        return titleView
    }()
    lazy var segmentedTitleView: JXSegmentedView = {
        let segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 10, width: QYInch.screenWidth, height: 40))
        segmentedView.backgroundColor = QYColor.random
        return segmentedView
    }()
    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.titles = ["123"]
        return dataSource
    }()
    lazy var smoothView: GKPageSmoothView = {
        let smoothView = GKPageSmoothView(dataSource: self)
        smoothView.delegate = self
        smoothView.ceilPointHeight = QYInch.navigationHeight
        smoothView.isBottomHover = true
        smoothView.isAllowDragBottom = true
        smoothView.isAllowDragScroll = true
        smoothView.isControlVerticalIndicator = true
        return smoothView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.smoothView.reloadData()
        refreshHeaderView()
    }
    override func makeNavigationBar() {
        super.makeNavigationBar()
        self.hbd_barAlpha = 0
    }
    override func makeUI() {
        super.makeUI()
        view.addSubview(smoothView)
        segmentedTitleView.dataSource = segmentedDataSource
        self.segmentedTitleView.contentScrollView = self.smoothView.listCollectionView
    }
    override func makeConstraints() {
        super.makeConstraints()
        smoothView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    override func bindViewModel() {
        super.bindViewModel()
        
    }
}
extension QYReaderInfoController {
    func refreshHeaderView() {
        let headerHeight = headerView.calculateViewHeight()
        headerView.frame = CGRect(x: 0, y: 0, width: QYInch.screenWidth, height: headerHeight)
        //FixBug:
        self.smoothView.refreshHeaderView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.segmentedView.frame = CGRect(x: 0, y: 0, width: QYInch.screenWidth, height: self.segmentedViewHeight)
        }
    }
}
extension QYReaderInfoController: GKPageSmoothViewDelegate {
    
}
extension QYReaderInfoController: GKPageSmoothViewDataSource {
    
    func headerView(in smoothView: GKPageSmoothView) -> UIView {
        return headerView
    }
    func segmentedView(in smoothView: GKPageSmoothView) -> UIView {
        return self.segmentedView
    }
    func numberOfLists(in smoothView: GKPageSmoothView) -> Int {
        return segmentedDataSource.dataSource.count
    }
    func smoothView(_ smoothView: GKPageSmoothView, initListAtIndex index: Int) -> GKPageSmoothListViewDelegate {
        let chaptersView = QYReaderInfoChaptersView()
        return chaptersView
    }
    
}
