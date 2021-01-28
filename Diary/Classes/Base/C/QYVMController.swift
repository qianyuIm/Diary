//
//  QYVMController.swift
//  Diary
//
//  Created by cyd on 2021/1/28.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit

class QYVMController<VM: QYViewModel>: QYBaseController {
    /// 不使用该对象时，不会被初始化
    lazy var viewModel: VM = {
        guard let classType: VM.Type = "\(VM.self)".ext.classType() else {
            return VM()
        }
        let viewModel = classType.init()
        return viewModel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindViewModel()
    }
    
    /// 绑定ViewModel
    func bindViewModel() {
        viewModel.loadingIndicator
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        viewModel.error
            .drive(rx.showError)
            .disposed(by: rx.disposeBag)
    }
}
