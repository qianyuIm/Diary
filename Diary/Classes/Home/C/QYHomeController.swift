//
//  QYHomeController.swift
//  Diary
//
//  Created by cyd on 2021/1/15.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit

class QYHomeController: QYVMTableController<QYHomeViewModel> {
    var dataSource: [String] = ["12","3"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func makeConstant() {
        super.makeConstant()
    }
    override func makeUI() {
        super.makeUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshHeader = QYRefreshFastHeader(refreshingTarget: self, refreshingAction: #selector(refreshHeaderAction))
        
    }
    @objc func refreshHeaderAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.tableView.refreshHeader?.endRefreshing()
        }
    }
}
extension QYHomeController: UITableViewDelegate {
    
}
extension QYHomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ext.dequeueReusableCell(for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    
}
