//
//  VerifyOTPPresenter.swift
//  InstntSDK_Example
//
//  Created by Jagruti Patel CW on 12/29/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import InstntSDK
import SVProgressHUD
class VerifyOTPPresenter: BasePresenter {
    var vc: VerifyOTPVC? {
        return viewControllerObject as? VerifyOTPVC
    }
    var phoneNumber: String?
    
    lazy var otp: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        return view
    }()
    lazy var buttonView: ButtonView? = {
        guard let view = Utils.getViewFromNib(name: "ButtonView") as? ButtonView  else {
            return nil
        }
        return view
    }()
    override func presentScene() {
        super.presentScene()
        self.buildView()
    }

    func buildView() {
        addVerifyOTP()
        addButton()
    }
    
    func addVerifyOTP() {
        otp?.decorateTextField(textfieldType: .otp)
        self.vc?.stackView.addOptionalArrangedSubview(otp)
    }
    
    func addButton() {
        buttonView?.decorateView(type: .verifyOTP, completion: {
            let phone = self.phoneNumber ?? ""
            let otp = self.otp?.textField.text ?? ""
            SVProgressHUD.show()
            Instnt.shared.verifyOTP(phoneNumber: phone, otp: otp, completion: { result in
                SVProgressHUD.dismiss()
                switch result {
                case .success:
                    guard let vc = Utils.getStoryboardInitialViewController("Address") as? AddressVC else {
                        return
                    }
                    self.vc?.navigationController?.pushViewController(vc, animated: true)
                case .failure(_):
                    if let vc = self.vc {
                        self.vc?.showSimpleAlert("Error getting the OTP", target: vc)
                    }
                }
            })
        })
        self.vc?.stackView.addOptionalArrangedSubview(buttonView)
    }
}
