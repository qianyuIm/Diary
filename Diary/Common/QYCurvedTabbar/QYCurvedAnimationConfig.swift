//
//  QYCurvedAnimationConfig.swift
//  Diary
//
//  Created by cyd on 2021/1/20.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit

struct QYCurvedAnimationConfig {
    static let singleDuration: CFTimeInterval = 0.35
    static let singleIconTintAnimDuration = singleDuration/3
    
    /// 返回坑宽度
    /// - Parameter maxPitDepth: 坑最大深度
    /// - Returns:
    static func pitWidth(for maxPitDepth: CGFloat) -> CGFloat {
        return maxPitDepth * 2.25
    }
    
    /// 坑的路径
    /// - Parameters:
    ///   - path:
    ///   - startingPointX:
    ///   - top:
    ///   - depth:
    ///   - depthScale:
    static func addPit(toPath path: CGMutablePath,
                       startingPointX: CGFloat,
                       top: CGFloat,
                       depth: CGFloat = 40,
                       depthScale: CGFloat) {
        // 宽度
        let pitWidth = self.pitWidth(for: depth)
        let endPoint = CGPoint(x: startingPointX + pitWidth, y: top)
        let centerRectWidth = depth
        let centerRectHeight = depth * depthScale
        let smallRectsWidth = centerRectWidth / 2
        let smallRectsHeight = centerRectHeight / 2
        let pitCenterBottomPoint = CGPoint(x: startingPointX + (pitWidth / 2), y: centerRectHeight)
        
        let leftRect = CGRect(x: startingPointX, y: top, width: smallRectsWidth, height: smallRectsHeight)
        let centerRect = CGRect(x: leftRect.origin.x + leftRect.width, y: top, width: centerRectWidth, height: centerRectHeight)
        let rightRect = CGRect(x: centerRect.origin.x + centerRect.width, y: top, width: smallRectsWidth, height: smallRectsHeight)
        //Curves' control points calculations.
        //Right Curve's Top Control Point
        let RCTCP = CGPoint(x: endPoint.x - (abs(rightRect.height) * 1.25), y: top)
        //Right Curve's Bottom Control Point
        let RCBCP = CGPoint(x: pitCenterBottomPoint.x + abs(centerRectHeight), y: centerRectHeight)
        //Left Curve's Top Control Point
        let LCTCP = CGPoint(x: startingPointX + (abs(leftRect.height) * 1.25), y: top)
        //Left Curve's Bottom Control Point
        let LCBCP = CGPoint(x: pitCenterBottomPoint.x - abs(centerRectHeight), y: centerRectHeight)
        
        //Addes curves to the given path.
        path.addCurve(to: pitCenterBottomPoint, control1: LCTCP, control2: LCBCP)
        path.addCurve(to: endPoint, control1: RCBCP, control2: RCTCP)
    }
}
