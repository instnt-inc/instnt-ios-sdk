//
//  VerifyDataPresenter.swift
//  InstntSDK_Example
//
//  Created by Abhishek on 17/08/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import InstntSDK
import SVProgressHUD

class VerifyDataPresenter: BasePresenter {
    
    var vc: VerifyDataVC? {
        return viewControllerObject as? VerifyDataVC
    }
    
    lazy var titleView: LabelView? = {
        guard let view = Utils.getViewFromNib(name: "LabelView") as? LabelView  else {
            return nil
        }
        view.lblText.text = "New Transaction"
        
        view.lblText.font = UIFont.systemFont(ofSize: 18)
        view.lblText.textAlignment = .center
        
        return view
    }()
    
    lazy var sendMoneyToLbl: LabelView? = {
        guard let view = Utils.getViewFromNib(name: "LabelView") as? LabelView  else {
            return nil
        }
        view.lblText.text = "Send money to"
        view.lblText.font = UIFont.systemFont(ofSize: 12)
        view.lblText.textAlignment = .left
        return view
    }()
    
    lazy var firstName: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        //view.textField.text = ExampleShared.shared.formData["email"] as? String
        
        //view.textField.setValuesForKeys(["behavioTrackingId":"firstName"])
        //view.textField.accessibilityLabel = "firstName"
        view.textField.accessibilityIdentifier = "firstName"
        
        return view
    }()
    
    lazy var lastName: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        //view.textField.text = ExampleShared.shared.formData["email"] as? String
        
        //view.textField.setValuesForKeys(["behavioTrackingId":"surName"])
        //view.textField.accessibilityLabel = "surName"
        view.textField.accessibilityIdentifier = "surName"
        
        return view
    }()
    
    lazy var amount: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        //view.textField.text = ExampleShared.shared.formData["password"] as? String
        
        //view.textField.setValuesForKeys(["behavioTrackingId":"amount"])
        //view.textField.accessibilityLabel = "amount"
        view.textField.accessibilityIdentifier = "amount"
        
        return view
    }()
    
    lazy var phone: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        //view.textField.text = ExampleShared.shared.formData["password"] as? String
        
        //view.textField.setValuesForKeys(["behavioTrackingId":"phone"])
        //view.textField.accessibilityLabel = "phone"
        view.textField.accessibilityIdentifier = "phone"
        
        return view
    }()
    
    lazy var date: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        //view.textField.text = ExampleShared.shared.formData["password"] as? String
        return view
    }()
    
    lazy var notes: TextFieldView? = {
        guard let view = Utils.getViewFromNib(name: "TextFieldView") as? TextFieldView  else {
            return nil
        }
        
        //view.textField.setValuesForKeys(["behavioTrackingId":"notes"])
        //view.textField.accessibilityLabel = "notes"
        view.textField.accessibilityIdentifier = "notes"
        
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
    
    func dosetup() {
        
        self.initTransaction()
        
    }

    private func buildView() {
        
        //addTitleLbl()
        //addSendMoneyLbl()
        
        addFirstName()
        addLastName()
        addAmount()
        addPhone()
        //addDate()
        addNotes()
        
        addButton()
        addButton2()
        
        
        
    }
    
    private func initTransaction() {
        
        let transactionID = Instnt.shared.transactionID
        //let formID = "v1639687041590101"
        //let enPoint = "https://dev2-api.instnt.org/public"
        
        let formID = UserDefaults.standard.value(forKey: "form_key") as? String ?? ""
        let enPoint = UserDefaults.standard.value(forKey: "end_point")
        
        SVProgressHUD.show()
        Instnt.shared.resumeSignup(view: self.vc!, with: formID, endPOint: enPoint as! String, instnttxnid: transactionID!, completion: { result in
            SVProgressHUD.dismiss()
            switch result {
                case .success(let transactionID):
                    ExampleShared.shared.transactionID = transactionID
                    
                //self.addResponse()
                    
                print("successs")
                
                //self.lblView?.lblText.text = "Set up is succeded with transaction Id \(transactionID)"

                case .failure(let error):
                    
                print(error)
                    //self.addResponse()
                    //self.lblView?.lblText.text = "Set up is failed with \(error.message ?? ""), please try again later"
                }
           
        })
        
    }
    
    private func addTitleLbl() {
        self.vc?.stackView.addOptionalArrangedSubview(titleView)
    }
    
    private func addSendMoneyLbl() {
        self.vc?.stackView.addOptionalArrangedSubview(sendMoneyToLbl)
    }
    
    private func addFirstName() {
        firstName?.decorateTextField(textfieldType: .firstName)
        self.vc?.stackView.addOptionalArrangedSubview(firstName)
    }
    
    private func addLastName() {
        lastName?.decorateTextField(textfieldType: .lastName)
        self.vc?.stackView.addOptionalArrangedSubview(lastName)
    }
    
    private func addPhone() {
        phone?.decorateTextField(textfieldType: .mobile)
        self.vc?.stackView.addOptionalArrangedSubview(phone)
    }
    
    private func addDate() {
        date?.decorateTextField(textfieldType: .firstName)
        self.vc?.stackView.addOptionalArrangedSubview(date)
    }
    
    private func addAmount() {
        amount?.decorateTextField(textfieldType: .amount)
        self.vc?.stackView.addOptionalArrangedSubview(amount)
    }
    
    private func addNotes() {
        notes?.decorateTextField(textfieldType: .notes)
        self.vc?.stackView.addOptionalArrangedSubview(notes)
    }
    
    private func addButton2() {
            self.buttonView2?.decorateView(type: .next, completion: {
                        
            })
            self.vc?.stackView.addOptionalArrangedSubview(buttonView2)
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
            
            self.vc?.navigationController?.popViewController(animated: true)
            

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
            self.buttonView?.decorateView(type: .submitForm, completion: {
                
                let transactionID = Instnt.shared.transactionID
                //let transactionID = "f5e407e2-97f7-4845-87c9-49e874229909"
                
                guard let vc = self.vc else {
                    return
                }
                
                guard self.firstName?.validate(textfieldType: .firstName, text: self.firstName?.textField.text ?? "") == true else {
                    
                    vc.showSimpleAlert("Enter first name", target: vc)
                    return
                }
                
                guard self.amount?.validate(textfieldType: .amount, text: self.amount?.textField.text ?? "") == true else {
                    vc.showSimpleAlert("Enter amount", target: vc)
                    return
                }
                
                guard self.phone?.validate(textfieldType: .mobile, text: self.phone?.textField.text ?? "") == true else {
                    vc.showSimpleAlert("Enter correct phone number", target: vc)
                    return
                }
                
                var formFieldsDic = [String: String]()
                
                formFieldsDic["phone"] = self.phone?.textField.text
                formFieldsDic["amount"] = self.amount?.textField.text
                formFieldsDic["firstName"] = self.firstName?.textField.text
                formFieldsDic["surName"] = self.lastName?.textField.text
                formFieldsDic["notes"] = self.notes?.textField.text
                
                ExampleShared.shared.formData["form_fields"] = formFieldsDic
                
                ExampleShared.shared.formData["user_action"] = "MONEY_TRANSFER"
                
                SVProgressHUD.show()
                Instnt.shared.submitVerifyData(instnttxnid: transactionID!, data: ExampleShared.shared.formData, completion: { result in
                    SVProgressHUD.dismiss()
                    
                    switch result {
                        
                    case .success(let response):
                        
                        
                        //if response.success == true,
                          // let decision = response.decision,
                           //let jwt = response.jwt {
                        
                        var myResponse: [String: Any]?
                        
                        myResponse = response.rawJSON
                        
                        if let decision = myResponse?["decision"] {
                            
                            //self.instntDidSubmitSuccess(decision: , jwt: "")
                            
                            self.instntDidSubmitSuccess(decision: decision as! String, jwt: "")
                            
                        } else {
                            print("response - \(response)")
                            if let msg = response.decision {
                                //self.instntDidSubmitFailure(error: InstntError(errorConstant: .error_FORM_SUBMIT, message: msg))
                                self.vc?.showSimpleAlert(msg, target: vc)
                                
                            } else {
                                self.instntDidSubmitFailure(error: InstntError(errorConstant: .error_FORM_SUBMIT))
                            }
                            
                        }
                    case .failure(let error):
                        self.instntDidSubmitFailure(error: error)
                    }
                   
                })
                 
            })
            self.vc?.stackView.addOptionalArrangedSubview(buttonView)
        
        
    }

}

