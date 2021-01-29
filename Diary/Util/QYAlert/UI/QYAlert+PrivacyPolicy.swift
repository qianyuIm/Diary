//
//  QYAlert+PrivacyPolicy.swift
//  Diary
//
//  Created by cyd on 2021/1/28.
//  Copyright © 2021 qianyuIm. All rights reserved.
//

import Foundation
import SwiftEntryKit
import DefaultsKit
import AttributedString

private extension DefaultsKey {
    /// 最新隐私协议
    static let kLastPrivacyPolicyKey = Key<PrivacyPolicyItem>("qy_lastPrivacyPolicyKey")
}
private struct PrivacyPolicyItem: Codable {
    var buildVersion: String
    var isShow: Bool = false
}
extension QYAlert {
    /// 隐私协议
    class func alertPrivacyPolicy() {
        let defaults = Defaults()
        let hasItem = defaults.has(.kLastPrivacyPolicyKey)
        if hasItem {
            let privacyPolicyItem = defaults.get(for: .kLastPrivacyPolicyKey)
            let appVersion = QYConfigs.version
            // 版本升级
            if appVersion != privacyPolicyItem?.buildVersion {
                // 展示
                showPrivacyPolicy()
            }
        } else {
            // 展示
            showPrivacyPolicy()
        }
    }
    
}
private extension QYAlert {
    class func showPrivacyPolicy() {
        let privacyPolicyController = QYPrivacyPolicyController()
        let na = QYNavigationController(rootViewController: privacyPolicyController)
        SwiftEntryKit.display(entry: na, using: privacyPolicyAttributes())
    }
    class func privacyPolicyAttributes() -> EKAttributes {
        var attributes: EKAttributes = .centerFloat
        attributes.displayMode = .dark
        attributes.windowLevel = .alerts
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .absorbTouches
        attributes.entryInteraction = .forward
        attributes.scroll = .disabled
        attributes.positionConstraints.size = .init(
            width: .fill,
            height: .fill
        )
        attributes.entranceAnimation = .init(
            scale: .init(
                from: 0.7,
                to: 1,
                duration: 0.4,
                spring: .init(damping: 0.5, initialVelocity: 1)
            )
        )
        attributes.exitAnimation = .init(
            scale: .init(
                from: 1,
                to: 0.4,
                duration: 0.4,
                spring: .init(damping: 1, initialVelocity: 0)
            ),
            fade: .init(
                from: 1,
                to: 0,
                duration: 0.2
            )
        )
        return attributes
    }
}
private class QYPrivacyPolicyController: UIViewController {
    lazy var privacyPolicyView: QYPrivacyPolicyView = {
        let view = QYPrivacyPolicyView()
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hbd_barHidden = true
        view.addSubview(privacyPolicyView)
        privacyPolicyView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
private class QYPrivacyPolicyView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "服务协议与隐私政策"
        label.textAlignment = .center
        label.textColor = QYColor.privacyPolicyTitleColor
        return label
    }()
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isSelectable = false
        textView.isEditable = false
        let titleFont = QYFont.fontRegular(14)
        let linkFont = QYFont.fontRegular(14)
        let describeFont = QYFont.fontRegular(13)
        func linkAction(_ result: AttributedString.Action.Result) {
            switch result.content {
            case .string(let value):
                logDebug(value.string)
            default:
                break
            }
        }
        textView.attributed.text = """
        \("欢迎使用\(QYConfigs.appName)！\(QYConfigs.appName)的产品及服务由北京XXX公司为您提供。在您使用\(QYConfigs.appName)之前，我们想向您说明\(QYConfigs.appName)的服务条款与隐私政策内容，请您仔细阅读并作出适当的选择：",.font(describeFont), .foreground(QYColor.privacyPolicyDescribeColor))\n\n
        \("1. 《\(QYConfigs.appName)用户协议》的主要内容包括：", .font(titleFont), .foreground(QYColor.privacyPolicyTitleColor))\n
        \("协议适用范围、服务内容及形式、软件使用及许可、终端责任安全、用户权利与义务、用户行为规范、知识产权声明、用户信息保护等。",.font(describeFont),.foreground(QYColor.privacyPolicyDescribeColor))\n
        \("2. 关于《\(QYConfigs.appName)隐私政策》，我们特别向您说明：",.font(titleFont), .foreground(QYColor.privacyPolicyTitleColor))\n
        \("（1）根据合法、正当、必要的原则，我们会收集实现产品功能所必要的信息，包括：您在注册账户时所填写的信息（昵称、手机号码等）；您的网络日志及设备信息设备型号；当您选择使用部分服务时，我们将在征求您的同意后获取相关提供服务所需的信息，如当您使用与位置有关的服务时，我们可能会获取您设备所在的位置信息。", .font(describeFont),.foreground(QYColor.privacyPolicyDescribeColor))\n
        \("（2）即刻运营方内有严格的数据保护及管理措施，我们会采取安全保障措施努力保护您的个人信息不丢失，不被未经授权地访问、使用、披露、修改或损坏以及其它形式的非法处理。",.font(describeFont),.foreground(QYColor.privacyPolicyDescribeColor))\n
        \("（3）您可以在应用内或您的设备中查询、更正、删除您的信息并对相关授权进行管理。 如您对本公告及相关协议的相关内容有任何意见、建议或疑问，您可以通过",.font(describeFont),.foreground(QYColor.privacyPolicyDescribeColor)) \("1040583846@qq.com",.font(linkFont),.foreground(QYColor.privacyPolicyLinkColor),.action(linkAction)) \("联系我们。如您同意以上内容，您可点击“同意”开始使用。",.font(describeFont),.foreground(QYColor.privacyPolicyDescribeColor))
        """
        return textView
    }()
    lazy var policyLabel: UILabel = {
        let label = UILabel()
        let font = QYFont.fontRegular(14)
        label.attributed.text = """
        \("点击查看",.foreground(QYColor.privacyPolicyDescribeColor),.font(font))\("《用户协议》",.foreground(QYColor.privacyPolicyLinkColor),.font(font),.action(userPolicyAction)),\("《隐私协议》。",.font(font),.foreground(QYColor.privacyPolicyLinkColor),.action(privacyPolicyAction))
        """
        return label
    }()
    lazy var acceptButton: QYBorderButton = {
        let sender = QYBorderButton()
        sender.cornerRadius = 4
        sender.setTitle("同意", for: .normal)
        sender.backgroundColor = QYColor.privacyPolicySenderBackgroundColor
        sender.setTitleColor(QYColor.privacyPolicySenderTitleColor, for: .normal)
        sender.addTarget(self, action: #selector(acceptButtonDidClick), for: .touchUpInside)
        return sender
    }()
    lazy var noAcceptButton: QYBorderButton = {
        let sender = QYBorderButton()
        sender.borderWidth = 1
        sender.borderColor = QYColor.privacyPolicySenderBorderColor
        sender.cornerRadius = 4
        sender.setTitle("不同意并退出", for: .normal)
        sender.setTitleColor(QYColor.privacyPolicySenderTitleColor, for: .normal)
        sender.titleLabel?.textColor = QYColor.privacyPolicySenderTitleColor
        sender.addTarget(self, action: #selector(noAcceptButtonDidClick), for: .touchUpInside)
        return sender
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = QYColor.privacyPolicyBackgroundColor
        /// 高亮状态
        Array<AttributedString.Action.Highlight>.defalut = [.foreground(QYColor.privacyPolicyLinkHighlightColor)]
        addSubview(titleLabel)
        addSubview(textView)
        addSubview(policyLabel)
        addSubview(acceptButton)
        addSubview(noAcceptButton)

        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(QYInch.value(20))
        }
        let margin = QYInch.value(8)
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(margin)
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.height.equalTo(QYInch.value(260))
        }
        policyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom)
                .offset(margin)
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
        }
        noAcceptButton.snp.makeConstraints { (make) in
            make.top.equalTo(policyLabel.snp.bottom)
                .offset(margin)
            make.left.equalTo(margin)
            make.height.equalTo(QYInch.value(40))
            make.width.equalTo(QYInch.value(120))
            make.bottom.equalTo(-margin)
        }
        acceptButton.snp.makeConstraints { (make) in
            make.centerY.height.width.equalTo(noAcceptButton)
            make.right.equalTo(-margin)
        }
        self.ext.addRoundCorners(.allCorners, radius: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func acceptButtonDidClick() {
        let privacyPolicyItem = PrivacyPolicyItem(buildVersion: QYConfigs.version, isShow: true)
        Defaults().set(privacyPolicyItem, for: .kLastPrivacyPolicyKey)
        QYAlert.dismiss()
    }
    @objc func noAcceptButtonDidClick() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
    }
    func userPolicyAction(_ result: AttributedString.Action.Result) {
        logDebug("跳转用户协议")
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        self.ext.navigationController?.pushViewController(vc, animated: true)
    }
    func privacyPolicyAction(_ result: AttributedString.Action.Result) {
        logDebug("跳转隐私协议")
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        self.ext.navigationController?.pushViewController(vc, animated: true)
    }
}
