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
        
        //view.textField.setValuesForKeys(["behavioTrackingId":"email"])
        view.textField.accessibilityLabel = "email"
        view.textField.accessibilityIdentifier = "email"
        
        view.textField.text = ExampleShared.shared.formData["email"] as? String
        return view
    }()

    lazy var phone: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        
        //view.textField.setValuesForKeys(["behavioTrackingId":"mobileNumber"])
        view.textField.accessibilityLabel = "mobileNumber"
        view.textField.accessibilityIdentifier = "mobileNumber"
        
        view.textField.text = ExampleShared.shared.formData["mobileNumber"] as? String ?? ""
        //+12064512559
        return view
    }()
    lazy var buttonView: ButtonView? = {
        guard let view = Utils.getViewFromNib(name: "ButtonView") as? ButtonView  else {
            return nil
        }
        return view
    }()
    
    lazy var skipBtnView: ButtonView? = {
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
        
        if SignUpManager.shared.type == .resumeSignUp {
            addSkipButton()
        }
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
            buttonView?.decorateView(type: .next, completion: {[weak self] in
                
                guard let `self` = self else { return }
                
                guard self.email?.validate(textfieldType: .email, text: self.email?.textField.text ?? "") == true else {
                    self.showSimpleAlert(with: "Email is Invalid")
                    return
                }
                
                guard self.phone?.validate(textfieldType: .mobile, text: self.phone?.textField.text ?? "") == true else {
                    self.showSimpleAlert(with: "Phone is Invalid")
                    return
                }
                
                ExampleShared.shared.formData["mobileNumber"] = self.phone?.textField.text
                ExampleShared.shared.formData["email"] = self.email?.textField.text
                if Instnt.shared.isOTPverificationEnabled == false {
                    guard let vc = Utils.getStoryboardInitialViewController("Address") as? AddressVC else {
                        return
                    }
                    self.vc?.navigationController?.pushViewController(vc, animated: true)
                }
            })
            buttonView?.button.accessibilityIdentifier = "nextBtnEmailPhone"
            self.vc?.stackView.addOptionalArrangedSubview(buttonView)
            return
        }
        
        buttonView?.decorateView(type: .submitOTP, completion: { [weak self] in
            guard let `self` = self else { return }
            
            guard self.email?.validate(textfieldType: .email, text: self.email?.textField.text ?? "") == true else {
                self.showSimpleAlert(with: "Email is Invalid")
                return
            }
            guard self.phone?.validate(textfieldType: .mobile, text: self.phone?.textField.text ?? "") == true else {
                self.showSimpleAlert(with: "Phone is Invalid")
                return
            }
            
            let phone = self.phone?.textField.text ?? ""
            SVProgressHUD.show()
            guard let transactionID = ExampleShared.shared.transactionID else {
                if let vc = self.vc {
                    self.vc?.showSimpleAlert("Invalid transacation ID, please try again later", target: vc)
                }
                return
            }
            Instnt.shared.sendOTP(instnttxnid: transactionID, phoneNumber: phone, completion: { result in
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
    
    
    func showSimpleAlert(with msg: String) {
        guard let vc = vc else { return }
        vc.showSimpleAlert(msg, target: vc, completed: {})
    }
    
    
    func addSkipButton() {
        if Instnt.shared.isOTPverificationEnabled == false  {
            skipBtnView?.decorateView(type: .skip, completion: {
                    guard let vc = Utils.getStoryboardInitialViewController("Address") as? AddressVC else {
                        return
                    }
                    self.vc?.navigationController?.pushViewController(vc, animated: true)
                
            })
            self.vc?.stackView.addOptionalArrangedSubview(skipBtnView)
            return
        }
        
        skipBtnView?.decorateView(type: .skip, completion: {
            let phone = self.phone?.textField.text ?? ""
            SVProgressHUD.show()
            
            guard let vc = Utils.getStoryboardInitialViewController("VerifyOTP") as? VerifyOTPVC else {
                return
            }
            vc.presenter?.phoneNumber = phone
            self.vc?.navigationController?.pushViewController(vc, animated: true)
        })
        self.vc?.stackView.addOptionalArrangedSubview(skipBtnView)
    }
    
}
