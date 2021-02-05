//
//  QYReaderInfoHeaderView.swift
//  Diary
//
//  Created by cyd on 2021/2/2.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
import SkeletonView
import UIImageColors
import Cosmos

class QYReaderInfoTableHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "ReaderInfoTableHeaderView"
    lazy var coverImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.ext.addRoundCorners(.allCorners, radius: 5)
        imageV.isSkeletonable = true
        return imageV
    }()
    lazy var labelContentview: UIView = {
        let view = UIView()
        view.isSkeletonable = true
        return view
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.font = QYFont.fontMedium(15)
        label.textColor = QYColor.infoTitleColor
        label.textAlignment = .left
        return label
    }()
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.font = QYFont.fontRegular(13)
        label.textAlignment = .left
        label.textColor = QYColor.infoDescribeColor
        return label
    }()
    lazy var cNameLabel: UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.font = QYFont.fontRegular(13)
        label.textAlignment = .left
        label.textColor = QYColor.infoDescribeColor
        return label
    }()
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.font = QYFont.fontRegular(13)
        label.textAlignment = .left
        label.textColor = QYColor.infoDescribeColor
        return label
    }()
    lazy var starRatingView: CosmosView = {
        var settings = CosmosSettings.default
        settings.fillMode = .precise
        settings.textColor = QYColor.infoDescribeColor
        let view = CosmosView(settings: settings)
        view.rating = 0
        view.isSkeletonable = true
        return view
    }()
    lazy var introLabel: UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.numberOfLines = 0
        label.font = QYFont.fontRegular(15)
        label.skeletonCornerRadius = 5
        label.textColor = QYColor.infoDescribeColor
        return label
    }()
    var updateColors: ((_ colors: UIImageColors) -> Void)?
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = QYColor.backgroundColor
        isSkeletonable = true
        contentView.addSubview(coverImageView)
        contentView.addSubview(labelContentview)
        labelContentview.addSubview(nameLabel)
        labelContentview.addSubview(authorLabel)
        labelContentview.addSubview(cNameLabel)
        labelContentview.addSubview(statusLabel)
        labelContentview.addSubview(starRatingView)

        contentView.addSubview(introLabel)
        coverImageView.snp.makeConstraints { (make) in
            make.left.equalTo(QYInch.infoLeft)
            make.top.equalTo(QYInch.readerInfoHeader.top)
            make.width.equalTo(QYInch.readerInfoHeader.coverImageWidth)
            make.height.equalTo(QYInch.readerInfoHeader.coverImageHeight).priority(.high)
        }
        // fixbug: .priority(.high)
        labelContentview.snp.makeConstraints { (make) in
            make.left.equalTo(coverImageView.snp.right)
                .offset(QYInch.value(10))
            make.centerY.equalTo(coverImageView)
            make.right.equalTo(-QYInch.infoRight).priority(.high)
        }
        let labelTempHeight = QYInch.value(12)
        nameLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(labelTempHeight)
        }
        authorLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom)
                .offset(QYInch.value(4))
            make.height.greaterThanOrEqualTo(labelTempHeight)
        }
        cNameLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(authorLabel.snp.bottom)
                .offset(QYInch.value(4))
            make.height.greaterThanOrEqualTo(labelTempHeight)
        }
        statusLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(cNameLabel.snp.bottom)
                .offset(QYInch.value(4))
            make.height.greaterThanOrEqualTo(labelTempHeight)
        }
        starRatingView.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(statusLabel.snp.bottom)
                .offset(QYInch.value(4))
            make.height.equalTo(QYInch.value(20))
            make.bottom.equalToSuperview()
        }
        introLabel.snp.makeConstraints { (make) in
            make.left.equalTo(coverImageView)
            make.right.equalTo(-QYInch.infoRight).priority(.high)
            make.height.greaterThanOrEqualTo(QYInch.value(40))
            make.top.equalTo(coverImageView.snp.bottom)
                .offset(QYInch.readerInfoHeader.coverImageBottom)
            make.bottom.equalTo(-QYInch.readerInfoHeader.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func config(headerItem: QYReaderInfoModel?) {
        coverImageView.ext.setImage(with: headerItem?.book_img?.ext.url) { [weak self](image, error, cacheType, imageUrl) in
            if let image = image {
                guard let colors = image.getColors(quality: .low) else { return }
                self?.contentView.backgroundColor = colors.primary
                
                self?.updateColors?(colors)
            }
        }
        nameLabel.text = headerItem?.Name
        authorLabel.text = (headerItem?.Author != nil) ? "作者: \((headerItem?.Author)!)" : ""
        cNameLabel.text = (headerItem?.CName != nil) ? "类型: \((headerItem?.CName)!)" : ""
        statusLabel.text = (headerItem?.BookStatus != nil) ? "状态: \((headerItem?.BookStatus)!)" : ""
        introLabel.text = headerItem?.Desc
        starRatingView.rating = (headerItem?.BookVote?.Score?.doubleValue ?? 0) / 2
        starRatingView.text = (headerItem?.BookVote?.Score?.stringValue ?? "0")  + " 分"
    }
    
}
class QYReaderInfoHeaderView: UIView {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isSkeletonable = true
        tableView.backgroundColor = .clear
        tableView.register(QYReaderInfoHeaderSameUserCell.self, forCellReuseIdentifier: QYReaderInfoHeaderSameUserCell.reuseIdentifier)
        tableView.register(QYReaderInfoHeaderSameCategoryCell.self, forCellReuseIdentifier: QYReaderInfoHeaderSameCategoryCell.reuseIdentifier)
        tableView.register(QYReaderInfoTableHeaderView.self, forHeaderFooterViewReuseIdentifier: QYReaderInfoTableHeaderView.reuseIdentifier)

        tableView.ext.register(UITableViewCell.self)
        tableView.isScrollEnabled = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = QYInch.readerInfoUser.height
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = QYInch.readerInfoHeader.height
        
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = 0.0

        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    var sectionItems: [QYReaderInfoCellType]? {
        didSet {
            tableView.reloadData()
        }
    }
    var updateColors: ((_ colors: UIImageColors) -> Void)?
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 0
        }
        let sectionItem = sectionItems?[section]
        return sectionItem?.cellHeight ?? 0
    }
    func collectionSkeletonView(_ skeletonView: UITableView, identifierForHeaderInSection section: Int) -> ReusableHeaderFooterIdentifier? {
        if section != 0 {
            return nil
        }
        return QYReaderInfoTableHeaderView.reuseIdentifier
    }
    func collectionSkeletonView(_ skeletonView: UITableView, identifierForFooterInSection section: Int) -> ReusableHeaderFooterIdentifier? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            return nil
        }
        let header = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: QYReaderInfoTableHeaderView.reuseIdentifier) as! QYReaderInfoTableHeaderView
        let headerItem = sectionItems?.first?.headerItem
//        header.delegate = self
        header.updateColors = { [weak self] colors in
            self?.updateColors?(colors)
        }
        header.config(headerItem: headerItem)
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
