//
//  QYRefreshFastHeader.swift
//  Diary
//
//  Created by cyd on 2021/1/28.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import MJRefresh

class QYRefreshFastHeader: MJRefreshHeader {
    let headerHeight: CGFloat = 54
    let fastLayerWidth: CGFloat = 28
    let fastLayerHeight: CGFloat = 28
    let color: UIColor = QYColor.color("A5A5A5")
    let arrowColor: UIColor = QYColor.color("D6D6D6")
    let lineWidth: CGFloat = 1.5
    private let endRefreshDelay: CGFloat = 1.5
    lazy var fastLayer: QYRefreshFastLayer = {
        let frame = CGRect(x: (QYInch.screenWidth - fastLayerWidth) / 2, y: (headerHeight - fastLayerHeight) / 2, width: fastLayerWidth, height: fastLayerWidth)
        let layer = QYRefreshFastLayer(frame: frame, color: color, arrowColor: arrowColor, lineWidth: lineWidth)
        return layer
    }()
    override var pullingPercent: CGFloat {
        didSet {
            if pullingPercent >= 1  {
                let transform = CGAffineTransform.identity.rotated(by: CGFloat(Double.pi))
                fastLayer.arrowLayer.setAffineTransform(transform)
            } else {
                let transform = CGAffineTransform.identity.rotated(by: CGFloat(2 * Double.pi))
                fastLayer.arrowLayer.setAffineTransform(transform)
            }
        }
    }
    override var state: MJRefreshState {
        didSet {
            if state == oldValue {
                return
            }
            if state == .refreshing {
                fastLayer.arrowLayer.startAnimation().animationEnd = { [weak self] in
                    self?.fastLayer.circleLayer.startAnimation()
                }
            }
        }
    }
    override func prepare() {
        super.prepare()
        backgroundColor = .clear
        self.mj_h = headerHeight
        layer.addSublayer(fastLayer)
    }
    /// 重写 是为了结束动画后重置 fastLayer 其它位置有瑕疵
    override func endRefreshing() {
        // 展示check
        fastLayer.circleLayer.endAnimation(finish: false)
        self.endRefreshingCompletionBlock = { [weak self] in
            self?.fastLayer.arrowLayer.endAnimation()
            self?.fastLayer.circleLayer.endAnimation(finish: true)
            self?.fastLayer.arrowLayer.setAffineTransform(.identity)
        }
        let delay =  DispatchTimeInterval.milliseconds(Int(endRefreshDelay * 1000))
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            super.endRefreshing()
        }
    }
    override func endRefreshing(completionBlock: @escaping () -> Void) {
        logDebug("不可使用该方法")
    }
    
}
class QYRefreshFastLayer: CALayer {
    var color: UIColor
    var arrowColor: UIColor
    var lineWidth: CGFloat
    lazy var circleLayer: QYRefreshFastCircleLayer = {
        let layer = QYRefreshFastCircleLayer(frame: bounds, color: color, pointColor: arrowColor, lineWidth: lineWidth)
        return layer
    }()
    lazy var arrowLayer: QYRefreshFastArrowLayer = {
        let layer = QYRefreshFastArrowLayer(frame: bounds, color: color, lineWidth: lineWidth)
        return layer
    }()
    init(frame: CGRect,
         color: UIColor,
         arrowColor: UIColor,
         lineWidth: CGFloat) {
        self.arrowColor = arrowColor
        self.color = color
        self.lineWidth = lineWidth
        super.init()
        self.frame = frame
        backgroundColor = UIColor.clear.cgColor
        addSublayer(circleLayer)
        addSublayer(arrowLayer)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class QYRefreshFastArrowLayer: CALayer, CAAnimationDelegate {
    var color: UIColor = .red
    var lineWidth: CGFloat = 1
    var animationEnd: (()->Void)?
    private let animationDuration: Double = 0.2
    lazy var lineLayer: CAShapeLayer = {
        let width = frame.width
        let height = frame.height
        let path = UIBezierPath()
        path.move(to: .init(x: width / 2, y: 0))
        path.addLine(to: .init(x: width/2, y: height/2 + height/3))
        let layer = CAShapeLayer()
        layer.lineWidth   = lineWidth*2
        layer.strokeColor = color.cgColor
        layer.fillColor   = UIColor.clear.cgColor
        layer.lineCap     = .round
        layer.path        = path.cgPath
        layer.strokeStart = 0.5
        return layer
    }()
    lazy var arrowLayer: CAShapeLayer = {
        let width  = frame.size.width
        let height = frame.size.height
        let path = UIBezierPath()
        path.move(to: .init(x: width/2 - height/6, y: height/2 + height/6))
        path.addLine(to: .init(x: width/2, y: height/2 + height/3))
        path.addLine(to: .init(x: width/2 + height/6, y: height/2 + height/6))
        let layer = CAShapeLayer()
        layer.lineWidth   = lineWidth*2
        layer.strokeColor = color.cgColor
        layer.lineCap     = .round
        layer.lineJoin    = .round
        layer.fillColor   = UIColor.clear.cgColor
        layer.path        = path.cgPath
        return layer
    }()
    init(frame: CGRect,
         color: UIColor,
         lineWidth: CGFloat) {
        self.color = color
        self.lineWidth = lineWidth
        super.init()
        self.frame = frame
        backgroundColor = UIColor.clear.cgColor
        addSublayer(lineLayer)
        addSublayer(arrowLayer)
    }
    override init(layer: Any) {
        super.init(layer: layer)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @discardableResult
    func startAnimation() -> Self {
        let start = CABasicAnimation(keyPath: "strokeStart")
        start.duration  = animationDuration
        start.fromValue = 0
        start.toValue   = 0.5
        start.isRemovedOnCompletion = false
        start.fillMode  = .forwards
        start.delegate    = self
        start.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.duration  = animationDuration
        end.fromValue = 1
        end.toValue   = 0.5
        end.isRemovedOnCompletion = false
        end.fillMode  = .forwards
        end.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        arrowLayer.add(start, forKey: "strokeStart")
        arrowLayer.add(end, forKey: "strokeEnd")
        return self
    }
    func endAnimation() {
        arrowLayer.isHidden = false
        lineLayer.isHidden  = false
        arrowLayer.removeAllAnimations()
        lineLayer.removeAllAnimations()
    }
    private func addLineAnimation() {
        let start = CABasicAnimation(keyPath: "strokeStart")
        start.fromValue = 0.5
        start.toValue = 0
        start.isRemovedOnCompletion = false
        start.fillMode  = .forwards
        start.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        start.duration  = animationDuration/2
        lineLayer.add(start, forKey: "strokeStart")
        
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.beginTime = CACurrentMediaTime() + animationDuration/3
        end.duration  = animationDuration/2
        end.fromValue = 1
        end.toValue   = 0.03
        end.isRemovedOnCompletion = false
        end.fillMode  = .forwards
        end.delegate  = self
        end.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        lineLayer.add(end, forKey: "strokeEnd")
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let anim = anim as? CABasicAnimation {
            if anim.keyPath == "strokeStart" {
                arrowLayer.isHidden = true
                addLineAnimation()
            }else {
                lineLayer.isHidden = true
                animationEnd?()
            }
        }
    }
}

class QYRefreshFastCircleLayer: CALayer {
    var color: UIColor
    var pointColor: UIColor
    var lineWidth: CGFloat
    let circle = CAShapeLayer()
    let point  = CAShapeLayer()
    private let pointBack = CALayer()
    private var rotated: CGFloat = 0
    private var rotatedSpeed: CGFloat = 0
    private var speedInterval: CGFloat = 0
    private var isStop: Bool = false
    private(set) var check: QYRefreshFastCheckLayer?
    var codeTimer: DispatchSourceTimer?
    init(frame: CGRect,
         color: UIColor,
         pointColor: UIColor,
         lineWidth: CGFloat) {
        self.pointColor = pointColor
        self.color = color
        self.lineWidth = lineWidth
        pointBack.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        super.init()
        self.frame      = frame
        backgroundColor = UIColor.clear.cgColor
        pointBack.backgroundColor = UIColor.clear.cgColor
        drawCircle()
        addSublayer(pointBack)
        drawPoint()
        addCheckLayer()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Public Methods
    func startAnimation() {
        circle.isHidden = false
        point.isHidden  = false
        codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        codeTimer?.schedule(deadline: .now(), repeating: .milliseconds(42))
        codeTimer?.setEventHandler(handler: { [weak self] in
            guard let `self` = self else {
                return
            }
            self.rotated = self.rotated - self.rotatedSpeed
            if self.isStop {
                let count = Int(self.rotated / CGFloat(Double.pi * 2))
                if (CGFloat(Double.pi * 2 * Double(count)) - self.rotated) >= 1.1 {
                    var transform = CGAffineTransform.identity
                    transform = transform.rotated(by: -1.1)
                    DispatchQueue.main.async {
                        self.pointBack.setAffineTransform(transform)
                        self.point.isHidden  = true
                        self.check?.startAnimation()
                    }
                    self.codeTimer?.cancel()
                    return
                }
            }
            if self.rotatedSpeed < 0.65 {
                if self.speedInterval < 0.02 {
                    self.speedInterval = self.speedInterval + 0.001
                }
                self.rotatedSpeed = self.rotatedSpeed + self.speedInterval
            }
            var transform = CGAffineTransform.identity
            transform = transform.rotated(by: self.rotated)
            DispatchQueue.main.async {
                self.pointBack.setAffineTransform(transform)
            }
        })
        codeTimer?.resume()
        
        addPointAnimation()
    }
    
    func endAnimation(finish: Bool) {
        if finish {
            isStop = false
            rotated       = 0
            rotatedSpeed  = 0
            speedInterval = 0
            pointBack.setAffineTransform(CGAffineTransform.identity)
            circle.isHidden = true
            point.isHidden  = true
            codeTimer?.cancel()
            check?.endAnimation()
        }else {
            DispatchQueue.main.async {
                self.isStop = true
            }
        }
    }
    
    //MARK: Privater Methods
    private func drawCircle() {
        let width  = frame.size.width
        let height = frame.size.height
        let path = UIBezierPath()
        path.addArc(withCenter: .init(x: width/2,
                                      y: height/2),
                    radius: height/2,
                    startAngle: 0,
                    endAngle: CGFloat(Double.pi * 2.0),
                    clockwise: false)
        circle.lineWidth   = lineWidth
        circle.strokeColor = color.cgColor
        circle.fillColor   = UIColor.clear.cgColor
        circle.path        = path.cgPath
        addSublayer(circle)
        circle.isHidden = true
    }

    private func drawPoint() {
        let width  = frame.size.width
        let path = UIBezierPath()
        path.addArc(withCenter: .init(x: width/2, y: width/2),
                    radius: width/2,
                    startAngle: CGFloat(Double.pi * 0.5),
                    endAngle: CGFloat((Double.pi * 0.5) - 0.1),
                    clockwise: false)
        point.lineCap     = CAShapeLayerLineCap.round
        point.lineWidth   = lineWidth*2
        point.fillColor   = UIColor.clear.cgColor
        point.strokeColor = pointColor.cgColor
        point.path        = path.cgPath
        pointBack.addSublayer(point)
        point.isHidden = true
    }
    
    private func addPointAnimation() {
        let width  = frame.size.width
        let path = CABasicAnimation(keyPath: "path")
        path.beginTime = CACurrentMediaTime() + 1
        path.fromValue = point.path
        let toPath = UIBezierPath()
        toPath.addArc(withCenter: .init(x: width/2, y: width/2),
                      radius: width/2,
                      startAngle: CGFloat(Double.pi * 0.5),
                      endAngle: CGFloat((Double.pi * 0.5) - 0.3),
                      clockwise: false)
        path.toValue = toPath.cgPath
        path.timingFunction = CAMediaTimingFunction(name: .easeOut)
        path.duration = 2
        path.isRemovedOnCompletion = false
        path.fillMode = .forwards
        point.add(path, forKey: "path")
    }
    
    private func addCheckLayer() {
        check = QYRefreshFastCheckLayer(frame: CGRect(x: 0,
                                             y: 0,
                                             width: frame.size.width,
                                             height: frame.size.height),
                                        color: pointColor,
                                        lineWidth: lineWidth)
        addSublayer(check!)
    }
}
class QYRefreshFastCheckLayer: CALayer {
    private(set) var check: CAShapeLayer?
    let color: UIColor
    let lineWidth: CGFloat
    //MARK: Public Methods
    func startAnimation() {
        let start = CAKeyframeAnimation(keyPath: "strokeStart")
        start.values = [0, 0.4, 0.3]
        start.isRemovedOnCompletion = false
        start.fillMode = CAMediaTimingFillMode.forwards
        start.duration = 0.5
        start.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let end = CAKeyframeAnimation(keyPath: "strokeEnd")
        end.values = [0, 1, 0.9]

        end.isRemovedOnCompletion = false
        end.fillMode = .forwards
        end.duration = 0.8
        end.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        check?.add(start, forKey: "start")
        check?.add(end, forKey: "end")
    }
    
    func endAnimation() {
        check?.removeAllAnimations()
    }
    
    //MARK: Initial Methods
    init(frame: CGRect,
         color: UIColor,
         lineWidth: CGFloat = 1) {
        self.color      = color
        self.lineWidth  = lineWidth*2
        super.init()
        self.frame      = frame
        backgroundColor = UIColor.clear.cgColor
        drawCheck()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Privater Methods
    private func drawCheck() {
        let width = Double(frame.size.width)
        check = CAShapeLayer()
        check?.lineCap   = CAShapeLayerLineCap.round
        check?.lineJoin  = CAShapeLayerLineJoin.round
        check?.lineWidth = lineWidth
        check?.fillColor = UIColor.clear.cgColor
        check?.strokeColor = color.cgColor
        check?.strokeStart = 0
        check?.strokeEnd = 0
        let path = UIBezierPath()
        let a = sin(0.4) * (width/2)
        let b = cos(0.4) * (width/2)
        path.move(to: CGPoint.init(x: width/2 - b, y: width/2 - a))
        path.addLine(to: CGPoint.init(x: width/2 - width/20 , y: width/2 + width/8))
        path.addLine(to: CGPoint.init(x: width - width/5, y: width/2 - a))
        check?.path = path.cgPath
        addSublayer(check!)
    }
}
