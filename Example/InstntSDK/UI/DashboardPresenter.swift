//
//  DashboardPresenter.swift
//  InstntSDK_Example
//
//  Created by Abhishek on 18/08/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//dx


import Foundation
import UIKit
import InstntSDK
import SVProgressHUD

class DashboardPresenter: BasePresenter {
    
    var vc: DashboardVC? {
        return viewControllerObject as? DashboardVC
    }
    
    lazy var buttonView: ButtonView? = {
        guard let view = Utils.getViewFromNib(name: "ButtonView") as? ButtonView  else {
            return nil
        }
        return view
    }()
    
    lazy var buttonView2: ButtonView? = {
        guard let view = Utils.getViewFromNib(name: "ButtonView") as? ButtonView  else {
            return nil
        }
        view.alpha = 0.0
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override func presentScene() {
        super.presentScene()
        self.buildView()
    }
    
    private func buildView() {
        
        addButton()
        
        addButton2()
        
        //self.initTransaction()
        
    }
    
    private func initTransaction() {
        
        let transactionID = Instnt.shared.transactionID
        
        let formID = UserDefaults.standard.value(forKey: "form_key") as? String ?? ""
        let enPoint = UserDefaults.standard.value(forKey: "end_point")
        
        SVProgressHUD.show()
        Instnt.shared.resumeSignup(view: self.vc!, with: formID, endPOint: enPoint as! String, instnttxnid: transactionID!, completion: { result in
            SVProgressHUD.dismiss()
            switch result {
                case .success(let transactionID):
                    ExampleShared.shared.transactionID = transactionID

                case .failure(let error):
                    
                print(error)
                    //self.addResponse()
                    //self.lblView?.lblText.text = "Set up is failed with \(error.message ?? ""), please try again later"
                }
           
        })
        
    }
    
    private func addButton() {
        self.buttonView?.decorateView(type: .newTransaction, completion: {
            
            self.newTransactionScreen()
            
        })
        
        self.vc?.stackView.addOptionalArrangedSubview(buttonView)
        
    }
    
    private func addButton2() {
            self.buttonView2?.decorateView(type: .newTransaction, completion: {
                        
            })
            self.vc?.stackView.addOptionalArrangedSubview(buttonView2)
    }
    
    func newTransactionScreen() {
        
        guard let vc = Utils.getStoryboardInitialViewController("VerifyData") as? VerifyDataVC else {
            return
        }
        self.vc?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
