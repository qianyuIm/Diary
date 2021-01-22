//
//  QYCurvedTabbar.swift
//  Diary
//
//  Created by cyd on 2021/1/19.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit

class QYCurvedTabbar: UITabBar {
    var containers = [QYCurvedTabbarItemContainer]()
    var contentViews = [QYCurvedTabbarItemContentView]()
    // 深度
    lazy var calculatePitDepth: CGFloat = {
        let percentage: CGFloat = QYInch.isIphoneX ? 1 : 0.8
        return QYInch.staticTabbarHeight * percentage
    }()
    weak var tabBarController: UITabBarController?
    lazy var selectedItemHolder: QYCurvedSelectedItem = {
        let holder = QYCurvedSelectedItem(size: calculatePitDepth)
        return holder
    }()
    lazy var curvedBackgroundView: QYCurvedTabbarBackgroundView = {
        let view = QYCurvedTabbarBackgroundView()
        return view
    }()
    override var items: [UITabBarItem]? {
        didSet {
            reload()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
        reload()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
}
extension QYCurvedTabbar {
    func select(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == kTabbarInitializeIndex {
            return
        }
        /// 是否顺序 左 --> 右
        let isOrder = (fromIndex - toIndex) < 0 ? true : false
        let step = abs(fromIndex - toIndex)
        if step <= kTabbarSingleStep {
            return
        }
        var middleStep: [Int] = []
        let minimum = min(fromIndex, toIndex) + 1
        let maximum = max(fromIndex, toIndex)
        for step in minimum..<maximum {
            middleStep.append(step)
        }
        // 逆序的话反转
        if !isOrder {
            middleStep.reverse()
        }
        for (index, step) in middleStep.enumerated() {
            let contentView = self.contentViews[step]
            contentView.stepAnimation(step: index + 1)
        }
    }
}
private let kTabbarItemContaineTag: Int = 1000
private let kTabbarInitializeIndex: Int = -1
private let kTabbarSingleStep: Int = 1

extension QYCurvedTabbar {
    func commonInit() {
        self.backgroundColor = .clear
        self.barTintColor = .clear
        self.shadowImage = UIImage()
        self.backgroundImage = UIImage()
    }
    func removeAll() {
        for container in containers {
            container.removeFromSuperview()
        }
        containers.removeAll()
        contentViews.removeAll()
    }
    func reload() {
        removeAll()
        guard let tabBarItems = self.items else {
            logDebug("empty items")
            return
        }
        self.addSubview(selectedItemHolder)
        self.addSubview(curvedBackgroundView)
        for (idx, item) in tabBarItems.enumerated() {
            let container = QYCurvedTabbarItemContainer.init(self, tag: kTabbarItemContaineTag + idx)
            self.addSubview(container)
            self.containers.append(container)
            if let item = item as? QYCurvedTabbarItem {
                container.addSubview(item.contentView)
                self.contentViews.append(item.contentView)
            }
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    @objc func selectAction(_ sender: AnyObject?) {
        guard let container = sender as? QYCurvedTabbarItemContainer else {
            return
        }
        /// 使用它的原因是 首次加载 frame没有计算出来
        DispatchQueue.main.async {
            self.select(itemAtIndex: container.tag - kTabbarItemContaineTag, animated: true)
        }
    }
    func select(itemAtIndex idx: Int, animated: Bool) {
        let newIndex = max(0, idx)
        let currentIndex = (selectedItem != nil) ? (items?.firstIndex(of: selectedItem!) ?? kTabbarInitializeIndex) : kTabbarInitializeIndex
        guard newIndex < items?.count ?? 0,
              let item = self.items?[newIndex],
              item.isEnabled == true else {
            return
        }
        select(from: currentIndex, to: newIndex)
        let step = abs(newIndex - currentIndex)
        if currentIndex != newIndex {
            if currentIndex != kTabbarInitializeIndex && currentIndex < items?.count ?? 0 {
                if let currentItem = items?[currentIndex] as? QYCurvedTabbarItem {
                    currentItem.contentView.deselect(step: step, animated: animated, completion: nil)
                }
            }
            if let item = item as? QYCurvedTabbarItem {
                item.contentView.select(step: step, animated: animated, completion: nil)
                var currentContainer: QYCurvedTabbarItemContainer
                if currentIndex == kTabbarInitializeIndex {
                    currentContainer = self.containers[newIndex]
                } else {
                    currentContainer = self.containers[currentIndex]
                }
                let newContainer = self.containers[newIndex]
                curvedBackgroundView.pitDepth = calculatePitDepth
                curvedBackgroundView.animatePit(from: currentContainer.center.x, to: newContainer.center.x, step: step)
                selectedItemHolder.animateItem(from: selectedItemHolder.center.x, to: newContainer.center.x, item: item, step: step)
            }
        } else if currentIndex == newIndex {
            if let item = item as? QYCurvedTabbarItem {
                item.contentView.reselect(step: step, animated: animated, completion: nil)
            }
            // 涉及导航push但是 tabbar未消失情况
            if let tabBarController = tabBarController {
                var navVC: UINavigationController?
                if let n = tabBarController.selectedViewController as? UINavigationController {
                    navVC = n
                } else if let n = tabBarController.selectedViewController?.navigationController {
                    navVC = n
                }
                if let navVC = navVC {
                    if navVC.viewControllers.contains(tabBarController) {
                        if navVC.viewControllers.count > 1 && navVC.viewControllers.last != tabBarController {
                            navVC.popToViewController(tabBarController, animated: true);
                        }
                    } else {
                        if navVC.viewControllers.count > 1 {
                            navVC.popToRootViewController(animated: animated)
                        }
                    }
                }
            }
        }
        delegate?.tabBar?(self, didSelect: item)
    }
}
//MARK: - layout
extension QYCurvedTabbar {
    /// 手动赋值
    func updateLayout() {
        guard let tabBarItems = self.items else {
            logDebug("empty items")
            return
        }
        let tabBarButtons = subviews.filter { subview -> Bool in
            if let cls = NSClassFromString("UITabBarButton") {
                return subview.isKind(of: cls)
            }
            return false
            } .sorted { (subview1, subview2) -> Bool in
                return subview1.frame.origin.x < subview2.frame.origin.x
        }
        for (idx, item) in tabBarItems.enumerated() {
            if let _ = item as? QYCurvedTabbarItem {
                tabBarButtons[idx].isHidden = true
            } else {
                tabBarButtons[idx].isHidden = false
            }
        }
        for (_, container) in containers.enumerated(){
            container.isHidden = false
        }
        curvedBackgroundView.frame = CGRect(x: 0, y: 0, width: QYInch.screenWidth, height: QYInch.tabbarHeight)
        for (idx, container) in containers.enumerated(){
            if !tabBarButtons[idx].frame.isEmpty {
                container.frame = tabBarButtons[idx].frame
            }
        }
    }
}
