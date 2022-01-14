//
//  EmailPhoneVC.swift
//  InstntSDK_Example
//
//  Created by Jagruti Patel CW on 12/29/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
class EmailPhoneVC: BaseViewController {
    var presenter: EmailPhonePresenter? {
        return presenterObject as? EmailPhonePresenter
    }

    override func viewDidLoad() {
        presenter?.presentScene()
    }
}
