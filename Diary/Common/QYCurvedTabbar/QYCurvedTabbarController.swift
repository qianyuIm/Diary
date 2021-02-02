//
//  QYCurvedTabbarController.swift
//  Diary
//
//  Created by cyd on 2021/1/19.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
enum QYCurvedTabbarOperation {
    case toRight
    case toLeft
}

class QYCurvedTabbarController: UITabBarController,UITabBarControllerDelegate {
    fileprivate var isIgnoreCycleSelection = false
    override var selectedViewController: UIViewController? {
        willSet {
            guard let newValue = newValue else {
                // if newValue == nil ...
                return
            }
            guard !isIgnoreCycleSelection else {
                isIgnoreCycleSelection = false
                return
            }
            guard let tabBar = self.tabBar as? QYCurvedTabbar,
                  let _ = tabBar.items,
                  let index = viewControllers?.firstIndex(of: newValue) else {
                return
            }
            tabBar.select(itemAtIndex: index, animated: false)
        }
    }
    override var selectedIndex: Int {
        willSet {
            guard !isIgnoreCycleSelection else {
                isIgnoreCycleSelection = false
                return
            }
            guard let tabBar = self.tabBar as? QYCurvedTabbar,
                  let _ = tabBar.items else {
                return
            }
            tabBar.select(itemAtIndex: newValue, animated: false)
        }
    }
    lazy var curvedAnimatedTransitioning: QYCurvedAnimatedTransitioning = {
        let curvedAnimatedTransitioning = QYCurvedAnimatedTransitioning()
        return curvedAnimatedTransitioning
    }()
    /// Customize set tabBar use KVC.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tabBar = { () -> QYCurvedTabbar in
            let tabBar = QYCurvedTabbar()
            tabBar.delegate = self
            tabBar.tabBarController = self
            return tabBar
        }()
        self.setValue(tabBar, forKey: "tabBar")
        self.delegate = self
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item) else {
            return;
        }
        if let selected = viewControllers?[idx] {
            isIgnoreCycleSelection = true
            selectedIndex = idx
            delegate?.tabBarController?(self, didSelect: selected)
        }
    }
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let fromVCIndex = tabBarController.children.firstIndex(of: fromVC)!
        let toVCIndex = tabBarController.children.firstIndex(of: toVC)!
        let operation : QYCurvedTabbarOperation = toVCIndex > fromVCIndex ? .toRight : .toLeft
        let step = abs(fromVCIndex - toVCIndex)
        let duration = QYCurvedAnimationConfig.animationDuration(step)
        curvedAnimatedTransitioning.operation = operation
        curvedAnimatedTransitioning.duration = duration
        return curvedAnimatedTransitioning
    }
}
