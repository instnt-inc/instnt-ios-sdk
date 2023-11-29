//
//  RadioButton.swift
//  InstntSDK_Example
//
//  Created by Jagruti Patel CW on 6/23/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
class RadioButton: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSelect: UIButton! {
        didSet{
            btnSelect.tintColor = .black
            btnSelect.setImage(UIImage(named:"circle_radio_unselected"), for: .normal)
            btnSelect.setImage(UIImage(named:"circle_radio_selected"), for: .selected)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var completionBlock: (() -> Void)?
    
    @IBAction func onClickRadioButton(_ sender: Any) {
        completionBlock?()
    }
}
