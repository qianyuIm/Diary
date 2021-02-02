//
//  QYReaderInfoHeaderView.swift
//  Diary
//
//  Created by cyd on 2021/2/2.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit

class QYReaderInfoHeaderView: UIView {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.rowHeight = 45
        tableView.delegate = self
        tableView.dataSource = self
        tableView.ext.register(UITableViewCell.self)
        tableView.isScrollEnabled = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func calculateViewHeight() -> CGFloat {
        tableView.reloadData()
        return 45 * 40
    }
}
extension QYReaderInfoHeaderView: UITableViewDelegate {
    
}
extension QYReaderInfoHeaderView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ext.dequeueReusableCell(for: indexPath)
        cell.textLabel?.text = "header=\(indexPath.row)====="
        return cell
    }
    
    
}
