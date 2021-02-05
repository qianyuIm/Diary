//
//  QYReaderInfoChaptersView.swift
//  Diary
//
//  Created by cyd on 2021/2/2.
//  Copyright © 2021 qianyuIm. All rights reserved.
//  章节列表

import UIKit
import GKPageSmoothView
class QYReaderInfoChaptersView: UIView {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = QYColor.backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.ext.register(UITableViewCell.self)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
    }()
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
    deinit {
        logDebug("移除了")
    }
}

extension QYReaderInfoChaptersView: GKPageSmoothListViewDelegate {
    func listView() -> UIView {
        return self
    }
    func listScrollView() -> UIScrollView {
        return self.tableView
    }
}
extension QYReaderInfoChaptersView: UITableViewDelegate {
    
}
extension QYReaderInfoChaptersView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ext.dequeueReusableCell(for: indexPath)
        cell.textLabel?.text = "chapters = \(indexPath.row)====="

        return cell
    }
    
    
}
