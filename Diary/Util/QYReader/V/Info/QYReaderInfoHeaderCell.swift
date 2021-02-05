//
//  QYReaderInfoHeaderCell.swift
//  Diary
//
//  Created by cyd on 2021/2/3.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
import SkeletonView

class QYReaderInfoHeaderSameUserCell: UITableViewCell {
    static let reuseIdentifier = "ReaderInfoHeaderSameUserCell"
    lazy var coverImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.isSkeletonable = true
        return imageV
    }()
    lazy var labelContentView: UIView = {
        let view = UIView()
        view.isSkeletonable = true
        return view
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.font = QYFont.fontRegular(13)
        label.textAlignment = .left
        label.textColor = QYColor.infoTitleColor
        label.text = " "
        return label
    }()
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.font = QYFont.fontRegular(11)
        label.textAlignment = .left
        label.textColor = QYColor.infoDescribeColor
        label.text = " "
        return label
    }()
    lazy var lastChapterLabel: UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.font = QYFont.fontRegular(11)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = QYColor.infoDescribeColor
        label.text = " "
        return label
    }()
    
    var item: QYReaderModel? {
        didSet {
            coverImageView.ext.setImage(with: item?.book_img?.ext.url)
            nameLabel.text = item?.Name
            authorLabel.text = item?.Author
            lastChapterLabel.text = item?.LastChapter
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        isSkeletonable = true
        selectionStyle = .none
        contentView.addSubview(coverImageView)
        contentView.addSubview(labelContentView)
        labelContentView.addSubview(nameLabel)
        labelContentView.addSubview(authorLabel)
        labelContentView.addSubview(lastChapterLabel)

        coverImageView.snp.makeConstraints { (make) in
            make.top.equalTo(QYInch.readerInfoUser.top)
            make.left.equalTo(QYInch.infoLeft)
            make.width.equalTo(QYInch.readerInfoUser.coverImageWidth)
            make.bottom.equalTo(-QYInch.readerInfoUser.bottom)
        }
        labelContentView.snp.makeConstraints { (make) in
            make.left.equalTo(coverImageView.snp.right)
                .offset(QYInch.value(4))
            make.centerY.equalTo(coverImageView)
            make.right.equalTo(-QYInch.infoRight)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        authorLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom)
                .offset(QYInch.value(4))
        }
        lastChapterLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(authorLabel.snp.bottom)
                .offset(QYInch.value(4))
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class QYReaderInfoHeaderSameCategoryCollectionCell: UICollectionViewCell {
    lazy var coverImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.isSkeletonable = true
        return imageV
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = QYFont.fontMedium(15)
        label.textColor = QYColor.infoTitleColor
        label.textAlignment = .center
        return label
    }()
    var item: QYReaderModel? {
        didSet {
            coverImageView.ext.setImage(with: item?.book_img?.ext.url)
            nameLabel.text = item?.Name
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        isSkeletonable = true
        contentView.addSubview(coverImageView)
        contentView.addSubview(nameLabel)

        coverImageView.snp.makeConstraints { (make) in
            make.top.equalTo(QYInch.readerInfoCategory.top)
            make.width.equalTo(QYInch.readerInfoCategory.coverImageWidth)
            make.height.equalTo(QYInch.readerInfoCategory.coverImageHeight)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.right.equalTo(coverImageView)
            make.top.equalTo(coverImageView.snp.bottom)
                .offset(QYInch.value(6))
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class QYReaderInfoHeaderSameCategoryCell: UITableViewCell, UICollectionViewDataSource {
    static let reuseIdentifier = "ReaderInfoHeaderSameCategoryCell"
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = QYInch.readerInfoCategory.itemSize
        return layout
    }()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isSkeletonable = true
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.ext.register(QYReaderInfoHeaderSameCategoryCollectionCell.self)
        collectionView.dataSource = self
        return collectionView
    }()
    var items: [QYReaderModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        isSkeletonable = true
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: QYReaderInfoHeaderSameCategoryCollectionCell = collectionView.ext.dequeueReusableCell(for: indexPath)
        if let item = items?[indexPath.row] {
            cell.item = item
        }
        return cell
    }
}
