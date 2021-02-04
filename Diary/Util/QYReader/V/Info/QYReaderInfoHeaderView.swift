//
//  QYReaderInfoHeaderView.swift
//  Diary
//
//  Created by cyd on 2021/2/2.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
import SkeletonView
class QYReaderInfoTableHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "ReaderInfoTableHeaderView"
    lazy var coverImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.ext.addRoundCorners(.allCorners, radius: 5)
        imageV.isSkeletonable = true
        return imageV
    }()
    lazy var introLabel: UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.numberOfLines = 0
        label.font = QYFont.fontRegular(15)
        label.skeletonCornerRadius = 5
        /// 骨架展示3行
        label.text = "\n\n"
        return label
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        isSkeletonable = true
        contentView.addSubview(coverImageView)
        contentView.addSubview(introLabel)
        coverImageView.snp.makeConstraints { (make) in
            make.left.equalTo(QYInch.infoLeft)
            make.top.equalTo(QYInch.readerInfoHeader.top)
            make.width.equalTo(QYInch.readerInfoHeader.coverImageWidth)
            make.height.equalTo(QYInch.readerInfoHeader.coverImageHeight).priority(.high)
        }
        introLabel.snp.makeConstraints { (make) in
            make.left.equalTo(coverImageView)
            make.right.equalTo(-QYInch.infoRight)
            make.top.equalTo(coverImageView.snp.bottom).offset(QYInch.readerInfoHeader.coverImageBottom)
            make.bottom.equalTo(-QYInch.readerInfoHeader.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func config(headerItem: QYReaderInfoModel?) {
        coverImageView.ext.setImage(with: headerItem?.book_img?.ext.url)
        introLabel.text = headerItem?.Desc
    }
    
}
class QYReaderInfoHeaderView: UIView {
    lazy var tableHeaderView: QYReaderInfoTableHeaderView = {
        let view = QYReaderInfoTableHeaderView(frame: CGRect(x: 0, y: 0, width: QYInch.screenWidth, height: QYInch.readerInfoHeader.height))
        return view
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isSkeletonable = true
        
        tableView.register(QYReaderInfoHeaderSameUserCell.self, forCellReuseIdentifier: QYReaderInfoHeaderSameUserCell.reuseIdentifier)
        tableView.register(QYReaderInfoHeaderSameCategoryCell.self, forCellReuseIdentifier: QYReaderInfoHeaderSameCategoryCell.reuseIdentifier)
        tableView.register(QYReaderInfoTableHeaderView.self, forHeaderFooterViewReuseIdentifier: QYReaderInfoTableHeaderView.reuseIdentifier)

        tableView.ext.register(UITableViewCell.self)
        tableView.isScrollEnabled = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 220.0
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = QYInch.readerInfoHeader.height
        logDebug("estimatedSectionHeaderHeight =\(QYInch.readerInfoHeader.height)")
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = 0.0

        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    var sectionItems: [QYReaderInfoCellType]? {
        didSet {
            if let sectionItems = sectionItems {
                let headerItem = sectionItems.first?.headerItem
                tableHeaderView.config(headerItem: headerItem)
                tableView.reloadData()
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        isSkeletonable = true
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func calculateViewHeight() -> CGFloat {
        var viewHeight: CGFloat = 0
        guard let items = sectionItems else { return viewHeight }
        for item in items {
            viewHeight += item.sectionHeight
        }
        return viewHeight
    }
    
}
extension QYReaderInfoHeaderView: SkeletonTableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionItem = sectionItems?[indexPath.section + 1]
        return sectionItem?.cellHeight ?? 0
    }
    func collectionSkeletonView(_ skeletonView: UITableView, identifierForHeaderInSection section: Int) -> ReusableHeaderFooterIdentifier? {
        return QYReaderInfoTableHeaderView.reuseIdentifier
    }
    func collectionSkeletonView(_ skeletonView: UITableView, identifierForFooterInSection section: Int) -> ReusableHeaderFooterIdentifier? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: QYReaderInfoTableHeaderView.reuseIdentifier) as! QYReaderInfoTableHeaderView
        return header
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
extension QYReaderInfoHeaderView: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return QYReaderInfoHeaderSameUserCell.reuseIdentifier
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionItems = sectionItems else { return 1 }
        return ((sectionItems.count - 1) > 1) ? (sectionItems.count - 1) : 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionItems = sectionItems else { return 0 }
        let sectionItem = sectionItems[section + 1]
        return sectionItem.rowsCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionItems = sectionItems else { return UITableViewCell() }
        let sectionItem = sectionItems[indexPath.section + 1]
        switch sectionItem {
        case .sameUser(title: _, categoryCount: _, items: let items):
            let cell = tableView.dequeueReusableCell(withIdentifier: QYReaderInfoHeaderSameUserCell.reuseIdentifier, for: indexPath) as! QYReaderInfoHeaderSameUserCell
            let item = items[indexPath.row]
            cell.item = item
            return cell
        case .sameCategory(title: _, userCount: _, items: let items):
            let cell = tableView.dequeueReusableCell(withIdentifier: QYReaderInfoHeaderSameCategoryCell.reuseIdentifier, for: indexPath) as! QYReaderInfoHeaderSameCategoryCell
            cell.items = items
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    
}
