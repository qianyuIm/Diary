//
//  QYViewModel.swift
//  Diary
//
//  Created by cyd on 2021/1/28.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import Foundation
import RxActivityIndicator

protocol QYViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
protocol QYViewModelable {
    associatedtype Input
    associatedtype Output
    var input: Input { get }
    var output: Output { get }
}

class QYViewModel {
    /// 加载指示器
    let loadingIndicator = ActivityIndicator()
    /// track error
    let error = ErrorTracker()
    required init() {}
    deinit {
        logDebug("\(type(of: self)): Deinited")
    }
}
extension QYViewModel: HasDisposeBag, ReactiveCompatible {}
