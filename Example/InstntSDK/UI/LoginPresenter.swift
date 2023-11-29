//
//  LoginPresenter.swift
//  InstntSDK_Example
//
//  Created by Abhishek on 17/08/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import InstntSDK
import SVProgressHUD

class LoginPresenter: BasePresenter {
    
    var vc: LoginVC? {
        return viewControllerObject as? LoginVC
    }
    
    lazy var loginLbl: LabelView? = {
        guard let view = Utils.getViewFromNib(name: "LabelView") as? LabelView  else {
            return nil
        }
        return view
    }()
    
    lazy var formKey: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        return view
    }()
    
    lazy var endPoint: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        return view
    }()
    
    lazy var email: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        return view
    }()
    
    lazy var password: TextFieldView? = {
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
        
        addEmail()
        addPassword()
        
        addButton()
        addButton2()
        
    }
    
    private func addLoginLbl() {
        loginLbl?.lblText.text = "Login"
        self.vc?.stackView.addOptionalArrangedSubview(loginLbl)
    }
    
    private func addFormKey() {
        formKey?.decorateTextField(textfieldType: .formKey)
        //v163875646772327
        //v1639687041590101
        formKey?.textField.text = "v1639687041590101"
        self.vc?.stackView.addOptionalArrangedSubview(formKey)
    }
    
    private func addEndPoint() {
        endPoint?.decorateTextField(textfieldType: .endPoint)
        endPoint?.textField.text = "https://dev2-api.instnt.org/public"
        self.vc?.stackView.addOptionalArrangedSubview(endPoint)
    }
    
    private func addEmail() {
        email?.decorateTextField(textfieldType: .email)
        self.vc?.stackView.addOptionalArrangedSubview(email)
    }
    
    private func addPassword() {
        password?.decorateTextField(textfieldType: .password)
        password?.textField.text = "eea33f30-21db-4755-9b8e-357394ec7649"
        self.vc?.stackView.addOptionalArrangedSubview(password)
    }
    
    private func addButton() {
        self.buttonView?.decorateView(type: .next, completion: {
            
            Instnt.shared.transactionID = self.password?.textField.text
            
            guard let vc = self.vc else {
                return
            }
            
            guard self.password?.validate(textfieldType: .password, text: self.password?.textField.text ?? "") == true else {
                
                vc.showSimpleAlert("Enter password", target: vc)
                return
            }
            
            self.getScreenAfterSuccess()
        })
        self.vc?.stackView.addOptionalArrangedSubview(buttonView)
    }
    
    private func addButton2() {
        self.buttonView2?.decorateView(type: .next, completion: {
            
        })
        self.vc?.stackView.addOptionalArrangedSubview(buttonView2)
    }
    
    func getScreenAfterSuccess() {
        
        guard let vc = Utils.getStoryboardInitialViewController("Dashboard") as? DashboardVC else {
            return
        }
        self.vc?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
