//
//  MyButton.swift
//  taxiapp
//
//  Created by Jagruti on 10/16/19.
//  Copyright © 2019 ROBAB. All rights reserved.
//

import Foundation
import UIKit
class MyButton: UIButton {
    enum configType {
        case disable, enable
    }
    var type: configType = .enable {
        willSet {
            switch newValue {
            case .disable:
                isEnabled = false
                self.backgroundColor = UIColor.lightGray
            case .enable:
                isEnabled = true
                self.backgroundColor = UIColor.appYelloColor()
            }
        }
    }
}
