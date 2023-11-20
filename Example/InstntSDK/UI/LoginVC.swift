//
//  LoginVC.swift
//  InstntSDK_Example
//
//  Created by Abhishek on 17/08/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class LoginVC: BaseViewController {
    var presenter: LoginPresenter? {
        return presenterObject as? LoginPresenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.presentScene()
    }
}

