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
    var item: QYReaderModel? {
        didSet {
            coverImageView.ext.setImage(with: item?.book_img?.ext.url)
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isSkeletonable = true
        contentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(QYInch.infoHeaderSameUserCollectionCoverImageHeight)
            make.height.equalTo(QYInch.infoHeaderSameUserCollectionCoverImageWidth)
            
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
    var item: QYReaderModel? {
        didSet {
            coverImageView.ext.setImage(with: item?.book_img?.ext.url)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        isSkeletonable = true
        contentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { (make) in
            make.top.equalTo(QYInch.infoHeaderSameUserCollectionCoverImageTop)
            make.width.equalTo(QYInch.infoHeaderSameUserCollectionCoverImageHeight)
            make.height.equalTo(QYInch.infoHeaderSameUserCollectionCoverImageWidth)
            make.bottom.equalTo(-QYInch.infoHeaderSameUserCollectionCoverImageBottom)
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
        layout.itemSize = CGSize(width: QYInch.screenWidth, height: QYInch.infoHeaderSameUserCollectionCoverImageTop + QYInch.infoHeaderSameUserCollectionCoverImageHeight + QYInch.infoHeaderSameUserCollectionCoverImageBottom)
        return layout
    }()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isSkeletonable = true
        collectionView.backgroundColor = QYColor.backgroundColor
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
