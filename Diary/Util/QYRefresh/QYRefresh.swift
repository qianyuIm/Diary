//
//  QYRefresh.swift
//  Diary
//
//  Created by cyd on 2021/1/28.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import MJRefresh
extension UIScrollView {
    var refreshHeader: MJRefreshHeader? {
        get { mj_header }
        set { mj_header = newValue }
    }
    var refreshFooter: MJRefreshFooter? {
        get { mj_footer }
        set { mj_footer = newValue }
    }
    var isTotalDataEmpty: Bool {
        mj_totalDataCount() == 0
    }
}
