//
//  Utils.swift
//  taxiapp
//
//  Created by Jagruti on 9/23/19.
//  Copyright © 2019 ROBAB. All rights reserved.
//

import Foundation
import UIKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class Utils {
    static let companyCode = "Qaf Rider"
    static let platForm = "iOS"

    class func getStoryboardInitialViewController(_ storyboard: String) -> UIViewController {
        let board = UIStoryboard(name: storyboard, bundle: nil)
        return board.instantiateInitialViewController()!
    }
    class func getViewFromNib(name: String) -> UIView? {
        return Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.last as? UIView
    }
    class func getViewHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    class func getViewWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    @available(iOS 11.0, *)

    class func getSafeArea() -> UIEdgeInsets? {
        let window = UIApplication.shared.keyWindow
        return window?.safeAreaInsets
    }
    class func getDeviceModel() -> String {
        return UIDevice.current.model
    }
    
    class func getApplicationVersion() -> String {
        if let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String {
            return version
        }
        return ""
    }
    class func getOSVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    class func getDevice() -> String {
        return UIDevice.current.model
    }

    

    
}
extension NSObject {
    public var theClassName: String {
        return NSStringFromClass(type(of: self))
    }
}
