Instnt Swift Example App
================
This app is here to provide a sample of the Instnt iOS SDK in action. In order to use it, run `pod install` in the directory and CocoaPods will pull in your dependencies and create editable versions of the library in the parent folder.

Podfile
=====

The [Podfile](https://github.com/instnt-inc/instnt-ios-sdk/blob/main/Example/Podfile) for this example has no dependencies so is just:

``` ruby
use_frameworks!

platform :ios, '11.0'

target 'SwiftyInstnt_Example' do
  pod 'SwiftyInstnt', :path => '../'
end

```

