platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!
source 'https://github.com/CocoaPods/Specs.git'
target 'Diary' do
  # Rx
  pod 'RxActivityIndicator', '~> 1.0.0'
  pod 'NSObject+Rx', '~> 5.1.0'
  pod 'Moya/RxSwift', '~> 14.0.0'
  pod 'RxDataSources', '~> 4.0.1'
  pod 'RxReachability', '~> 1.0.0'
  # Placeholder
  pod 'EmptyDataSet-Swift'
  # layout
  pod 'SnapKit', '~> 5.0.1'
  pod 'AutoInch', '~> 2.1.0'
  # hud
  pod 'MBProgressHUD', '~> 1.2.0'
  # refresh
  pod 'MJRefresh', '~> 3.4.3'
  # database
  pod 'GRDB.swift'
  # theme
  pod 'SwiftTheme', '~> 0.5.5'
  # toast
  pod 'Toaster', :git => 'https://github.com/devxoul/Toaster', :commit => 'aec54fc48d3d36279424103de0784c23862d19df'
  # navigation
  pod 'HBDNavigationBar','~> 1.7.7'
  pod 'UINavigation-SXFixSpace', '~> 1.2.4'
  # log
  pod 'SwiftyBeaver', '~> 1.9.1'
  # model
  pod 'HandyJSON', '~> 5.0.2'
  pod 'SwiftyJSON', '~> 5.0.0'
  # attribute
  pod 'SwiftRichString','~> 3.7.2'
  pod 'AttributedString','~> 1.6.8'
  # Tools
  pod 'R.swift', '~> 5.3.0'
  # launch Ad
  pod 'XHLaunchAd', '~> 3.9.12'
  # alert
  pod 'SwiftEntryKit', '~> 1.2.6'
  # PageScrollView
  pod 'GKPageScrollViewSwift', '~> 1.4.2'
  pod 'JXSegmentedView', '~> 1.2.7'
  pod 'JXPagingView/Paging','~> 2.0.13'
  # image
  pod 'SDWebImageWebPCoder','~> 0.6.1'
  pod 'SDWebImageFLPlugin', '~> 0.4.0'
  # IconFont
  pod 'EFIconFont', '~> 0.8.1'
  # cache
  pod 'DefaultsKit', '~> 0.2.0'
  # route
  pod 'URLNavigator', '~> 2.3.0'
  # player
  pod 'ZFPlayer/AVPlayer', '~> 4.0.1'
  pod 'ZFPlayer/ControlView'
  # 极光
  pod 'JMLink','~> 1.2.3'
  pod 'JPush', '~> 3.3.6'
  pod 'JCore', '~> 2.4.0-noidfa'
  # debug tool
  pod 'MLeaksFinder', :configurations => ['Debug']
  pod 'FLEX', '~> 4.2.2', :configurations => ['Debug']
  pod 'GDPerformanceView-Swift', '~> 2.1.1', :configurations => ['Debug']
end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
        end
    end
end
