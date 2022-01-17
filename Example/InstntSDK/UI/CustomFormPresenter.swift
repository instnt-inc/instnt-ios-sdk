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
    
    lazy var switchView: SwitchView? = {
        guard let view = Utils.getViewFromNib(name: "SwitchView") as? SwitchView  else {
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
        addFormKey()
        addSandboxSwitch()
        self.vc?.stackView.addSpacerView()
        addSetUpButton()
    }
    
    private func addFormKey() {
        formKey?.decorateTextField(textfieldType: .formKey)
        formKey?.textField.text = "v163875646772327"
        self.vc?.stackView.addOptionalArrangedSubview(formKey)
    }
    private func addSandboxSwitch() {
        switchView?.decorateView(title: "FormKey", completion: { isOn in
       
        })
        self.vc?.stackView.addOptionalArrangedSubview(switchView)
    }
    
    private func addSetUpButton() {
        setUpBtn?.decorateView(type: .setUp, completion: {
            if let formKey = self.formKey?.textField.text, formKey.count == 16  {
                SVProgressHUD.show()
                Instnt.shared.setup(with: formKey, isSandBox: self.switchView?.uiswitch.isOn ?? true, completion: { result in
                    SVProgressHUD.dismiss()
                    self.addResponse()
                    self.getFormAfterSuccess()
                    switch result {
                    case .success(let transactionID):
                        self.lblView?.lblText.text = "Set up is succeded with transaction Id \(transactionID)"
                    case .failure(let error):
                        self.lblView?.lblText.text = "Set up is failed with \(error.localizedDescription), please try again later"
                    }
                })
            } else {
                guard let errorVC = self.vc else {
                    return
                }
                errorVC.showSimpleAlert("Please Enter 16 digits form key", target: errorVC)
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
        self.setUpBtn?.decorateView(type: .getForm, completion: {
            SVProgressHUD.show()
            Instnt.shared.getFormCodes { response in
                SVProgressHUD.dismiss()
                self.gotoFirstName()
            }
            
        })
    }
    
    private func gotoFirstName() {
        guard let vc = Utils.getStoryboardInitialViewController("FirstLastName") as? FirstLastNameVC else {
            return
        }
        self.vc?.navigationController?.pushViewController(vc, animated: true)
    }
    

}
