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
        settings.textColor = QYColor.infoDescribeColor
        settings.starSize = 14
        let view = CosmosView(settings: settings)
        view.rating = 0
        view.isSkeletonable = true
        return view
    }()
    lazy var nameLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        return label
    }()
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(starRatingView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview().offset(44)
            make.width.equalTo(QYInch.value(100))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.equalTo(QYInch.value(100))
        }
        starRatingView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom)
                .offset(4)
            make.left.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard newSuperview != nil else {
            return
        }
        contentView.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview().offset(0)
        }
        UIView.animate(withDuration: 0.3) {
            self.setNeedsLayout()
        }
    }
    func config(score: NSNumber?, name: String?) {
        starRatingView.rating = (score?.doubleValue ?? 0) / 2
        starRatingView.text = (score?.stringValue ?? "0.0")  + " 分"
        nameLabel.text = name
    }
}
