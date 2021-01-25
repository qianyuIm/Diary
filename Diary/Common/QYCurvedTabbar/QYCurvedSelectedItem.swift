//
//  QYCurvedSelectedItem.swift
//  Diary
//
//  Created by cyd on 2021/1/20.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit

private let kSelectedItemYOffset: CGFloat = -10
private let kSelectedItemYDepth: CGFloat = 60

class QYCurvedSelectedItem: UIView {
    lazy var iconImageView: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    init(size: CGFloat) {
        super.init(frame: CGRect(x: 0, y: kSelectedItemYOffset, width: size, height: size))
        commonInit()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func animateItem(from fromCenterX: CGFloat,
                    to toCenterX: CGFloat,
                    item: QYCurvedTabbarItem,
                    step: Int) {
        let duration = QYCurvedAnimationConfig.singleDuration * Double(step)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration/2) {
            self.iconImageView.image = item.selectedImage
        }
        let midCenterX = fromCenterX + (toCenterX - fromCenterX)/2
        let midCenterY = kSelectedItemYDepth + (frame.height / 2)
        let toCenterY = kSelectedItemYOffset + (frame.height / 2)
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.center = CGPoint(x: midCenterX, y: midCenterY)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.center = CGPoint(x: toCenterX, y: toCenterY)
            }
        }, completion: nil)
    }
}
extension QYCurvedSelectedItem {
    func commonInit() {
        backgroundColor = QYColor.tabbarColor
        layer.cornerRadius = self.frame.width/2
        layer.shadowColor = QYColor.tabbarShadowColor.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
