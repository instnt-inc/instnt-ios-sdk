//
//  SpacerView.swift
//  taxiapp
//
//  Created by Jagruti on 9/23/19.
//  Copyright © 2019 ROBAB. All rights reserved.
//

import Foundation
import UIKit

class SwitchView: UIView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var uiswitch: UISwitch!
    var completionBlock: ((Bool) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func decorateView(title: String, completion: @escaping ((Bool) -> Void)) {
        self.title.text = title
        self.completionBlock = completion
    }
    
    @IBAction func onValueChanged(_ sender: Any) {
        completionBlock?(uiswitch.isOn)
    }
}
