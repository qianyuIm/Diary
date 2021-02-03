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
//import SkeletonView
class QYReaderInfoController: UIViewController {

    private var bookId: String
    init(bookId: String) {
        self.bookId = bookId
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let segmentedViewHeight: CGFloat = QYInch.value(60)
    private let segmentedTitleViewHeight: CGFloat = QYInch.value(40)

    lazy var headerView: QYReaderInfoHeaderView = {
        let header = QYReaderInfoHeaderView(frame: CGRect(x: 0, y: 0, width: QYInch.screenWidth, height: QYInch.screenHeight - segmentedViewHeight))
        return header
    }()
    lazy var segmentedTitleView: JXSegmentedView = {
        let segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: (segmentedViewHeight - segmentedTitleViewHeight) / 2, width: QYInch.screenWidth, height: segmentedTitleViewHeight))
//        segmentedView.delegate = self
        segmentedView.backgroundColor = QYColor.random
        return segmentedView
    }()
    var segmentedDataSource = JXSegmentedTitleDataSource()
    lazy var segmentedView: UIView = {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: QYInch.screenWidth, height: segmentedViewHeight))
        titleView.backgroundColor = QYColor.random
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
    
    lazy var smoothView: GKPageSmoothView = {
        let smoothView = GKPageSmoothView(dataSource: self)
//        smoothView.delegate = self
//        smoothView.ceilPointHeight = QYInch.navigationHeight
//        smoothView.isBottomHover = true
//        smoothView.isAllowDragBottom = true
//        smoothView.isAllowDragScroll = true
//        smoothView.isControlVerticalIndicator = true
        return smoothView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hbd_barAlpha = 0
        view.addSubview(smoothView)
        smoothView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        segmentedDataSource.titles = ["章节"]
        segmentedView.addSubview(segmentedTitleView)
        segmentedTitleView.dataSource = segmentedDataSource
        segmentedTitleView.contentScrollView = self.smoothView.listCollectionView
        smoothView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//
    }
//    override func makeNavigationBar() {
//        super.makeNavigationBar()
//        self.hbd_barAlpha = 0
//    }
//    override func makeUI() {
//        super.makeUI()
//        view.addSubview(smoothView)
//        smoothView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//        segmentedDataSource.titles = ["章节"]
//        segmentedView.addSubview(segmentedTitleView)
//        segmentedTitleView.dataSource = segmentedDataSource
//        segmentedTitleView.contentScrollView = self.smoothView.listCollectionView
//        smoothView.reloadData()
//
//    }
//    override func makeConstraints() {
//        super.makeConstraints()
//
//    }
//    override func bindViewModel() {
//        super.bindViewModel()
//        let input = QYReaderInfoViewModel.Input(bookId: bookId)
//        let output = viewModel.transform(input: input)
//        output.items.skip(1).asObservable().subscribe (onNext: { (items) in
////            self.headerView.items = items
////            self.refreshHeaderView()
//        }).disposed(by: rx.disposeBag)
//    }
    deinit {
        // bugfix: 下面代码会造成 segmentedTitleView 不释放
        // segmentedTitleView.contentScrollView = self.smoothView.listCollectionView
        segmentedTitleView.removeFromSuperview()
    }
}
extension QYReaderInfoController {
    func refreshHeaderView() {
//        let headerHeight = headerView.calculateViewHeight()
//        headerView.frame = CGRect(x: 0, y: 0, width: QYInch.screenWidth, height: headerHeight)
//        //FixBug:
//        smoothView.refreshHeaderView()
//        smoothView.reloadData()
    }
}
extension QYReaderInfoController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        if !smoothView.isOnTop {
            smoothView.showingOnTop()
        }
    }
}
extension QYReaderInfoController: GKPageSmoothViewDelegate {
    func smoothViewDidScroll(_ smoothView: GKPageSmoothView, scrollView: UIScrollView) {
        
    }
}
extension QYReaderInfoController: GKPageSmoothViewDataSource {
    
    func headerView(in smoothView: GKPageSmoothView) -> UIView {
        return headerView
    }
    func segmentedView(in smoothView: GKPageSmoothView) -> UIView {
        return segmentedView
    }
    func numberOfLists(in smoothView: GKPageSmoothView) -> Int {
        return segmentedDataSource.titles.count
    }
    func smoothView(_ smoothView: GKPageSmoothView, initListAtIndex index: Int) -> GKPageSmoothListViewDelegate {
        return GKDBListView()
    }
    
}
