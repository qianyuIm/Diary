//
//  QYReaderInfoHeaderCell.swift
//  Diary
//
//  Created by cyd on 2021/2/3.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
class QYReaderInfoHeaderHeaderCell: UITableViewCell {
    static let reuseIdentifier = "ReaderInfoHeaderHeaderCell"
    lazy var coverImageView: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    lazy var bookName: UILabel = {
        let label = UILabel()
        return label
    }()
    var item: QYReaderInfoModel? {
        didSet {
            coverImageView.ext.setImage(with: item?.book_img?.ext.url)
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { (make) in
            make.top.equalTo(QYInch.infoHeaderCoverImageTop)
            make.left.equalTo(QYInch.infoLeftRight)
            make.width.equalTo(QYInch.infoHeaderCoverImageWidth)
            make.height.equalTo(QYInch.infoHeaderCoverImageHeight)
            make.bottom.equalTo(-QYInch.infoHeaderCoverImageBottom)
        }
    }
    func cellHeight() -> CGFloat {
        return 0
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class QYReaderInfoHeaderIntroCell: UITableViewCell {
    static let reuseIdentifier = "ReaderInfoHeaderIntroCell"
    lazy var introLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(introLabel)
        introLabel.snp.makeConstraints { (make) in
            make.left.equalTo(QYInch.infoLeftRight)
            make.right.equalTo(-QYInch.infoLeftRight)
            make.top.equalTo(QYInch.infoHeaderIntroTop)
            make.bottom.equalTo(-QYInch.infoHeaderIntroBottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class QYReaderInfoHeaderSameUserCell: UITableViewCell {
    static let reuseIdentifier = "ReaderInfoHeaderSameUserCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class QYReaderInfoHeaderSameCategoryCell: UITableViewCell {
    static let reuseIdentifier = "ReaderInfoHeaderSameCategoryCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
