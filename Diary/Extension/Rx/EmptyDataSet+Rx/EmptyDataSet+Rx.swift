//
//  EmptyDataSet+Rx.swift
//  Diary
//
//  Created by cyd on 2021/1/15.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import RxSwift
import RxCocoa
// MARK: - UIScrollView
extension Reactive where Base: UIScrollView {
    /// 刷新空白页面
    var reloadEmptyData: Binder<Void> {
        return Binder(base) { (this, _) in
            this.reloadEmptyDataSet()
        }
    }
}
