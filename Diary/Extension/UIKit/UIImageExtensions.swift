//
//  UIImageExtensions.swift
//  Tool
//
//  Created by cyd on 2020/12/25.
//

import UIKit
// MARK: - Properties
extension QianyuWrapper where Base: UIImage {
    /// 字节大小 单位 b
    var bytesSize: Int {
        return base.jpegData(compressionQuality: 1)?.count ?? 0
    }
    /// 字节大小 单位 kb
    var kilobytesSize: Int {
        return (base.jpegData(compressionQuality: 1)?.count ?? 0) / 1024
    }
    /// UIImage with .alwaysOriginal rendering mode.
    var original: UIImage {
        return base.withRenderingMode(.alwaysOriginal)
    }
    /// SwifterSwift: UIImage with .alwaysTemplate rendering mode.
    var template: UIImage {
        return base.withRenderingMode(.alwaysTemplate)
    }
}
// MARK: - Methods
extension QianyuWrapper where Base: UIImage {
    static func image(_ color: UIColor,
                      size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    /// 缩放
    /// - Parameter size:
    /// - Returns:
    func scaled(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        base.draw(in: CGRect(origin: .zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage
    }
    
    /// 返回当前点的颜色
    /// - Parameter point: point
    /// - Returns:
    func pixelColor(at point: CGPoint) -> UIColor? {
        guard CGRect(origin: CGPoint(x: 0, y: 0), size: base.size).contains(point) else
        {
            return nil
        }

        let pointX = trunc(point.x)
        let pointY = trunc(point.y)

        let width = base.size.width
        let height = base.size.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var pixelData: [UInt8] = [0, 0, 0, 0]

        pixelData.withUnsafeMutableBytes { pointer in
            if let context = CGContext(data: pointer.baseAddress, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue),
               let cgImage = base.cgImage {
                    context.setBlendMode(.copy)
                    context.translateBy(x: -pointX, y: pointY - height)
                    context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        }
        let red = CGFloat(pixelData[0]) / CGFloat(255.0)
        let green = CGFloat(pixelData[1]) / CGFloat(255.0)
        let blue = CGFloat(pixelData[2]) / CGFloat(255.0)
        let alpha = CGFloat(pixelData[3]) / CGFloat(255.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
