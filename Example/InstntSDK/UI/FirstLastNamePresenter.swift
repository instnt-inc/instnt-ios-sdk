//
//  FirstLastNamePresenter.swift
//  InstntSDK_Example
//
//  Created by Jagruti Patel CW on 12/29/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
class FirstLastNamePresenter: BasePresenter {
    var vc: FirstLastNameVC? {
        return viewControllerObject as? FirstLastNameVC
    }
    lazy var firstNameView: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        return view
    }()

    lazy var lastNameView: TextFieldView? = {
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
        addFirstName()
        addlastName()
        addNextButton()
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
        buttonView?.decorateView(type: .next, completion: {
            guard let vc = Utils.getStoryboardInitialViewController("EmailPhone") as? EmailPhoneVC else {
                return
            }
            self.vc?.navigationController?.pushViewController(vc, animated: true)
        })
        self.vc?.stackView.addOptionalArrangedSubview(buttonView)
    }
}
