//
//  QYVMTableController.swift
//  Diary
//
//  Created by cyd on 2021/1/28.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit

class QYVMTableController<RVM: QYRefreshViewModel>: QYTableController {
    /// 不使用该对象时，不会被初始化
    lazy var viewModel: RVM = {
        guard let classType: RVM.Type = "\(RVM.self)".ext.classType() else {
            return RVM()
        }
        let viewModel = classType.init()
        return viewModel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindViewModel()
    }
    func bindViewModel() {
        viewModel.loadingIndicator
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        viewModel.error
            .drive(rx.showError)
            .disposed(by: rx.disposeBag)
        bindEmptyDataSetViewTap()
        bindRefreshHeader()
        bindRefreshFooter()
        viewModel.bindState()
    }
    // MARK: - 绑定没有网络时的点击事件
    func bindEmptyDataSetViewTap() {
        rx.emptyDataSetDidTapView()
            .subscribe(viewModel.refreshInput.emptyDataSetViewTap)
            .disposed(by: rx.disposeBag)
    }
    // MARK: - 绑定头部刷新回调和头部刷新状态
    func bindRefreshHeader() {
        guard let refreshHeader = tableView.refreshHeader else {
            return
        }
        // 将刷新事件传递给 refreshVM
        refreshHeader.rx.refreshing
            .bind(to: viewModel.refreshInput.beginHeaderRefresh)
            .disposed(by: rx.disposeBag)
        // 成功时的头部状态
        viewModel.refreshOutput
            .headerRefreshState
            .drive(refreshHeader.rx.isRefreshing)
            .disposed(by: rx.disposeBag)
        // 失败时的头部状态
        viewModel.refreshError
            .mapTo(false)
            .drive(refreshHeader.rx.isRefreshing)
            .disposed(by: rx.disposeBag)
    }
    func bindRefreshFooter() {
        guard let refreshFooter = tableView.refreshFooter else {
            return
        }
        // 将刷新事件传递给 refreshVM
        refreshFooter.rx.refreshing
            .bind(to: viewModel.refreshInput.beginFooterRefresh)
            .disposed(by: rx.disposeBag)

        // 成功时的尾部状态
        viewModel.refreshOutput
            .footerRefreshState
            .drive(refreshFooter.rx.refreshFooterState)
            .disposed(by: rx.disposeBag)
        // 失败时的尾部状态
        viewModel.refreshError
            .map { [weak self] _ -> RxMJRefreshFooterState in
                guard let self = self else { return .hidden }
                return self.tableView.isTotalDataEmpty ? .hidden : .default
            }.drive(refreshFooter.rx.refreshFooterState)
            .disposed(by: rx.disposeBag)
    }
}
