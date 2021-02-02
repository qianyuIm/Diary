//
//  QYTableController.swift
//  Diary
//
//  Created by cyd on 2021/1/28.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit

class QYTableController: QYBaseController {
    private(set) var style: UITableView.Style = .plain
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: style)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = QYColor.backgroundColor
        if #available(iOS 11.0, *) {
            tableView.estimatedRowHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.ext.register(UITableViewCell.self)
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        return tableView
    }()
    init(style: UITableView.Style) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func makeUI() {
        super.makeUI()
        view.addSubview(tableView)
    }
    override func makeConstraints() {
        super.makeConstraints()
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    override func loadingStateDidChanged() {
        tableView.reloadEmptyDataSet()
    }
}
