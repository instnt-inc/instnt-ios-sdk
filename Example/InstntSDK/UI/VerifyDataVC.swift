//
//  VerifyDataVC.swift
//  InstntSDK_Example
//
//  Created by Abhishek on 17/08/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class VerifyDataVC: BaseViewController {
    var presenter: VerifyDataPresenter? {
        return presenterObject as? VerifyDataPresenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.presentScene()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter?.dosetup()
    }

}


