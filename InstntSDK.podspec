#
# Be sure to run `pod lib lint InstntSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'InstntSDK'
  s.version          = '2.0.0'
  s.summary          = 'Swift CocoaPod implementation of the Instnt SDK'
  s.description      = 'Swift CocoaPod implementation of the Instnt SDK'

  s.homepage         = 'https://github.com/instnt-inc/instnt-ios-sdk'
  s.author           = { 'Instnt Inc' => 'support+github@instnt.org' }
  s.source           = { :git => 'https://github.com/instnt-inc/instnt-ios-sdk.git', :tag => s.version.to_s }
  
  s.platform     = :ios
  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files = 'InstntSDK/Classes/**/*'
  
  s.resource_bundles = {
     'InstntSDK' => ['InstntSDK/Assets/*.xcassets']
  }
  s.public_header_files = 'Pod/Classes/**/*.h'
  
  s.frameworks = 'UIKit'
  s.dependency 'ActionSheetPicker-3.0', '~> 2.7'
  s.dependency 'IQKeyboardManagerSwift', '~> 6.5'
  s.dependency 'DeviceKit', '~> 4.0'
  s.dependency 'SVProgressHUD', '~> 2.2'
  s.dependency 'SnapKit', '~> 5.0'
  s.vendored_frameworks = 'CFDocumentScanSDK.framework', 'IDMetricsSelfieCapture.framework'
  
end
