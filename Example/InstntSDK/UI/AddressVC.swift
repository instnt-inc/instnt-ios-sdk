//
//  Address.swift
//  InstntSDK_Example
//
//  Created by Jagruti Patel CW on 12/29/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
class AddressVC: BaseViewController {
    var presenter: AddressPresenter? {
        return presenterObject as? AddressPresenter
    }

    override func viewDidLoad() {
        presenter?.presentScene()
    }
}
