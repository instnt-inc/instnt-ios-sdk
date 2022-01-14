//
//  VerifyOTPVC.swift
//  InstntSDK_Example
//
//  Created by Jagruti Patel CW on 12/29/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
class VerifyOTPVC: BaseViewController {
    var presenter: VerifyOTPPresenter? {
        return presenterObject as? VerifyOTPPresenter
    }

    override func viewDidLoad() {
        presenter?.presentScene()
    }
}
