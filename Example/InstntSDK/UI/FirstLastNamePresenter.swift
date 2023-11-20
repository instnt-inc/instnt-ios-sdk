//
//  FirstLastNamePresenter.swift
//  InstntSDK_Example
//
//  Created by Jagruti Patel CW on 12/29/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import InstntSDK
class FirstLastNamePresenter: BasePresenter {
    var vc: FirstLastNameVC? {
        return viewControllerObject as? FirstLastNameVC
    }
    lazy var firstNameView: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        
        //view.textField.setValuesForKeys(["behavioTrackingId":"firstName"])
        view.textField.accessibilityLabel = "firstName"
        view.textField.accessibilityIdentifier = "firstName"
        
        view.textField.text = ExampleShared.shared.formData["firstName"] as? String
        return view
    }()

    lazy var lastNameView: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        
        //view.textField.setValuesForKeys(["behavioTrackingId":"surName"])
        view.textField.accessibilityLabel = "surName"
        view.textField.accessibilityIdentifier = "surName"
        
        view.textField.text = ExampleShared.shared.formData["surName"] as? String
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
        addFirstName()
        addlastName()
        addNextButton()
        
        if SignUpManager.shared.type == .resumeSignUp {
            addSkipButton()
        }
    }
    
    func addFirstName() {
        firstNameView?.decorateTextField(textfieldType: .firstName)
        self.vc?.stackView.addOptionalArrangedSubview(firstNameView)
    }
    
    func addlastName() {
        lastNameView?.decorateTextField(textfieldType: .lastName)
        self.vc?.stackView.addOptionalArrangedSubview(lastNameView)
    }
    func addNextButton() {
        
       
        
        buttonView?.decorateView(type: .next, completion: { [weak self] in
            
            guard let `self` = self else { return }
            
            
            guard self.firstNameView?.validate(textfieldType: .firstName, text: self.firstNameView?.textField.text ?? "") == true else {
                self.showSimpleAlert(with: "FirstName is Invalid")
                return
            }
            
            guard self.lastNameView?.validate(textfieldType: .lastName, text: self.lastNameView?.textField.text ?? "") == true else {
                self.showSimpleAlert(with: "LastName is Invalid")
                return
            }
            
            
            ExampleShared.shared.formData["firstName"] = self.firstNameView?.textField.text
            ExampleShared.shared.formData["surName"] = self.lastNameView?.textField.text
            
            guard let vc = Utils.getStoryboardInitialViewController("EmailPhone") as? EmailPhoneVC else {
                return
            }
            self.vc?.navigationController?.pushViewController(vc, animated: true)
        })
        buttonView?.button.accessibilityIdentifier = "nextBtnFirstLastName"
        self.vc?.stackView.addOptionalArrangedSubview(buttonView)
    }
    
    
    func showSimpleAlert(with msg: String) {
        guard let vc = vc else { return }
        vc.showSimpleAlert(msg, target: vc, completed: {})
    }
    
    func addSkipButton() {
        skipBtnView?.decorateView(type: .skip, completion: {            
            guard let vc = Utils.getStoryboardInitialViewController("EmailPhone") as? EmailPhoneVC else {
                return
            }
            self.vc?.navigationController?.pushViewController(vc, animated: true)
        })
        self.vc?.stackView.addOptionalArrangedSubview(skipBtnView)
    }
}
