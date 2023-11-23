//
//  SelectDocTypeVCViewController.swift
//  InstntSDK_Example
//
//  Created by Vipul Dungranee on 14/03/22.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import InstntSDK
import SVProgressHUD



class SelectSignUpTypeVC: BaseViewController {
    
    var signUPType: SignUPType = .signup
    var isAutoUpload: Bool? = true
    
    @IBOutlet weak var formIDFld: UITextField! {
        didSet {
            formIDFld.text = "v1679308618983151"
            formIDFld.accessibilityIdentifier = "formID"
        }
    }
    
    @IBOutlet weak var endPointFld: UITextField! {
        didSet {
            endPointFld.text = "https://dev2-api.instnt.org/public"
            endPointFld.accessibilityLabel = "endpoint"
            endPointFld.accessibilityIdentifier = "endpoint"
        }
    }
    
    @IBOutlet private var signUpBtn: UIButton! {
        didSet{
            signUpBtn.tintColor = .black
            signUpBtn.setImage(UIImage(named:"circle_radio_unselected"), for: .normal)
            signUpBtn.setImage(UIImage(named:"circle_radio_selected"), for: .selected)
        }
    }
    
    @IBOutlet private var resumeSignUpBtn: UIButton! {
        didSet{
            resumeSignUpBtn.tintColor = .black
            resumeSignUpBtn.setImage(UIImage(named:"circle_radio_unselected"), for: .normal)
            resumeSignUpBtn.setImage(UIImage(named:"circle_radio_selected"), for: .selected)
        }
    }
    
    
    @IBOutlet weak var doHandshakeBtn: UIButton! {
        didSet{
            doHandshakeBtn.tintColor = .black
            doHandshakeBtn.setImage(UIImage(named:"circle_radio_unselected"), for: .normal)
            doHandshakeBtn.setImage(UIImage(named:"circle_radio_selected"), for: .selected)
        }
    }
    
    lazy var buttonView: ButtonView? = {
        guard let view = Utils.getViewFromNib(name: "ButtonView") as? ButtonView  else {
            return nil
        }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackView.addSpacerView()
        print("store signup type  : \(SignUpManager.shared.type.name)")
        //making signUpBtn initially selecte
        signUpBtn.isSelected = true
        SignUpManager.shared.signUpType = signUPType.rawValue
        addNextButton()
    }
    
    private func addNextButton() {
        self.stackView.addSpacerView()
        buttonView?.decorateView(type: .next, completion: { [weak self] in
            SignUpManager.shared.signUpType = self?.signUPType.rawValue ?? 0
            self?.redirectToNextScreen()
                        
        })
        buttonView?.button.accessibilityIdentifier = "nextBtnHome"
        self.stackView.addOptionalArrangedSubview(buttonView)
    }
    
    func uncheck(){
        signUpBtn.isSelected = false
        resumeSignUpBtn.isSelected = false
        doHandshakeBtn.isSelected = false
    }
    
    @IBAction private func onClickSignUp(_ sender: UIButton){
        uncheck()
        
        signUPType = .signup
        sender.checkboxAnimation {
            print(sender.titleLabel?.text ?? "")
            print(sender.isSelected)
        }
    }
    
    @IBAction private func onClickResumeSignUp(_ sender: UIButton){
        
        signUPType = .resumeSignUp

        uncheck()
        sender.checkboxAnimation {
            print(sender.titleLabel?.text ?? "")
            print(sender.isSelected)
        }
    }
    
    @IBAction func onClickDoHandShakeBtn(_ sender: UIButton) {
        
        signUPType = .doHandShake

        uncheck()
        sender.checkboxAnimation {
            print(sender.titleLabel?.text ?? "")
            print(sender.isSelected)
        }

    }
    
    func redirectToNextScreen() {
        print("redirectToNextScreen")
        
        ExampleShared.shared.formData = [:]
        
        UserDefaults.standard.set(self.endPointFld.text, forKey: "end_point")
        
        UserDefaults.standard.set(self.formIDFld.text, forKey: "form_key")
        
        if signUPType == .doHandShake {
            
            guard let text = endPointFld.text, !text.isEmpty else {
                self.showSimpleAlert("Enter end point", target: self)
                return
            }
            
            guard let vc = Utils.getStoryboardInitialViewController("Login") as? LoginVC else {
                return
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if signUPType == .signup {
            
            if let formKey = self.formIDFld.text {
                SVProgressHUD.show()
                ExampleShared.shared.transactionID = nil

            
            Instnt.shared.setup(with: formKey, endPOint: self.endPointFld?.text ?? "", completion: { result in
                SVProgressHUD.dismiss()
                switch result {
                case .success(let transactionID):
                    print("transactionID : \(transactionID)")
                    ExampleShared.shared.transactionID = transactionID
                    //self.addResponse()
                    self.gotoFirstName()
                    //self.lblView?.lblText.text = "Set up is succeded with transaction Id \(transactionID)"
                case .failure(let error):
                    print("error - \(error)")
                    
                    let errorMsg = "Setup is failed due to error - \(error.message ?? "Failed")"
                    
                    let alert = UIAlertController(title: "Failed", message: errorMsg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    //self.addResponse()
                    //self.lblView?.lblText.text = "Set up is failed with \(error.message ?? ""), please try again later"
                }
            })
                
            }
            
        } else {
            
            guard let vc = Utils.getStoryboardInitialViewController("CustomForm") as? CustomFormViewController else {
                return
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
    private func gotoFirstName() {
        guard let vc = Utils.getStoryboardInitialViewController("FirstLastName") as? FirstLastNameVC else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

enum SignUPType : Int  {
    case notDefined = 0
    case signup = 1
    case resumeSignUp = 2
    case doHandShake = 3
    
    var name: String {
        switch self {
        case .notDefined:
            return "notDefined"
        case .signup:
            return "Signup"
        case .resumeSignUp:
            return "Resume signup"
        case .doHandShake:
            return "Do handshake"
        }
    }
}
