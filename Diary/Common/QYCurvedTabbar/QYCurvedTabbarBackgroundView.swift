//
//  QYCurvedTabbarBackgroundView.swift
//  Diary
//
//  Created by cyd on 2021/1/19.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit

class QYCurvedTabbarBackgroundView: UIView {

    fileprivate var borderLayer = CAShapeLayer()
    var pitDepth: CGFloat = 49
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension QYCurvedTabbarBackgroundView {
    func animatePit(from fromCenterX: CGFloat,
                    to toCenterX: CGFloat,
                    step: Int) {
        let distance = toCenterX - fromCenterX
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CAShapeLayer.path))
        animation.timingFunction = .init(name: .easeInEaseOut)
        animation.values = [
            calculateBorderPath(for: fromCenterX, depthScale: 1),
            calculateBorderPath(for: fromCenterX + distance/2, depthScale: 1),
            calculateBorderPath(for: toCenterX, depthScale: 1)
        ]
        animation.keyTimes = [0,0.5,1]
        animation.duration = QYCurvedAnimationConfig.singleDuration * Double(step)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .both
        borderLayer.add(animation, forKey: #keyPath(CAShapeLayer.path))
    }
}
private extension QYCurvedTabbarBackgroundView {
    func commonInit() {
        borderLayer.bounds = bounds
        borderLayer.fillColor = QYColor.tabbarColor.cgColor
        borderLayer.position = CGPoint(x: 0, y: 0)
        borderLayer.anchorPoint = CGPoint(x: 0, y: 0)
        borderLayer.lineJoin = .round
        // 阴影
        borderLayer.shadowColor = QYColor.tabbarShadowColor.cgColor
        borderLayer.shadowOffset = CGSize(width: 0, height: -2)
        borderLayer.shadowRadius = 1
        borderLayer.shadowOpacity = 0.3
        layer.addSublayer(borderLayer)
    }
    func calculateBorderPath(for pitCenterX: CGFloat,
                             depthScale: CGFloat) -> CGMutablePath {
        // 宽度
        let pitWidth = QYCurvedAnimationConfig.pitWidth(for: pitDepth)
        let top: CGFloat = 0
        // left
        let holeStartingPointX = pitCenterX - pitWidth/2
        // 创建孔
        let borderPath = CGMutablePath()
        borderPath.move(to: .zero)
        borderPath.addLine(to: CGPoint(x: holeStartingPointX, y: top))
        // 孔
        QYCurvedAnimationConfig.addPit(toPath: borderPath, startingPointX: holeStartingPointX, top: top, depth: pitDepth, depthScale: depthScale)
        borderPath.addLine(to: CGPoint(x: bounds.width, y: 0))
        borderPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        borderPath.addLine(to: CGPoint(x: 0, y: bounds.height))
        borderPath.addLine(to: CGPoint(x: 0, y: 0))
        
        return borderPath
    }
}
