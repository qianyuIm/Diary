//
//  QYCurvedTabbarItemContentView.swift
//  Diary
//
//  Created by cyd on 2021/1/19.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
enum QYTabBarItemContentMode : Int {
    case alwaysOriginal // Always set the original image size
    case alwaysTemplate // Always set the image as a template image size
}
class QYCurvedTabbarItemContentView: UIView, QYCurvedTabBarItemBadgeViewDelegate {
    /// 设置contentView的偏移
    var insets = UIEdgeInsets.zero
    private var imageCenterY: CGFloat = 0
    private var centerYOffest: CGFloat = 40
    /// 是否被选中
    var isSelected = false
    var itemContentMode: QYTabBarItemContentMode = .alwaysOriginal {
       didSet {
           self.updateDisplay()
       }
    }
    var image: UIImage? {
        didSet {
            if !isSelected { self.updateDisplay() }
        }
    }
    
    var selectedImage: UIImage? {
        didSet {
            if isSelected { self.updateDisplay() }
        }
    }
    var badgeValue: String? {
        didSet {
            if let _ = badgeValue {
                self.badgeView.badgeValue = badgeValue
                self.addSubview(badgeView)
                self.updateLayout()
            } else {
                // Remove when nil.
                self.badgeView.remove()
                _badgeView = nil
            }
        }
    }
    var badgeColor: UIColor? {
        didSet {
            if let badgeColor = badgeColor {
                self.badgeView.badgeColor = badgeColor
            } else {
                self.badgeView.badgeColor = QYCurvedTabBarItemBadgeView.defaultBadgeColor
            }
        }
    }
    fileprivate var _badgeView: QYCurvedTabBarItemBadgeView?
    var badgeView: QYCurvedTabBarItemBadgeView  {
        if _badgeView != nil {
            return _badgeView!
        }
        _badgeView = QYCurvedTabBarItemBadgeView(with: self)
        _badgeView?.delegate = self
        return _badgeView!
    }
    
    var badgeOffset: UIOffset = UIOffset.init(horizontal: 6.0, vertical: -22.0) {
        didSet {
            if badgeOffset != oldValue {
                self.updateLayout()
            }
        }
    }
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.zero)
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitTestView = super.hitTest(point, with: event)
        var targetView: UIView? = superview
        if hitTestView == self.badgeView && isSelected {
            targetView = self.badgeView
        }
        /// 默认传递给父视图来控制点击事件
        return targetView
    }
    // badgeView 移除
    func badgeViewDidDrageRemove() {
        badgeValue = nil
        self.ext.viewController?.tabBarItem.badgeValue = nil
    }
    func deselect(step: Int, animated: Bool, completion: (() -> ())?) {
        isSelected = false
        updateDisplay()
        self.deselectAnimation(step: step,animated: animated, completion: completion)
    }
    func select(step: Int, animated: Bool, completion: (() -> ())?) {
        isSelected = true
        updateDisplay()
        selectAnimation(step: step,animated: animated, completion: completion)
    }
    func reselect(step: Int,animated: Bool, completion: (() -> ())?) {
        if isSelected == false {
            select(step: step,animated: animated, completion: completion)
        } else {
            reselectAnimation(animated: animated, completion: completion)
        }
    }
    /// 选中
    func selectAnimation(step: Int, animated: Bool, completion: (() -> ())?) {
        let animatedDuration = QYCurvedAnimationConfig.singleDuration
        let delayDuration = QYCurvedAnimationConfig.singleDuration * Double(step) - animatedDuration
        UIView.animate(withDuration: animatedDuration, delay: delayDuration, options: []) {
            self.imageView.ext.y = self.imageCenterY + self.centerYOffest
            self.imageView.alpha = 0
        } completion: { (_) in
            completion?()
        }
    }
    /// 取消选中
    func deselectAnimation(step: Int,animated: Bool, completion: (() -> ())?) {
        completion?()
        let animatedDuration = QYCurvedAnimationConfig.singleDuration / 2
        let delayDuration = QYCurvedAnimationConfig.singleDuration / 2
        UIView.animate(withDuration: animatedDuration, delay: delayDuration, options: []) {
            self.imageView.alpha = 1
            self.imageView.ext.y = self.imageCenterY
        } completion: { (_) in
        }
    }
    /// 重新选中
    func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    /// 用于  1 2
    func stepAnimation(step: Int) {
        
        let animatedDuration = QYCurvedAnimationConfig.singleDuration * 2
        let delayDuration = QYCurvedAnimationConfig.singleDuration * Double(step + 1) - animatedDuration
        UIView.animateKeyframes(withDuration: animatedDuration, delay: delayDuration, options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.imageView.ext.y = self.imageCenterY + self.centerYOffest
                self.imageView.alpha = 0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.imageView.ext.y = self.imageCenterY
                self.imageView.alpha = 1
            }
        } completion: { (_) in
            
        }

    }
    func updateDisplay() {
        imageView.image = (isSelected ? (selectedImage ?? image) : image)
    }
    func updateLayout() {
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        var imageSize: CGSize = .zero
        if self.itemContentMode == .alwaysOriginal {
            imageView.sizeToFit()
            imageSize = imageView.bounds.size
        } else {
            if #available(iOS 11.0, *) {
                imageSize = UIScreen.main.scale == 3.0 ? CGSize(width: 23, height: 23) : CGSize(width: 20, height: 20)
            } else {
                imageSize = CGSize(width: 23, height: 23)
            }
        }
        imageCenterY = (height - imageSize.height) / 2.0
        imageView.frame = CGRect.init(x: (width - imageSize.width) / 2.0,
                                        y: imageCenterY,
                                        width: imageSize.width,
                                        height: imageSize.height)
        
        if let _ = badgeView.superview {
            let size = badgeView.sizeThatFits(self.frame.size)
            badgeView.frame = CGRect.init(origin: CGPoint.init(x: width / 2.0 + badgeOffset.horizontal, y: height / 2.0 + badgeOffset.vertical), size: size)
            badgeView.setNeedsLayout()
        }
    }
}


