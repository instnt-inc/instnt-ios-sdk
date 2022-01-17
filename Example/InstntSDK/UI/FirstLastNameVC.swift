//
//  FirstLastNameVC.swift
//  InstntSDK_Example
//
//  Created by Jagruti Patel CW on 12/29/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import InstntSDK
class FirstLastNameVC: BaseViewController {
    var presenter: FirstLastNamePresenter? {
        return presenterObject as? FirstLastNamePresenter
    }

    override func viewDidLoad() {
        presenter?.presentScene()
    }
}
