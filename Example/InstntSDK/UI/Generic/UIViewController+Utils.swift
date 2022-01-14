//
//  UIViewController+Utils.swift
//  taxiapp
//
//  Created by Jagruti on 10/28/19.
//  Copyright © 2019 ROBAB. All rights reserved.
//

import Foundation
import UIKit
public extension UIViewController {
    func firstViewController() -> UIViewController! {
        var currVc: UIViewController! = self
        var prevVc: UIViewController! = self
        while currVc != nil {
            prevVc = currVc
            currVc = currVc.parent
        }
        return prevVc
    }
}
