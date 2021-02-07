//
//  QYReaderInfoNavigationTitleView.swift
//  Diary
//
//  Created by cyd on 2021/2/5.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
import Cosmos
import MarqueeLabel
class QYReaderInfoNavigationTitleView: UIView {
    lazy var starRatingView: CosmosView = {
        var settings = CosmosSettings.default
        settings.fillMode = .precise
        settings.textColor = QYColor.textDescribeColor
        settings.starSize = 15
        let view = CosmosView(frame: CGRect(x: 0, y: 23, width: QYInch.value(100), height: 15), settings: settings)
        view.rating = 0
        view.isSkeletonable = true
        view.isUserInteractionEnabled = false
        return view
    }()
    lazy var nameLabel: MarqueeLabel = {
        let label = MarqueeLabel(frame: CGRect(x: 0, y: 0, width: QYInch.value(100), height: 22))
        return label
    }()
    lazy var contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 3, width: QYInch.value(100), height: 38))
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(starRatingView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            UIView.animate(withDuration: 0.3) {
                self.contentView.ext.y = 3
            }
        } else {
            self.contentView.ext.y = 44
        }
    }
    func config(score: NSNumber?, name: String?) {
        starRatingView.rating = (score?.doubleValue ?? 0) / 2
        starRatingView.text = (score?.stringValue ?? "0.0")  + " 分"
        nameLabel.text = name
    }
}
