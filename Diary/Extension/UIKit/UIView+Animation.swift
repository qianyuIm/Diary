//
//  UIView+Animation.swift
//  Diary
//
//  Created by cyd on 2021/1/22.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
// MAEK: - Properties
extension UIView {
    
    // 摇摆~ 摇摆~ 震动~ 震动~
    @discardableResult
    func addBoomAnimation() -> Double {
        // 粒子
        if boomCells == nil {
            boomCells = [CALayer]()
            for i in 0..<16 {
                for j in 0..<16 {
                    if scaleSnapshot == nil {
                        scaleSnapshot = self.ext.screenshotImage?.ext.scaled(to: CGSize(width: 34, height: 34))
                    }
                    let pWidth = min(frame.size.width, frame.size.height) / 17
                    let color = scaleSnapshot?.ext.pixelColor(at: CGPoint(x: i * 2, y: j * 2))
                    let shape = CALayer()
                    shape.backgroundColor = color?.cgColor
                    shape.opacity = 0
                    shape.cornerRadius = pWidth / 2
                    shape.frame = CGRect(x: CGFloat(i) * pWidth, y: CGFloat(j) * pWidth, width: pWidth, height: pWidth)
                    layer.superlayer?.addSublayer(shape)
                    boomCells?.append(shape)
                }
            }
        }
        guard let boomCells = boomCells else { return 0 }
        let maximumBoomCellDuration: TimeInterval = 0.8
        layer.opacity = 0
        cellAnimations()
        /// 移除
        DispatchQueue.main.asyncAfter(deadline: .now() + maximumBoomCellDuration) {
            for shape in boomCells {
                shape.removeFromSuperlayer()
            }
        }
        return maximumBoomCellDuration
    }
    /// 脉冲动画
    func addPulsingAnimation(_ pulseSize: CGSize,
                             pulseNum: Int = 2,
                             animationDuration: TimeInterval = 3,
                             delayDuration: TimeInterval = 0,
                             backgroundColor: CGColor) {
        let pulsator = CAReplicatorLayer()
        pulsator.instanceCount = pulseNum
        pulsator.instanceDelay = animationDuration / Double(pulseNum)
        self.layer.insertSublayer(pulsator, below: self.layer)
        pulsator.position = CGPoint(x: self.ext.width / 2, y:  self.ext.height / 2)
        let pulse = CALayer()
        pulse.bounds = CGRect(origin: .zero, size: pulseSize)
        pulse.cornerRadius = pulseSize.height / 2
        pulse.backgroundColor = backgroundColor
        pulse.contentsScale = UIScreen.main.scale
        pulse.opacity = 0
        pulsator.addSublayer(pulse)
        
        let alpha = backgroundColor.alpha
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = 0.4
        scaleAnimation.toValue = 1.0
        scaleAnimation.duration = animationDuration
        scaleAnimation.beginTime = 0
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.values = [alpha, alpha * 0.5, 0.0]
        opacityAnimation.keyTimes = [0.0, 0.3, 1.0]
        opacityAnimation.beginTime = 0
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.duration = animationDuration + delayDuration
        animationGroup.repeatCount = MAXFLOAT
        animationGroup.timingFunction = .init(name: .easeInEaseOut)
        
        pulse.add(animationGroup, forKey: nil)
    }
}
private var kBoomCellsNameKey = "BoomCells"
private var kScaleSnapshotNameKey = "scaleSnapshot"

fileprivate extension UIView {
    var boomCells: [CALayer]? {
        get {
            return objc_getAssociatedObject(self, &kBoomCellsNameKey) as? [CALayer]
        }
        set {
            objc_setAssociatedObject(self, &kBoomCellsNameKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var scaleSnapshot: UIImage? {
        get {
            return objc_getAssociatedObject(self, &kScaleSnapshotNameKey) as? UIImage
        }
        set {
            objc_setAssociatedObject(self, &kScaleSnapshotNameKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func cellAnimations() {
        guard let boomCells = boomCells else { return }
        for shape in boomCells {
            shape.position = center
            // 否则动画完成后会展示到屏幕上
            shape.opacity = 0
            let moveAnimation = CAKeyframeAnimation(keyPath: "position")
            moveAnimation.path = makeRandomPath(shape).cgPath
            moveAnimation.isRemovedOnCompletion = true
            moveAnimation.fillMode = .forwards
            moveAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.240000, 0.590000, 0.506667, 0.026667)
            let moveAnimationDuration = TimeInterval(arc4random()%10) * 0.05 + 0.3
            moveAnimation.duration = moveAnimationDuration
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.toValue = makeScaleValue()
            scaleAnimation.duration = moveAnimationDuration
            scaleAnimation.isRemovedOnCompletion = true
            scaleAnimation.fillMode = .forwards
            
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 1
            opacityAnimation.toValue = 0
            opacityAnimation.duration = moveAnimationDuration
            opacityAnimation.isRemovedOnCompletion = true
            opacityAnimation.fillMode = .forwards
            opacityAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.380000, 0.033333, 0.963333, 0.260000)
            shape.add(scaleAnimation, forKey: "scaleAnimation")
            shape.add(moveAnimation, forKey: "moveAnimation")
            shape.add(opacityAnimation, forKey: "opacityAnimation")
        }
    }
    
    // 随机产生缩放数值
    func makeScaleValue() -> CGFloat{
        return 1 - 0.7 * (CGFloat(arc4random()%51)/50)
    }
    
    // 随机产生粒子路径
    func makeRandomPath(_ aLayer: CALayer) -> UIBezierPath {
        let particlePath = UIBezierPath()
        particlePath.move(to: layer.position)
        let basicLeft = -CGFloat(1.3 * layer.frame.size.width)
        let maxOffset = 2 * abs(basicLeft)
        let randomNumber = arc4random()%101
        let endPointX = basicLeft + maxOffset * (CGFloat(randomNumber)/CGFloat(100)) + aLayer.position.x
        let controlPointOffSetX = (endPointX - aLayer.position.x)/2  + aLayer.position.x
        let controlPointOffSetY = layer.position.y - 0.2 * layer.frame.size.height - CGFloat(arc4random()%UInt32(1.2 * layer.frame.size.height))
        let endPointY = layer.position.y + layer.frame.size.height/2 + CGFloat(arc4random()%UInt32(layer.frame.size.height/2))
        particlePath.addQuadCurve(to: CGPoint(x: endPointX, y: endPointY), controlPoint: CGPoint(x: controlPointOffSetX, y: controlPointOffSetY))
        return particlePath
    }
}
