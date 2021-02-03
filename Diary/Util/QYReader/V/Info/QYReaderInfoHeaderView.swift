//
//  QYReaderInfoHeaderView.swift
//  Diary
//
//  Created by cyd on 2021/2/2.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
//import SkeletonView
class QYReaderInfoHeaderView: UIView {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.register(QYReaderInfoHeaderHeaderCell.self, forCellReuseIdentifier: QYReaderInfoHeaderHeaderCell.reuseIdentifier)
//        tableView.register(QYReaderInfoHeaderSameUserCell.self, forCellReuseIdentifier: QYReaderInfoHeaderSameUserCell.reuseIdentifier)
//        tableView.register(QYReaderInfoHeaderSameCategoryCell.self, forCellReuseIdentifier: QYReaderInfoHeaderSameCategoryCell.reuseIdentifier)
        tableView.ext.register(UITableViewCell.self)
        tableView.isScrollEnabled = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
    }()
    var items: [QYReaderInfoCellType]?
//    {
//        didSet {
//            tableView.reloadData()
//        }
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        guard let items = items else { return viewHeight }
        for item in items {
            viewHeight += item.cellHeight
        }
        return viewHeight
    }
}
extension QYReaderInfoHeaderView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        logDebug("选中")
    }
}
extension QYReaderInfoHeaderView: UITableViewDataSource {
//    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
//        if indexPath.row == 0 {
//            return QYReaderInfoHeaderHeaderCell.reuseIdentifier
//        } else if indexPath.row == 1 {
//            return QYReaderInfoHeaderSameUserCell.reuseIdentifier
//        } else {
//            return QYReaderInfoHeaderSameCategoryCell.reuseIdentifier
//        }
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ext.dequeueReusableCell(for: indexPath)
        return cell
//        let item = (items?[indexPath.row])!
//        switch item {
//        case .header(let item):
//            let cell = tableView.dequeueReusableCell(withIdentifier: QYReaderInfoHeaderHeaderCell.reuseIdentifier, for: indexPath) as! QYReaderInfoHeaderHeaderCell
//            cell.item = item
//            return cell
//        default:
//            return UITableViewCell()
//        }
    }
    
    
    
}
