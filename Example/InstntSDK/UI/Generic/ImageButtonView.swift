//
//  ImageButton.swift
//  InstntSDK_Example
//
//  Created by Jagruti Patel CW on 6/23/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
class ImageButtonView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnScan: UIButton!
    @IBOutlet weak var btnImageUpload: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnScan.setTitleColor(UIColor.white, for: .normal)
        btnImageUpload.setTitle("", for: .normal)
        btnImageUpload.setImage(UIImage(named: "icon-upload"), for: .normal)
        btnImageUpload.isHidden = true
    }
    var scanCompletionBlock: (() -> Void)?
    var uploadCompletionBlock: (() -> Void)?
    
    @IBAction func onClickImageButton(_ sender: Any) {
        scanCompletionBlock?()
    }
    
    @IBAction func onClickUpload(_ sender: Any) {
        uploadCompletionBlock?()
    }
    
}
