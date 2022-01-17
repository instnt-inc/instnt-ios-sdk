//
//  AddressPresenter.swift
//  InstntSDK_Example
//
//  Created by Jagruti Patel CW on 12/29/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import InstntSDK
class AddressPresenter: BasePresenter {
    var vc: AddressVC? {
        return viewControllerObject as? AddressVC
    }
    
    lazy var address: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        return view
    }()
    
    lazy var city: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        return view
    }()
    
    lazy var state: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        return view
    }()
    
    lazy var zip: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        return view
    }()
    
    lazy var country: TextFieldView? = {
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

    private func buildView() {
        addAddress()
        addCity()
        addState()
        addZip()
        addCountry()
        addButton()
    }
    
    private func addAddress() {
        address?.decorateTextField(textfieldType: .address)
        self.vc?.stackView.addOptionalArrangedSubview(address)
    }
    
    private func addCity() {
        city?.decorateTextField(textfieldType: .city)
        self.vc?.stackView.addOptionalArrangedSubview(city)
    }
    
    private func addState() {
        state?.decorateTextField(textfieldType: .state)
        self.vc?.stackView.addOptionalArrangedSubview(state)
    }
    
    private func addZip() {
        zip?.decorateTextField(textfieldType: .zipcode)
        self.vc?.stackView.addOptionalArrangedSubview(zip)
    }
    
    private func addCountry() {
        country?.decorateTextField(textfieldType: .country)
        self.vc?.stackView.addOptionalArrangedSubview(country)
    }
    
    private func addButton() {
        buttonView?.decorateView(type: .next, completion: {
            Instnt.shared.formData["physicalAddress"] = self.address?.textField.text
            Instnt.shared.formData["city"] = self.city?.textField.text
            Instnt.shared.formData["state"] = self.state?.textField.text
            Instnt.shared.formData["zip"] = self.zip?.textField.text
            Instnt.shared.formData["country"] = self.country?.textField.text            
            
            guard let vc = Utils.getStoryboardInitialViewController("UploadDocument") as? UploadDocumentVC else {
                return
            }
            self.vc?.navigationController?.pushViewController(vc, animated: true)
        })
        self.vc?.stackView.addOptionalArrangedSubview(buttonView)
    }
}
