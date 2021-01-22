//
//  QYCurvedTabBarItemBadgeView.swift
//  Diary
//
//  Created by cyd on 2021/1/21.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
protocol QYCurvedTabBarItemBadgeViewDelegate: NSObjectProtocol {
    func badgeViewDidDrageRemove()
}
class QYCurvedTabBarItemBadgeView: UIView {
    /// 默认颜色
    static var defaultBadgeColor = UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0)
    weak var delegate: QYCurvedTabBarItemBadgeViewDelegate?
    /// 气泡粘性系数，越大可以拉得越长
    var viscosity: CGFloat = 20
    var badgeColor: UIColor = defaultBadgeColor {
        didSet {
            frontView.backgroundColor = badgeColor
            backView.backgroundColor = badgeColor
        }
    }
    private var fillColorForCute: UIColor = .clear
    var badgeValue: String? {
        didSet {
            badgeLabel.text = badgeValue
        }
    }
    lazy var badgeLabel: UILabel = {
        let badgeLabel = UILabel.init(frame: CGRect.zero)
        badgeLabel.backgroundColor = .clear
        badgeLabel.textColor = .white
        badgeLabel.font = UIFont.systemFont(ofSize: 13.0)
        badgeLabel.textAlignment = .center
        return badgeLabel
    }()
    lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    lazy var frontView: UIView = {
        let view = UIView()
        return view
    }()
    lazy var backView: UIView = {
        let view = UIView()
        return view
    }()
    /// 拖拽手势
    lazy var dragGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleDragGesture(_:)))
        return pan
    }()
    fileprivate var r1: CGFloat = 0
    fileprivate var r2: CGFloat = 0
    fileprivate var x1: CGFloat = 0
    fileprivate var x2: CGFloat = 0
    fileprivate var y1: CGFloat = 0
    fileprivate var y2: CGFloat = 0
    fileprivate var centerDistance: CGFloat = 0
    fileprivate var cosDigree: CGFloat = 0
    fileprivate var sinDigree: CGFloat = 0
    fileprivate var initialPoint: CGPoint = .zero
    fileprivate var pointA: CGPoint = .zero
    fileprivate var pointB: CGPoint = .zero
    fileprivate var pointC: CGPoint = .zero
    fileprivate var pointD: CGPoint = .zero
    fileprivate var pointO: CGPoint = .zero
    fileprivate var pointP: CGPoint = .zero
    fileprivate var oldBackViewFrame: CGRect = .zero
    fileprivate var oldBackViewCenter: CGPoint = .zero
    fileprivate var containerView: UIView
    
    init(with containerView: UIView) {
        self.containerView = containerView
        super.init(frame: .zero)
        commonInit()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func remove() {
        backView.removeFromSuperview()
        frontView.removeFromSuperview()
        shapeLayer.removeFromSuperlayer()
        self.removeFromSuperview()
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let _ = badgeValue else {
            return CGSize.init(width: 18.0, height: 18.0)
        }
        let textSize = badgeLabel.sizeThatFits(CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        return CGSize.init(width: max(18.0, textSize.width + 10.0), height: max(18.0, textSize.width + 10.0))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let _ = badgeValue else {
            badgeLabel.isHidden = true
            frontView.isHidden = true
            backView.isHidden = true
            return
        }
        setup()
    }
    @objc func handleDragGesture(_ dragGesture: UIPanGestureRecognizer) {
        let dragPoint = dragGesture.location(in: self.containerView)
        let dragState = dragGesture.state
        if dragState == .began {
            backView.isHidden = false
            fillColorForCute = self.badgeColor
            self.removeGameCenterAniamtion()
        } else if dragState == .changed {
            frontView.center = dragPoint
            if r1 <= 6 {
                fillColorForCute = .clear
                backView.isHidden = true
                shapeLayer.removeFromSuperlayer()
            }
            dragAction()
        } else if dragState == .ended ||
                    dragState == .cancelled ||
                    dragState == .failed {
            if r1 <= 6 {
                // 消失
                let duration = self.frontView.boomAnimation()
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    self.delegate?.badgeViewDidDrageRemove()
                }
            } else {
                // 恢复
                backView.isHidden = true
                fillColorForCute = .clear
                shapeLayer.removeFromSuperlayer()
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseInOut) {
                    self.frontView.center = self.oldBackViewCenter
                } completion: { (isFinished) in
                    if isFinished {
                        self.addGameCenterAniamtion()
                    }
                }

            }
        }
    }
    func dragAction() {
        x1 = backView.center.x
        y1 = backView.center.y
        x2 = frontView.center.x
        y2 = frontView.center.y
        
        centerDistance = sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
        if centerDistance == 0 {
            cosDigree = 1
            sinDigree = 0
        } else {
            cosDigree = (y2 - y1) / centerDistance
            sinDigree = (x2 - x1) / centerDistance
        }
        
        r1 = oldBackViewFrame.size.width / 2 - centerDistance / viscosity
        pointA = CGPoint(x: x1 - r1 * cosDigree, y: y1 + r1 * sinDigree) // A
        pointB = CGPoint(x: x1 + r1 * cosDigree, y: y1 - r1 * sinDigree) // B
        pointD = CGPoint(x: x2 - r2 * cosDigree, y: y2 + r2 * sinDigree) // D
        pointC = CGPoint(x: x2 + r2 * cosDigree, y: y2 - r2 * sinDigree) // C
        pointO = CGPoint(x: pointA.x + (centerDistance / 2) * sinDigree,
                         y: pointA.y + (centerDistance / 2) * cosDigree)
        pointP = CGPoint(x: pointB.x + (centerDistance / 2) * sinDigree,
                         y: pointB.y + (centerDistance / 2) * cosDigree)
        draw()
    }
    func draw() {
        backView.center = oldBackViewCenter
        backView.bounds = CGRect(x: 0, y: 0, width: r1 * 2, height: r1 * 2)
        backView.layer.cornerRadius = r1
        let cutePath = UIBezierPath()
        cutePath.move(to: pointA)
        cutePath.addQuadCurve(to: pointD, controlPoint: pointO)
        cutePath.addLine(to: pointC)
        cutePath.addQuadCurve(to: pointB, controlPoint: pointP)
        cutePath.move(to: pointA)
        
        if !backView.isHidden {
            shapeLayer.path = cutePath.cgPath
            shapeLayer.fillColor = fillColorForCute.cgColor
            self.containerView.layer.insertSublayer(shapeLayer, below: frontView.layer)
        }
        
    }
}

extension QYCurvedTabBarItemBadgeView {
    func commonInit() {
        self.backgroundColor = .clear
        frontView.backgroundColor = badgeColor
        backView.backgroundColor = badgeColor
        frontView.insertSubview(badgeLabel, at: 0)
        containerView.addSubview(backView)
        containerView.addSubview(frontView)
        backView.isHidden = true
        self.addGestureRecognizer(dragGesture)
    }
    func setup() {
        backView.frame = frame
        frontView.frame = frame
        badgeLabel.sizeToFit()
        badgeLabel.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        r2 = frontView.bounds.width / 2
        frontView.layer.cornerRadius = r2
        
        r1 = backView.bounds.width / 2
        backView.layer.cornerRadius = r1
        
        x1 = backView.center.x
        y1 = backView.center.y
        x2 = frontView.center.x
        y2 = frontView.center.y
        
        pointA = CGPoint(x: x1 - x2, y: y1)
        pointB = CGPoint(x: x1+r1, y: y1);  // B
        pointD = CGPoint(x: x2-r2, y: y2);  // D
        pointC = CGPoint(x: x2+r2, y: y2);  // C
        pointO = CGPoint(x: x1-r1, y: y1);   // O
        pointP = CGPoint(x: x2+r2, y: y2);  // P
        
        oldBackViewFrame = backView.frame;
        oldBackViewCenter = backView.center;
        addGameCenterAniamtion()
    }
    func addGameCenterAniamtion() {
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.calculationMode = .paced
        positionAnimation.fillMode = .forwards
        positionAnimation.isRemovedOnCompletion = false
        positionAnimation.repeatCount = Float.greatestFiniteMagnitude
        positionAnimation.timingFunction = .init(name: .linear)
        positionAnimation.duration = 5.0
        
        let curvedPath = CGMutablePath()
        let circleContainer = frontView.frame.insetBy(dx: frontView.frame.width / 2 - 2, dy: frontView.frame.width / 2 - 2)
        curvedPath.addEllipse(in: circleContainer)
        positionAnimation.path = curvedPath
        frontView.layer.add(positionAnimation, forKey: "circleAnimation")
        
        let scaleXAnimation = CAKeyframeAnimation(keyPath: "transform.scale.x")
        scaleXAnimation.duration = 1
        scaleXAnimation.values = [1.0, 1.0, 1.0]
        scaleXAnimation.keyTimes = [0.0, 0.5, 1.0]
        scaleXAnimation.repeatCount = Float.greatestFiniteMagnitude
        scaleXAnimation.autoreverses = true
        scaleXAnimation.timingFunction = .init(name: .easeInEaseOut)
        frontView.layer.add(scaleXAnimation, forKey: "scaleXAnimation")
        
        let scaleYAnimation = CAKeyframeAnimation(keyPath: "transform.scale.y")
        scaleYAnimation.duration = 1.5
        scaleYAnimation.values = [1.0, 1.0, 1.0]
        scaleYAnimation.keyTimes = [0.0, 0.5, 1.0]
        scaleYAnimation.repeatCount = Float.greatestFiniteMagnitude
        scaleYAnimation.autoreverses = true
        scaleYAnimation.timingFunction = .init(name: .easeInEaseOut)
        frontView.layer.add(scaleYAnimation, forKey: "scaleYAnimation")
        
    }
    func removeGameCenterAniamtion() {
        frontView.layer.removeAllAnimations()
    }
}

 
