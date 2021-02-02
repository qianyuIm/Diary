//
//  QYCurvedAnimatedTransitioning.swift
//  Diary
//
//  Created by cyd on 2021/2/1.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import Foundation
class QYCurvedAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    var operation : QYCurvedTabbarOperation = .toRight
    var duration: TimeInterval = 0.35
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        containerView.backgroundColor = QYColor.backgroundColor
        containerView.addSubview(toView)
        
        let offset = containerView.frame.width
        toView.frame.origin.x = operation == .toRight ? offset : -offset
        toView.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            fromView.alpha = 0
            fromView.frame.origin.x = self.operation == .toRight ? -offset : offset
            toView.alpha = 1
            toView.frame.origin.x = 0
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }
}
