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
import SkeletonView
import UIImageColors
class QYReaderInfoController: QYVMController<QYReaderInfoViewModel> {

    private var bookId: String
    init(bookId: String) {
        self.bookId = bookId
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let segmentedViewHeight: CGFloat = QYInch.value(50)
    private let segmentedTitleViewHeight: CGFloat = QYInch.value(40)
    private var isTitleViewShow: Bool = false
    lazy var titleView: QYReaderInfoNavigationTitleView = {
        let view = QYReaderInfoNavigationTitleView(frame: CGRect(x: 0, y: 0, width: QYInch.screenWidth - 100, height: 44))
        return view
    }()
    lazy var headerView: QYReaderInfoHeaderView = {
        let header = QYReaderInfoHeaderView(frame: CGRect(x: 0, y: 0, width: QYInch.screenWidth, height: QYInch.screenHeight))
        header.backgroundColor = QYColor.backgroundColor
        header.updateColors = { [weak self] colors in
            self?.updateColors(colors)
        }
        return header
    }()
    lazy var segmentedTitleView: JXSegmentedView = {
        let segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: (segmentedViewHeight - segmentedTitleViewHeight) / 2, width: QYInch.screenWidth, height: segmentedTitleViewHeight))
        segmentedView.delegate = self
        segmentedView.contentEdgeInsetLeft = 16
        segmentedView.backgroundColor = QYColor.backgroundColor
        
        let lineView = JXSegmentedIndicatorLineView()
        lineView.lineStyle = .lengthen
        lineView.indicatorColor = QYColor.colorDDD
        segmentedView.indicators = [lineView]
        return segmentedView
    }()
    lazy var segmentedDataSource: JXSegmentedNumberDataSource = {
        let dataSource = JXSegmentedNumberDataSource()
        dataSource.titleNormalColor = QYColor.colorDDD
        dataSource.titleSelectedColor = QYColor.colorDDD
        dataSource.titleNormalFont = QYFont.fontMedium(15)
        dataSource.numberFont = QYFont.fontRegular(11)
        dataSource.numberOffset = CGPoint(x: 10, y: 6)
        dataSource.itemSpacing = QYInch.value(50)
        dataSource.isItemSpacingAverageEnabled = false
        dataSource.numberBackgroundColor = .clear
        dataSource.numberTextColor = QYColor.colorDDD
        return dataSource
    }()
    lazy var segmentedView: UIView = {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: QYInch.screenWidth, height: segmentedViewHeight))
        titleView.backgroundColor = QYColor.backgroundColor
        let topView = UIView(frame: CGRect(x: (QYInch.screenWidth - QYInch.value(60)) / 2, y: 4, width: QYInch.value(60), height: 5))
        topView.isSkeletonable = true
        topView.backgroundColor = QYColor.colorDDD
        topView.ext.addRoundCorners(.allCorners, radius: 3)
        titleView.addSubview(segmentedTitleView)
        titleView.addSubview(topView)
        return titleView
    }()
    
    lazy var smoothView: GKPageSmoothView = {
        let smoothView = GKPageSmoothView(dataSource: self)
        smoothView.frame = CGRect(x: 0, y: 0, width: QYInch.screenWidth, height: QYInch.screenHeight)
        smoothView.isUserInteractionEnabled = false
        smoothView.delegate = self
        smoothView.ceilPointHeight = QYInch.navigationHeight
        smoothView.isBottomHover = true
        smoothView.isAllowDragBottom = true
        smoothView.isAllowDragScroll = true
        return smoothView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    override func makeConstant() {
        super.makeConstant()
        segmentedDataSource.titles = ["章节"]
        segmentedDataSource.numbers = [12]
        segmentedTitleView.dataSource = segmentedDataSource
        segmentedTitleView.contentScrollView = self.smoothView.listCollectionView
    }
    override func makeNavigationBar() {
        super.makeNavigationBar()
        self.hbd_barAlpha = 0
    }
    override func makeUI() {
        super.makeUI()
        view.addSubview(smoothView)
        smoothView.reloadData()
    }

    override func bindViewModel() {
        super.bindViewModel()
        let input = QYReaderInfoViewModel.Input(bookId: bookId)
        let output = viewModel.transform(input: input)
        output.items.skip(1).asObservable().subscribe (onNext: { [weak self](items) in
            self?.refreshHeaderView(items)
        }).disposed(by: rx.disposeBag)
    }
    override func loadingStateDidChanged() {
        super.loadingStateDidChanged()
        if isLoading {
            QYHelper.mainAsync {
                self.headerView.showGradientSkeleton()
            }
        } else {
            self.headerView.hideSkeleton()
        }
    }
    deinit {
        /// bugfix: 下面代码会造成 segmentedTitleView 不释放
        /// segmentedTitleView.contentScrollView = self.smoothView.listCollectionView
        segmentedTitleView.removeFromSuperview()
    }
}
extension QYReaderInfoController {
    /// 最好是后台传颜色
    func updateColors(_ colors: UIImageColors) {
        self.view.backgroundColor = colors.primary
        self.headerView.backgroundColor = colors.primary
        self.hbd_barTintColor = colors.primary
    }
    func changeNavigationTitle(_ isShow: Bool) {
        if isShow {
            if self.navigationItem.titleView != nil {
                return
            }
            self.navigationItem.titleView = titleView
        } else {
            if self.navigationItem.titleView == nil {
                return
            }
            self.navigationItem.titleView = nil
        }
    }
    func refreshHeaderView(_ items: [QYReaderInfoCellType]) {
        smoothView.isUserInteractionEnabled = true
        let infoItem = items.first?.headerItem
        titleView.config(score: infoItem?.BookVote?.Score, name: infoItem?.Name)
        self.headerView.sectionItems = items
        let headerHeight = headerView.calculateViewHeight()
        headerView.frame = CGRect(x: 0, y: 0, width: QYInch.screenWidth, height: headerHeight)
        //FixBug:
        smoothView.refreshHeaderView()
        smoothView.reloadData()
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
    func smoothViewDragBegan(_ smoothView: GKPageSmoothView) {
        if smoothView.isOnTop { return }
        self.isTitleViewShow = (self.navigationItem.titleView != nil)
    }
    func smoothViewListScrollViewDidScroll(_ smoothView: GKPageSmoothView, scrollView: UIScrollView, contentOffset: CGPoint) {
        if (smoothView.isOnTop) { return }
        let offsetY = contentOffset.y
        var alpha: CGFloat = 0
        if offsetY <= 0 {
            alpha = 0
            changeNavigationTitle(false)
        } else if offsetY > QYInch.navigationHeight {
            alpha = 1
            changeNavigationTitle(true)
        } else {
            alpha = offsetY / QYInch.navigationHeight
            changeNavigationTitle(false)
        }
        self.hbd_barAlpha = Float(alpha)
        self.hbd_setNeedsUpdateNavigationBar()
    }
    func smoothViewDragEnded(_ smoothView: GKPageSmoothView, isOnTop: Bool)  {
        // titleView已经显示，不作处理
        if self.isTitleViewShow { return }
        if isOnTop {
            self.hbd_barAlpha = 1.0
            changeNavigationTitle(true)
        } else {
            self.hbd_barAlpha = 0.0
            changeNavigationTitle(false)
        }
        self.hbd_setNeedsUpdateNavigationBar()
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
        return QYReaderInfoChaptersView()
    }
    
}
