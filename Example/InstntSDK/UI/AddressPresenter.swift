//
//  AddressPresenter.swift
//  InstntSDK_Example
//
//  Created by Jagruti Patel CW on 12/29/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
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

    func buildView() {
        addAddress()
        addCity()
        addState()
        addZip()
        addCountry()
        addButton()
    }
    
    func addAddress() {
        address?.decorateTextField(textfieldType: .address)
        self.vc?.stackView.addOptionalArrangedSubview(address)
    }
    
    func addCity() {
        city?.decorateTextField(textfieldType: .city)
        self.vc?.stackView.addOptionalArrangedSubview(city)
    }
    
    func addState() {
        state?.decorateTextField(textfieldType: .state)
        self.vc?.stackView.addOptionalArrangedSubview(state)
    }
    
    func addZip() {
        zip?.decorateTextField(textfieldType: .zipcode)
        self.vc?.stackView.addOptionalArrangedSubview(zip)
    }
    
    func addCountry() {
        country?.decorateTextField(textfieldType: .country)
        self.vc?.stackView.addOptionalArrangedSubview(country)
    }
    
    func addButton() {
        buttonView?.decorateView(type: .next, completion: {
            guard let vc = Utils.getStoryboardInitialViewController("Main") as? SelectDocTypeVCViewController else {
                return
            }
            self.vc?.navigationController?.pushViewController(vc, animated: true)
        })
        self.vc?.stackView.addOptionalArrangedSubview(buttonView)
    }
    
}
