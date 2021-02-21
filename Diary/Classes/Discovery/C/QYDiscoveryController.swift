//
//  QYDiscoveryController.swift
//  Diary
//
//  Created by cyd on 2021/1/19.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import UIKit
import GoogleMobileAds

class QYDiscoveryController: QYBaseController {
    lazy var bannerView: GADBannerView = {
        let view = GADBannerView(adSize: GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(300))
        view.rootViewController = self
        view.adUnitID = QYKey.AdMob.bannerId
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "发现"
        view.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        bannerView.load(GADRequest())

    }

}
