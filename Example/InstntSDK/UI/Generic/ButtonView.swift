//
//  ButtonView.swift
//  taxiapp
//
//  Created by Jagruti on 9/23/19.
//  Copyright © 2019 ROBAB. All rights reserved.
//

import Foundation
import UIKit
class ButtonView: UIView {
    @IBOutlet weak var button: MyButton!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var traillingConstraint: NSLayoutConstraint!
    var completionBlock: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func decorateView(type: ButtonTypes, completion: @escaping (() -> Void)) {
        completionBlock = completion
        switch type {
        case .next:
            button.backgroundColor = UIColor.black
            button .setTitle(NSLocalizedString("Next", comment: ""), for: .normal)
        case .submitOTP:
            button.backgroundColor = UIColor.black
            button .setTitle(NSLocalizedString("Send OTP", comment: ""), for: .normal)
        case .verifyOTP:
            button.backgroundColor = UIColor.black
            button .setTitle(NSLocalizedString("Verify OTP", comment: ""), for: .normal)
        case .setUp:
            button.backgroundColor = UIColor.black
            button .setTitle(NSLocalizedString("Set Up", comment: ""), for: .normal)
        case .submitForm:
            button.backgroundColor = UIColor.black
            button .setTitle(NSLocalizedString("Submit Form", comment: ""), for: .normal)
            
        
        }
    }

    @IBAction func onClickButton(_ sender: Any) {
        completionBlock?()
    }
}
