//
//  QYReaderInfoViewModel.swift
//  Diary
//
//  Created by cyd on 2021/2/2.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
enum QYReaderInfoCellType {
    /// 头部信息
    case header(headerItem: QYReaderInfoModel)
    /// 相同作者
    case sameUser(title: String, categoryCount: Int, items: [QYReaderModel])
    /// 相同类型
    case sameCategory(title: String, userCount: Int, items: [QYReaderModel])
    var cellHeight: CGFloat {
        switch self {
        case .header(let headerItem):
            let height = QYInch.readerInfoHeader.height
            guard let intro = headerItem.Desc else {
                return height
            }
            let introHeight = intro.ext.height(QYFont.fontRegular(15), limitWidth: QYInch.screenWidth - QYInch.infoRight - QYInch.infoLeft)
            return height + introHeight
        case .sameUser(title: _, categoryCount: _, items: _):
            let sizeHeight = QYInch.infoHeaderSameUserCollectionCoverImageBottom + QYInch.infoHeaderSameUserCollectionCoverImageTop + QYInch.infoHeaderSameUserCollectionCoverImageHeight
            return sizeHeight
        default:
            return 45
        }
    }
    var sectionHeight: CGFloat {
        switch self {
        case .header(let headerItem):
            let height = QYInch.readerInfoHeader.height
            guard let intro = headerItem.Desc else {
                return height
            }
            let introHeight = intro.ext.height(QYFont.fontRegular(15), limitWidth: QYInch.screenWidth - QYInch.infoRight - QYInch.infoLeft)
            return height + introHeight
        case .sameUser(title: _, categoryCount: _, items: let items):
            var height = QYInch.infoHeaderSameUserTop + QYInch.infoHeaderSameUserBottom
            let sizeHeight = QYInch.infoHeaderSameUserCollectionCoverImageBottom + QYInch.infoHeaderSameUserCollectionCoverImageTop + QYInch.infoHeaderSameUserCollectionCoverImageHeight
            height = height + sizeHeight * CGFloat(items.count)
            return height
        default:
            return 45
        }
    }
    var rowsCount: Int {
        switch self {
        case .sameUser(_, categoryCount: _, items: let items):
            return items.count
        case .sameCategory(title: _, userCount: _, items: _):
            return 1
        default:
            return 0
        }
    }
    var headerItem: QYReaderInfoModel? {
        switch self {
        case .header(headerItem: let item):
            return item
        default:
            return nil
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
            cellTypes.append(.header(headerItem: $0))
//            /// 相同作者
            if (($0.SameUserBooks?.isEmpty) == false) {
                cellTypes.append(.sameUser(title: "作者还写过", categoryCount: $0.SameCategoryBooks?.count ?? 0, items: $0.SameUserBooks!))
            }
//            /// 相同类型
//            if (($0.SameCategoryBooks?.isEmpty) == false) {
//                cellTypes.append(.sameCategory(title: "大家还看过", userCount: $0.SameUserBooks?.count ?? 0, items: $0.SameCategoryBooks!))
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
