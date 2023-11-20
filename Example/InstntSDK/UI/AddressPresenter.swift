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

class AddressPresenter: BasePresenter, UITextFieldDelegate {
    var vc: AddressVC? {
        return viewControllerObject as? AddressVC
    }
    
    lazy var address: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        
        //view.textField.setValuesForKeys(["behavioTrackingId":"physicalAddress"])
        view.textField.accessibilityLabel = "physicalAddress"
        view.textField.accessibilityIdentifier = "physicalAddress"
        
        view.textField.text = ExampleShared.shared.formData["physicalAddress"] as? String
        return view
    }()
    
    lazy var city: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        
        view.textField.setValuesForKeys(["behavioTrackingId":"city"])
        view.textField.accessibilityLabel = "city"
        view.textField.accessibilityIdentifier = "city"
        
        view.textField.text = ExampleShared.shared.formData["city"] as? String
        return view
    }()
    
    lazy var state: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        
        //view.textField.setValuesForKeys(["behavioTrackingId":"state"])
        view.textField.accessibilityLabel = "state"
        view.textField.accessibilityIdentifier = "state"
        
        view.textField.text = ExampleShared.shared.formData["state"] as? String
        return view
    }()
    
    lazy var zip: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        
        //view.textField.setValuesForKeys(["behavioTrackingId":"zip"])
        view.textField.accessibilityLabel = "zip"
        view.textField.accessibilityIdentifier = "zip"
        
        view.textField.text = ExampleShared.shared.formData["zip"] as? String
        return view
    }()
    
    lazy var country: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        
        //view.textField.setValuesForKeys(["behavioTrackingId":"country"])
        view.textField.accessibilityLabel = "country"
        view.textField.accessibilityIdentifier = "country"
        
        view.textField.text = ExampleShared.shared.formData["country"] as? String
        return view
    }()
    
    lazy var dob: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView else {
            return nil
        }
        
        view.textField.accessibilityLabel = "dob"
        view.textField.accessibilityIdentifier = "dob"
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.maximumDate = Date()
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alertController.view.addSubview(datePicker)
        
        alertController.addAction(UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            self?.dob?.textField.resignFirstResponder()
        })
        
        view.textField.inputView = alertController.view
        
        if let formDataDOB = ExampleShared.shared.formData["dob"] as? String {
            view.textField.text = formDataDOB
        }
        
        return view
    }()

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.string(from: sender.date)
        dob?.textField.text = selectedDate
    }

    lazy var nationalId: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView else {
            return nil
        }

        view.textField.accessibilityLabel = "nationalId"
        view.textField.accessibilityIdentifier = "nationalId"
        view.textField.delegate = self

        if let formDataNationalId = ExampleShared.shared.formData["nationalId"] as? String {
               view.textField.text = formDataNationalId
           }

        return view
    }()

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nationalId?.textField {
            if let currentText = textField.text as NSString? {
                let updatedText = currentText.replacingCharacters(in: range, with: string)
                let pattern = "(\\d{3})(\\d{2})(\\d{4})"
                   let regex = try! NSRegularExpression(pattern: pattern, options: [])
                   let formattedText = regex.stringByReplacingMatches(in: updatedText, options: [], range: NSRange(location: 0, length: updatedText.count), withTemplate: "$1-$2-$3")

                   textField.text = formattedText
                   
                   if updatedText.count > 9 {
                       textField.text = String(formattedText.prefix(11))
                       return false
                   }
                   
                   if formattedText.count > 9 {
                       return false
                   }
            }
        }
        
        return true
    }

    
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

    private func buildView() {
        addAddress()
        addCity()
        addState()
        addZip()
        addCountry()
        addDob()
        addNationalId()
        addButton()
        
        //uncomment this incase need to add skip button 
//        if SignUpManager.shared.type == .resumeSignUp {
//            addSkipButton()
//        }
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
    
    private func addDob() {
        dob?.decorateTextField(textfieldType: .dob)
        self.vc?.stackView.addOptionalArrangedSubview(dob)
    }
    
    private func addNationalId() {
        nationalId?.decorateTextField(textfieldType: .nationalId)
        self.vc?.stackView.addOptionalArrangedSubview(nationalId)
    }
    
    func instntDidSubmitSuccess(decision: String, jwt: String) {
        print("instntDidSubmitSuccess")
        guard let vc = self.vc else {
            return
        }
        vc.showSimpleAlert("Form is submitted and decision is \(decision)", target: vc, completed: { [weak self] in
            guard let `self` = self else { return }
            
            /*
            guard let vc = Utils.getStoryboardInitialViewController("CustomForm") as? CustomFormViewController else {
                return
            }
            self.vc?.navigationController?.pushViewController(vc, animated: true)
             */
            
            let board = UIStoryboard(name: "SelectSignUpType", bundle: nil)
            
            let newVC = board.instantiateInitialViewController()
            newVC?.modalPresentationStyle = .fullScreen
            
            self.vc?.navigationController?.present(newVC!, animated: true)

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
                
                if(self.address?.textField.text?.count == 0 || self.city?.textField.text?.count == 0 || self.state?.textField.text?.count == 0 || self.zip?.textField.text?.count == 0 || self.country?.textField.text?.count == 0) {
                    if let vc = self.vc {
                        self.vc?.showSimpleAlert("Please provide complete address", target: vc)
                    }
                    return
                }
                
                ExampleShared.shared.formData["physicalAddress"] = self.address?.textField.text
                ExampleShared.shared.formData["city"] = self.city?.textField.text
                ExampleShared.shared.formData["state"] = self.state?.textField.text
                ExampleShared.shared.formData["zip"] = self.zip?.textField.text
                ExampleShared.shared.formData["country"] = self.country?.textField.text
                ExampleShared.shared.formData["dob"] = self.dob?.textField.text
                ExampleShared.shared.formData["nationalId"] = self.nationalId?.textField.text
                
                guard let transactionID = ExampleShared.shared.transactionID else {
                    if let vc = self.vc {
                        self.vc?.showSimpleAlert("Invalid transacation ID, please try again later", target: vc)
                    }
                    return
                }
                SVProgressHUD.show()
                Instnt.shared.submitData(instnttxnid: transactionID, data: ExampleShared.shared.formData, completion: { result in
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
            buttonView?.button.accessibilityIdentifier = "signupSubmit"
            self.vc?.stackView.addOptionalArrangedSubview(buttonView)
        } else {
            buttonView?.decorateView(type: .next, completion: {
                
                if(self.address?.textField.text?.count == 0 || self.city?.textField.text?.count == 0 || self.state?.textField.text?.count == 0 || self.zip?.textField.text?.count == 0 || self.country?.textField.text?.count == 0) {
                    if let vc = self.vc {
                        self.vc?.showSimpleAlert("Please provide complete address", target: vc)
                    }
                    return
                }
                
                ExampleShared.shared.formData["physicalAddress"] = self.address?.textField.text
                ExampleShared.shared.formData["city"] = self.city?.textField.text
                ExampleShared.shared.formData["state"] = self.state?.textField.text
                ExampleShared.shared.formData["zip"] = self.zip?.textField.text
                ExampleShared.shared.formData["country"] = self.country?.textField.text
                ExampleShared.shared.formData["dob"] = self.dob?.textField.text
                ExampleShared.shared.formData["nationalId"] = self.nationalId?.textField.text
                
                guard let vc = Utils.getStoryboardInitialViewController("UploadDocument") as? UploadDocumentVC else {
                    return
                }
                self.vc?.navigationController?.pushViewController(vc, animated: true)
            })
            
            buttonView?.button.accessibilityIdentifier = "nextBtnAddress"
            self.vc?.stackView.addOptionalArrangedSubview(buttonView)
        }
        
    }
    
    
    private func addSkipButton() {
        skipBtnView?.decorateView(type: .skip, completion: {
            guard let vc = Utils.getStoryboardInitialViewController("UploadDocument") as? UploadDocumentVC else {
                return
            }
            self.vc?.navigationController?.pushViewController(vc, animated: true)
        })
        self.vc?.stackView.addOptionalArrangedSubview(skipBtnView)
    }
}
