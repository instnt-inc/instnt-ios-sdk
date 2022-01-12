//
//  MainViewController.swift
//  InstntSDK_Example
//
//  Created by Admin on 7/10/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import InstntSDK

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UI Action
    @IBAction func onDefaultForm(_ sender: Any) {
        performSegue(withIdentifier: "MainToDefault", sender: nil)
    }
    
    @IBAction func onCustomForm(_ sender: Any) {
        //performSegue(withIdentifier: "MainToCustom", sender: nil)
        
        
        let documentSettings = DocumentSettings(documentType: .licence, documentSide: .back
                                                , captureMode: .manual, backFocusThreshold: 110, nativeBackFocusThreshold: 110, backGlareThreshold: 2.5, nativeBackGlareThreshold: 2.5, backCaptureAttempts: 3)
        Instnt.shared.scanDocument(from: self, documentSettings: documentSettings)
    }
}

extension MainViewController {
    
}
