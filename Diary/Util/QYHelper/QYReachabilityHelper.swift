//
//  QYReachabilityHelper.swift
//  Diary
//
//  Created by cyd on 2021/1/28.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import Foundation
import RxReachability
import Reachability

class QYReachabilityHelper {
    static let shared = QYReachabilityHelper()
    let reachabilityConnection = BehaviorRelay(value: Reachability.Connection.none)
    var value: Reachability.Connection {
        return reachabilityConnection.value
    }
    private let reachability = Reachability()
    private init() {
        track()
    }
    private func track() {
        reachability?.rx.reachabilityChanged
            .map{ $0.connection }
            .bind(to: reachabilityConnection)
            .disposed(by: disposeBag)
    }
    public func startNotifier() {
        try? reachability?.startNotifier()
    }
}
extension QYReachabilityHelper: HasDisposeBag {}
