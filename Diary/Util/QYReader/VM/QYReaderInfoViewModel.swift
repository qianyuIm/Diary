//
//  QYReaderInfoViewModel.swift
//  Diary
//
//  Created by cyd on 2021/2/2.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
enum QYReaderInfoCellType {
    /// 头部
    case header(QYReaderInfoModel)
    /// 简介
    case intro(QYReaderInfoModel)
    /// 相同作者
    case sameUser(title: String, items: [QYReaderModel])
    /// 相同类型
    case sameCategory(title: String, items: [QYReaderModel])
    var cellHeight: CGFloat {
        switch self {
        case .header:
            return QYInch.infoHeaderCoverImageHeight + QYInch.infoHeaderCoverImageTop + QYInch.infoHeaderCoverImageBottom
        default:
            return 45
        }
    }
}
class QYReaderInfoViewModel: QYRefreshViewModel {
    struct Input {
        /// 小说id
        let bookId: String
    }
    struct Output {
        let items: Driver<[QYReaderInfoCellType]>
    }
    
}
extension QYReaderInfoViewModel: QYViewModelType {
    func transform(input: Input) -> Output {
        let bookInfo = requestBookInfo(bookId: input.bookId)
        let elements = BehaviorRelay<[QYReaderInfoCellType]>(value: [])
        // 数据源
        bookInfo.drive(onNext: {
            var cellTypes: [QYReaderInfoCellType] = []
            /// 头部
            cellTypes.append(.header($0))
            /// 简介
//            cellTypes.append(.intro($0))
//            /// 相同作者
//            if (($0.SameUserBooks?.isEmpty) == false) {
//                cellTypes.append(.sameUser(title: "作者还写过", items: $0.SameUserBooks!))
//            }
//            /// 相同类型
//            if (($0.SameCategoryBooks?.isEmpty) == false) {
//                cellTypes.append(.sameCategory(title: "大家还看过", items: $0.SameCategoryBooks!))
//            }
            elements.accept(cellTypes)
        }).disposed(by: rx.disposeBag)
        return Output(items: elements.asDriver())
    }
}
extension QYReaderInfoViewModel {
    func requestBookInfo(bookId: String) -> Driver<QYReaderInfoModel> {
        return QYReaderApi.readerInfo(bookId)
            .request()
            .mapReaderObject(QYReaderBaseModel<QYReaderInfoModel>.self)
            .compactMap { $0.data }
            .trackActivity(loadingIndicator)
            .trackError(error)
            .asDriverOnErrorJustComplete()
    }
}
