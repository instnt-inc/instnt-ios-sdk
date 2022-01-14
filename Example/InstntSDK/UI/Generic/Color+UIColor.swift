//
//  Color+UIColor.swift
//  taxiapp
//
//  Created by Jagruti on 9/25/19.
//  Copyright © 2019 ROBAB. All rights reserved.
//

import Foundation
import UIKit
public extension UIColor {
    class func appYelloColor() -> UIColor {
//        if let color  = LoginResponse.get()?.theme, let theme = Theme(rawValue: color) {
//            return UIColor.hexString(theme.color)
//        }
       return UIColor.hexString("273f83")
    }

    class func estimatedPriceColor() -> UIColor {
       return UIColor.rgba(109.0, 218.0, 147, 1.0)
    }
    
    class func emergencyViewColor() -> UIColor {
       return UIColor.red
    }
    
    class func appBackgroundColor() -> UIColor {
        return UIColor.hexString("F1F1F1")
    }

    class func hexString(_ hex: String, _ alpha: Float = 1) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: CharacterSet.newlines).uppercased()

        if cString.hasPrefix("#") {
            let startIndex = cString.index(cString.startIndex, offsetBy: 1)
            cString = String(cString[startIndex...])
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }

    class func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}
