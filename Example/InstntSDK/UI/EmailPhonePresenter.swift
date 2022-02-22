//
//  EmailPhonePresenter.swift
//  InstntSDK_Example
//
//  Created by Jagruti Patel CW on 12/29/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import InstntSDK
class EmailPhonePresenter: BasePresenter {
    var vc: EmailPhoneVC? {
        return viewControllerObject as? EmailPhoneVC
    }
    lazy var email: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        return view
    }()

    lazy var phone: TextFieldView? = {
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
        addEmail()
        addPhone()
        addButton()
    }
    
    func addEmail() {
        email?.decorateTextField(textfieldType: .email)
        self.vc?.stackView.addOptionalArrangedSubview(email)
    }
    
    func addPhone() {
        phone?.decorateTextField(textfieldType: .mobile)
        self.vc?.stackView.addOptionalArrangedSubview(phone)
    }
    
    func addButton() {
        if Instnt.shared.isOTPverificationEnabled == false  {
            buttonView?.decorateView(type: .next, completion: {
                ExampleShared.shared.formData["mobileNumber"] = self.phone?.textField.text
                ExampleShared.shared.formData["email"] = self.email?.textField.text
                if Instnt.shared.isOTPverificationEnabled == false {
                    guard let vc = Utils.getStoryboardInitialViewController("Address") as? AddressVC else {
                        return
                    }
                    self.vc?.navigationController?.pushViewController(vc, animated: true)
                }
            })
            self.vc?.stackView.addOptionalArrangedSubview(buttonView)
            return
        }
        
        buttonView?.decorateView(type: .submitOTP, completion: {
            let phone = self.phone?.textField.text ?? ""
            SVProgressHUD.show()
            guard let transactionID = ExampleShared.shared.transactionID else {
                if let vc = self.vc {
                    self.vc?.showSimpleAlert("Invalid transacation ID, please try again later", target: vc)
                }
                return
            }
            Instnt.shared.sendOTP(transactionID: transactionID, phoneNumber: phone, completion: { result in
                SVProgressHUD.dismiss()
                switch result {
                case .success:
                    ExampleShared.shared.formData["mobileNumber"] = self.phone?.textField.text
                    ExampleShared.shared.formData["email"] = self.email?.textField.text
                    guard let vc = Utils.getStoryboardInitialViewController("VerifyOTP") as? VerifyOTPVC else {
                        return
                    }
                    vc.presenter?.phoneNumber = phone
                    self.vc?.navigationController?.pushViewController(vc, animated: true)
                case .failure( let error):
                    if let vc = self.vc {
                        self.vc?.showSimpleAlert(error.message ?? "Error getting the OTP", target: vc)
                    }
                }
            })
        })
        self.vc?.stackView.addOptionalArrangedSubview(buttonView)
    }
}
