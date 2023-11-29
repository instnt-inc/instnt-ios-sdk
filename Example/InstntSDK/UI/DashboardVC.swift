//
//  DashboardVC.swift
//  InstntSDK_Example
//
//  Created by Abhishek on 18/08/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class DashboardVC: BaseViewController {
    var presenter: DashboardPresenter? {
        return presenterObject as? DashboardPresenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.presentScene()
    }
}

