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
import SVProgressHUD

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
    
    func instntDidSubmitSuccess(decision: String, jwt: String) {
        print("instntDidSubmitSuccess")
        guard let vc = self.vc else {
            return
        }
        vc.showSimpleAlert("Form is submitted and decision is \(decision)", target: vc, completed: {
            guard let nvc = Utils.getStoryboardInitialViewController("CustomForm") as? UINavigationController else {
                return
            }
            guard let vc = nvc.viewControllers.first else {
                return
            }
            vc.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    func instntDidSubmitFailure(error: InstntError) {
        print("instntDidSubmitFailure")
        guard let vc = self.vc else {
            return
        }
        vc.showSimpleAlert("Form submission is failed with error: \(error.message ?? "")", target: vc, completed: {
//            guard let nvc = Utils.getStoryboardInitialViewController("CustomForm") as? UINavigationController else {
//                return
//            }
//            guard let vc = nvc.viewControllers.first else {
//                return
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    private func addButton() {
        if Instnt.shared.isDocumentVerificationEnabled == false {
            self.buttonView?.decorateView(type: .submitForm, completion: {
                SVProgressHUD.show()
                Instnt.shared.submitData(ExampleShared.shared.formData, completion: { result in
                    SVProgressHUD.dismiss()
                    switch result {
                    case .success(let response):
                        if response.success == true,
                           let decision = response.decision,
                           let jwt = response.jwt {
                            self.instntDidSubmitSuccess(decision: decision, jwt: jwt)
                        } else {
                            if let msg = response.message {
                                self.instntDidSubmitFailure(error: InstntError(errorConstant: .error_FORM_SUBMIT, message: msg))
                            } else {
                                self.instntDidSubmitFailure(error: InstntError(errorConstant: .error_FORM_SUBMIT))
                            }
                            
                        }
                    case .failure(let error):
                        self.instntDidSubmitFailure(error: error)
                    }
                   
                })
            })
        } else {
            buttonView?.decorateView(type: .next, completion: {
                ExampleShared.shared.formData["physicalAddress"] = self.address?.textField.text
                ExampleShared.shared.formData["city"] = self.city?.textField.text
                ExampleShared.shared.formData["state"] = self.state?.textField.text
                ExampleShared.shared.formData["zip"] = self.zip?.textField.text
                ExampleShared.shared.formData["country"] = self.country?.textField.text
                
                guard let vc = Utils.getStoryboardInitialViewController("UploadDocument") as? UploadDocumentVC else {
                    return
                }
                self.vc?.navigationController?.pushViewController(vc, animated: true)
            })
            self.vc?.stackView.addOptionalArrangedSubview(buttonView)
        }
        
    }
}
