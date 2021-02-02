//
//  QYBaseController.swift
//  Diary
//
//  Created by cyd on 2021/1/19.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
import RxSwift
import EmptyDataSet_Swift
import SwiftRichString

class QYBaseController: UIViewController {

    lazy var emptyView: QYBaseEmptyView = {
        /// 防止约束冲突的 高度给个大高度
        let emptyView = QYBaseEmptyView(frame: CGRect(x: 0, y: 0, width: QYInch.screenWidth - QYInch.value(40), height: QYInch.emptyViewHeight))
        return emptyView
    }()
    let emptyTitleStyle = Style {
        $0.font = QYFont.fontMedium(26)
        $0.color = QYColor.color("#768087")
    }
    let emptyDescriptionStyle = Style {
        $0.font = QYFont.fontMedium(16)
        $0.color = QYColor.color("#B9C3C9")
    }
    /// 当前是否正在加载数据
    var isLoading: Bool = false {
        didSet {
            loadingStateDidChanged()
        }
    }
    /// 网络未连接是否可以滚动
    var isAllowedNoConnectionScroll: Bool = false
    /// 无数据是否可以滚动
    var isAllowedEmptyDataScroll: Bool = true
    var noConnectionEmptyImage: UIImage?
    var emptyImage: UIImage?
    var noConnectionEmptyTitle: NSAttributedString?
    var emptyTitle: NSAttributedString?
    var noConnectionEmptyDescription: NSAttributedString?
    var emptyDescription: NSAttributedString?
    // 如果想设置为 距离顶部100 则使用 ((view.height - QYInch.emptyViewHeight)/2 - 100)
    var emptyVerticalOffset: CGFloat = QYInch.navigationHeight
    /// 数据源 nil 时点击了 view
    var emptyDataSetDidTapView: (() -> Void)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        makeConstant()
        makeNotification()
        makeNavigationBar()
        makeUI()
        makeConstraints()
        makeTheme()
    }
    /// 1. 设置常量
    func makeConstant() {
        noConnectionEmptyImage = LocalImage.icon_no_connection()
        noConnectionEmptyTitle = LocalString.noConnectionEmptyTitle().set(style: emptyTitleStyle)
        noConnectionEmptyDescription = LocalString.noConnectionEmptyDescription().set(style: emptyDescriptionStyle)
        
        emptyImage = LocalImage.icon_empty()
        emptyTitle = LocalString.emptyTitle().set(style: emptyTitleStyle)
        emptyDescription = LocalString.emptyDescription().set(style: emptyDescriptionStyle)
    }
    
    /// 2. 注册通知
    func makeNotification() { }
    
    /// 3. 设置导航条
    func makeNavigationBar() { }
    
    /// 4. 设置UI
    func makeUI() {
        automaticallyAdjustsScrollViewInsets = false
    }
    
    /// 5. 设置约束
    func makeConstraints() { }
    
    /// 6. 设置主题
    func makeTheme() {
        view.backgroundColor = QYColor.backgroundColor
    }
    /// 数据加载状态变更
    func loadingStateDidChanged() {}
    deinit {
        logDebug("\(type(of: self)): Deinited")
    }
}

extension QYBaseController: EmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return !isLoading
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        switch QYReachabilityHelper.shared.value {
        case .none:
            return isAllowedNoConnectionScroll
        case .cellular, .wifi:
            return isAllowedEmptyDataScroll
        }
    }
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        emptyDataSetDidTapView?()
    }
}
extension QYBaseController: EmptyDataSetSource {
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        switch QYReachabilityHelper.shared.value {
        case .none:
            emptyView.imageView.image = noConnectionEmptyImage
            emptyView.titleLabel.attributedText = noConnectionEmptyTitle
            emptyView.descriptionLabel.attributedText = noConnectionEmptyDescription
        case .cellular, .wifi:
            emptyView.imageView.image = emptyImage
            emptyView.titleLabel.attributedText = emptyTitle
            emptyView.descriptionLabel.attributedText = emptyDescription
        }
        return emptyView
    }
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -emptyVerticalOffset
    }
    
}
extension Reactive where Base: QYBaseController {
    var isLoading: Binder<Bool> {
        return Binder(base) { target, value in
            target.isLoading = value
        }
    }
    var showError: Binder<Error> {
        return Binder(base) { target, error in
            if let error = error.asHandyJSONMapError {
                QYToast.show(error.errorDescribe)
            } else {
                QYToast.show(kServerException)
            }
        }
    }
    func emptyDataSetDidTapView() -> ControlEvent<()> {
        let source: Observable<Void> = Observable.create { [weak control = self.base] observer in
            MainScheduler.ensureRunningOnMainThread()
            guard let control = control else {
                observer.on(.completed)
                return Disposables.create()
            }
            control.emptyDataSetDidTapView = {
                observer.on(.next(()))
            }
            return Disposables.create()
        }
        .takeUntil(deallocated)

        return ControlEvent(events: source)
    }
}
