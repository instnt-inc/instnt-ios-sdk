//
//  CustomFormPresenter.swift
//  InstntSDK_Example
//
//  Created by Jagruti Patel CW on 1/14/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import InstntSDK
import SVProgressHUD

class CustomFormPresenter: BasePresenter {
    var vc: CustomFormViewController? {
        return viewControllerObject as? CustomFormViewController
    }
    
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
    
    lazy var transactionId: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        return view
    }()
    
    lazy var setUpBtn: ButtonView? = {
        guard let view = Utils.getViewFromNib(name: "ButtonView") as? ButtonView  else {
            return nil
        }
        return view
    }()
    
    lazy var lblView: LabelView? = {
        guard let view = Utils.getViewFromNib(name: "LabelView") as? LabelView  else {
            return nil
        }
        return view
    }()
    
    override func presentScene() {
        super.presentScene()
        self.buildView()
    }
    
    private func buildView() {
        //addFormKey()
        //addEndPoint()
        if SignUpManager.shared.type == .resumeSignUp {
            addTransactionId()
        }
        //addSandboxSwitch()
        self.vc?.stackView.addSpacerView()
        addSetUpButton()
    }
    
    private func addFormKey() {
        formKey?.decorateTextField(textfieldType: .formKey)
        //v163875646772327
        //v1639687041590101
        formKey?.textField.text = "v1652789756489859" //v1639687041590101"
        self.vc?.stackView.addOptionalArrangedSubview(formKey)
    }
    
    private func addEndPoint() {
        endPoint?.decorateTextField(textfieldType: .endPoint)
        endPoint?.textField.text = "https://dev2-api.instnt.org/public"
        self.vc?.stackView.addOptionalArrangedSubview(endPoint)
    }
    
    private func addTransactionId() {
        transactionId?.decorateTextField(textfieldType: .transactionID)
        //v163875646772327
        //v1639687041590101
        transactionId?.textField.text = "2b58f07e-d34c-49c8-ae39-ec98c06ab5ce"
        self.vc?.stackView.addOptionalArrangedSubview(transactionId)
    }
    
    private func addSetUpButton() {
        setUpBtn?.decorateView(type: SignUpManager.shared.type == .resumeSignUp ? .resumeSignUp : .setUp, completion: {
            ExampleShared.shared.formData = [:]
                switch SignUpManager.shared.type {
                    
                case .notDefined:
                    print("nothing to do as of now")
                case .signup:
                    if let formKey = self.formKey?.textField.text {
                        SVProgressHUD.show()
                        ExampleShared.shared.transactionID = nil

                    
                    Instnt.shared.setup(with: formKey, endPOint: self.endPoint?.textField.text ?? "", completion: { result in
                        SVProgressHUD.dismiss()
                        switch result {
                        case .success(let transactionID):
                            print("transactionID : \(transactionID)")
                            ExampleShared.shared.transactionID = transactionID
                            self.addResponse()
                            self.getFormAfterSuccess()
                            self.lblView?.lblText.text = "Set up is succeded with transaction Id \(transactionID)"
                        case .failure(let error):
                            self.addResponse()
                            self.lblView?.lblText.text = "Set up is failed with \(error.message ?? ""), please try again later"
                        }
                    })
                        
                    }
                case .resumeSignUp:
                    print("resumeSignup initiating.....")
                    //if let formKey = self.formKey?.textField.text,let instnttxnid = self.transactionId?.textField.text {
                    
                    if let formKey = UserDefaults.standard.value(forKey: "form_key"), let instnttxnid = self.transactionId?.textField.text {
                        
                        let endPoint = UserDefaults.standard.value(forKey: "end_point")
                    
                        SVProgressHUD.show()
                        ExampleShared.shared.transactionID = nil
                                                
                        Instnt.shared.resumeSignup(view: self.vc!, with: formKey as! String, endPOint: endPoint as! String, instnttxnid: instnttxnid,completion: { result in
                            SVProgressHUD.dismiss()
                            switch result {
                            case .success(let transactionID):
                                ExampleShared.shared.transactionID = transactionID
                                self.addResponse()
                                self.getFormAfterSuccess()
                                self.lblView?.lblText.text = "Set up is succeded with transaction Id \(transactionID)"

                            case .failure(let error):
                                self.addResponse()
                                self.lblView?.lblText.text = "Set up is failed with \(error.message ?? ""), please try again later"
                            }
                        })
                        
                    }
                case .doHandShake:
                    print("nothing to do as of now")
                }
                
             
        })
        self.vc?.stackView.addOptionalArrangedSubview(setUpBtn)
    }
    
    private func addResponse() {
        self.vc?.stackView.addSpacerView()
        lblView?.lblText.textAlignment = .left
        self.vc?.stackView.addOptionalArrangedSubview(lblView)
    }
    
    private func getFormAfterSuccess() {
        self.gotoFirstName()
        
//        guard  let uploadDocFinal = Utils.getStoryboardInitialViewController("UploadDocument") as? UploadDocumentVC else {
//            return
//        }
//        self.vc?.navigationController?.pushViewController(uploadDocFinal, animated: true)
    }
    
    private func gotoFirstName() {
        guard let vc = Utils.getStoryboardInitialViewController("FirstLastName") as? FirstLastNameVC else {
            return
        }
        self.vc?.navigationController?.pushViewController(vc, animated: true)
    }
    

}
