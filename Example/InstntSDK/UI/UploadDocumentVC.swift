//
//  SelectDocTypeVCViewController.swift
//  InstntSDK_Example
//
//  Created by Sanjeev Mehta on 28/12/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import InstntSDK
import SVProgressHUD


class UploadDocumentVC: BaseViewController {
    var isFarSelfie: Bool = false
    var isSelfie: Bool = false
    var isAutoUpload: Bool = true
    var isAutoCapture: Bool = false
    let licenseKey = "AwF9un9folYArdZfq8gZ3dwNUARG9lop7ljR7ogi+5LzH5zJt0/xytKk3Le/P7fLai/SnAbdX4fso8jHlsb0VO+C5zNdwL3R8x6tZgf+31ZLe8vZ8/ivGjOLKsIKMsvZRo1kSUoWw7Pq5OUfdE40Q2aq"
    var documentType: DocumentType?
    
    lazy var titleView: LabelView? = {
        guard let view = Utils.getViewFromNib(name: "LabelView") as? LabelView  else {
            return nil
        }
        view.lblText.text = "Choose the document type"
        return view
    }()
    
    
    lazy var subTitleView: LabelView? = {
        guard let view = Utils.getViewFromNib(name: "LabelView") as? LabelView  else {
            return nil
        }
        view.lblText.text = "As an added layer of security , we need to verify your identity before approving your application."
        return view
    }()
    
    lazy var driverLicenceBtn: RadioButton? = {
        guard let view = Utils.getViewFromNib(name: "RadioButton") as? RadioButton  else {
            return nil
        }
        view.btnSelect.isSelected = true
        view.completionBlock = {
            self.uncheck()
            view.btnSelect.checkboxAnimation {
                self.documentType = .license
            }
        }
        return view
    }()
    
    lazy var passportBtn: RadioButton? = {
        guard let view = Utils.getViewFromNib(name: "RadioButton") as? RadioButton  else {
            return nil
        }
        view.completionBlock = {
            self.uncheck()
            view.btnSelect.checkboxAnimation {
                self.documentType = .license
            }
        }
        return view
    }()
    
    lazy var buttonView: ButtonView? = {
        guard let view = Utils.getViewFromNib(name: "ButtonView") as? ButtonView  else {
            return nil
        }
        return view
    }()

    lazy var isSelfieSwitchView: SwitchView? = {
        guard let view = Utils.getViewFromNib(name: "SwitchView") as? SwitchView  else {
            return nil
        }
        return view
    }()
    
    lazy var isFarSelfieSwitchView: SwitchView? = {
        guard let view = Utils.getViewFromNib(name: "SwitchView") as? SwitchView  else {
            return nil
        }
        return view
    }()
    
    lazy var autoUploadSwitchView: SwitchView? = {
        guard let view = Utils.getViewFromNib(name: "SwitchView") as? SwitchView  else {
            return nil
        }
        return view
    }()
    
    lazy var autoCaptureSwitchView: SwitchView? = {
        guard let view = Utils.getViewFromNib(name: "SwitchView") as? SwitchView  else {
            return nil
        }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackView.addSpacerView()
        addTitle()
        self.stackView.addSpacerView()
        addSubtitle()
        self.stackView.addSpacerView()
        addDriverLicenceBtn()
        addPassportButton()
        self.stackView.addSpacerView()
        addSelfieSwitch()
        addFarSelfieSwitch()
        addAutoUploadSwitch()
        addCaptureSwitch()
        addNextButton()
        self.stackView.addSpacerView(height: 100)
        
        Instnt.shared.delegate = self
    }
    
    private func addTitle() {
        self.stackView.addOptionalArrangedSubview(titleView)
        
    }
    
    private func addSubtitle() {

        self.stackView.addOptionalArrangedSubview(subTitleView)
        
    }
    private func addDriverLicenceBtn() {
        driverLicenceBtn?.lblTitle.text = "Driver's License"
        self.stackView.addOptionalArrangedSubview(driverLicenceBtn)
        
    }
    
    private func addPassportButton() {
        passportBtn?.lblTitle.text = "Passport"
        self.stackView.addOptionalArrangedSubview(passportBtn)
    }
    
    private func addNextButton() {
        self.stackView.addSpacerView()
        buttonView?.decorateView(type: .next, completion: {
            if self.isAutoUpload {
                let documentSettings = DocumentSettings(documentType: self.documentType ?? .license, documentSide: .front, captureMode: self.isAutoCapture ? .auto: .manual, isAutoUpload: self.isAutoUpload)
                guard let transactionID = ExampleShared.shared.transactionID else {
                    self.instntDidSubmitFailure(error: InstntError(errorConstant: .error_INVALID_TRANSACTION_ID))
                    return
                }
                self.autoUploadSwitchView?.isHidden = true
                self.autoCaptureSwitchView?.isHidden = true
                self.isFarSelfieSwitchView?.isHidden = true
                self.isSelfieSwitchView?.isHidden = true

                Instnt.shared.scanDocument(instnttxnid: transactionID, licenseKey: self.licenseKey, from: self, settings: documentSettings, isAutoUpload: self.isAutoUpload)
            } else {
                guard  let uploadDocFinal = Utils.getStoryboardInitialViewController("UploadDocument2") as? UploadDocument2 else {
                    return
                }
                self.navigationController?.pushViewController(uploadDocFinal, animated: true)
            }
           
        })
        buttonView?.button.accessibilityIdentifier = "signupSubmit"
        self.stackView.addOptionalArrangedSubview(buttonView)
    }
    
    private func addFarSelfieSwitch() {
        isFarSelfieSwitchView?.decorateView(title: "Far Selfie", completion: { isOn in
            self.isFarSelfie = isOn
        })
        isFarSelfieSwitchView?.uiswitch.isOn = isFarSelfie
        self.stackView.addOptionalArrangedSubview(isFarSelfieSwitchView)
    }
    
    private func addSelfieSwitch() {
        isSelfieSwitchView?.decorateView(title: "Selfie", completion: { isOn in
            if !isOn {
                self.isFarSelfieSwitchView?.uiswitch.isOn = false
            }
            self.isSelfie = isOn
        })
        isSelfieSwitchView?.uiswitch.isOn = isSelfie
        self.stackView.addOptionalArrangedSubview(isSelfieSwitchView)
    }
    
    
    private func addAutoUploadSwitch() {
        autoUploadSwitchView?.decorateView(title: "Auto Upload", completion: { isOn in
            self.isAutoUpload = isOn
        })
        autoUploadSwitchView?.uiswitch.isOn = isAutoUpload
        self.stackView.addOptionalArrangedSubview(autoUploadSwitchView)
    }
    
    private func addCaptureSwitch() {
        autoCaptureSwitchView?.decorateView(title: "Auto Capture", completion: { isOn in
            self.isAutoCapture = isOn
        })
        autoCaptureSwitchView?.uiswitch.isOn = isAutoCapture
        self.stackView.addOptionalArrangedSubview(autoCaptureSwitchView)
    }
    
    func uncheck(){
        driverLicenceBtn?.btnSelect.isSelected = false
        passportBtn?.btnSelect.isSelected = false
    }
    
    private func instntDocumentVerified() {
        self.showSimpleAlert("Document was uploaded successfully, please submit now", target: self)
        self.buttonView?.decorateView(type: .submitForm, completion: {
            SVProgressHUD.show()
            guard let transactionID = ExampleShared.shared.transactionID else {
                self.instntDidSubmitFailure(error: InstntError(errorConstant: .error_INVALID_TRANSACTION_ID))
                return
            }
            Instnt.shared.submitData(instnttxnid: transactionID, data: ExampleShared.shared.formData, completion: { result in
                SVProgressHUD.dismiss()
                switch result {
                case .success(let response):
                    if response.success == true,
                       let decision = response.decision,
                       let jwt = response.jwt {
                        ExampleShared.shared.formData = [:]
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
    }
    
    private func instntDocumentScanError() {
        self.showSimpleAlert("Document scan failed, please try again later", target: self, completed: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    private func instntDidSubmitSuccess(decision: String, jwt: String) {
        print("instntDidSubmitSuccess")
        self.showSimpleAlert("Form is submitted and decision is \(decision)", target: self, completed: {
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    private func instntDidSubmitFailure(error: InstntError) {
        print("instntDidSubmitFailure")
        self.showSimpleAlert("Form submission is failed with error: \(error.message ?? "")", target: self, completed: {
        })
    }
    

}

extension UIView{
    
    func cardView() -> Void {
         self.layer.cornerRadius = 10
         self.layer.shadowColor = UIColor.gray.cgColor
         self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
         self.layer.shadowRadius = 4.0
         self.layer.shadowOpacity = 0.5
     }
    
}

extension UIButton {
    //MARK:- Animate check mark
    func checkboxAnimation(closure: @escaping () -> Void){
        guard let image = self.imageView else {return}
        self.adjustsImageWhenHighlighted = false
        self.isHighlighted = false
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.isSelected = !self.isSelected
                //to-do
                closure()
                image.transform = .identity
            }, completion: nil)
        }
        
    }
}

extension UploadDocumentVC: InstntDelegate {
    func onDocumentScanFinish(captureResult: CaptureResult) {
        
    }
    
    func onSelfieScanFinish(captureResult: CaptureSelfieResult) {
        
    }
    
    
    private func verifyDocument() {
        guard let transactionID = ExampleShared.shared.transactionID else {
            self.showSimpleAlert("Invalid transacation ID, please try again later.", target: self, completed: {
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        Instnt.shared.verifyDocuments(instnttxnid: transactionID, completion: { result in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.autoUploadSwitchView?.isHidden = true
                self.autoCaptureSwitchView?.isHidden = true
                self.isFarSelfieSwitchView?.isHidden = true
                self.isSelfieSwitchView?.isHidden = true
                switch result {
                case .success():
                    self.instntDocumentVerified()
                case .failure(let error):
                    self.showSimpleAlert("Document verification failed with error: \(error.message ?? "Technical Difficulties")", target: self)
                }
            }
        })
    }
    
    func onDocumentUploaded(imageResult: InstntImageData, error: InstntError?) {
        if error != nil {
            print("uploadAttachment error \(String(describing: error?.message))")
            self.showSimpleAlert(error?.message ?? "Upload Attachment error", target: self, completed: {
                self.navigationController?.popViewController(animated: true)
            })
        }
        guard let transactionID = ExampleShared.shared.transactionID else {
            self.showSimpleAlert("Invalid transacation ID, please try again later.", target: self, completed: {
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        if imageResult.isSelfie == true  {
            self.verifyDocument()
        } else if (self.documentType == .passport) {
            DispatchQueue.main.async {
                let settings = SelfieSettings(isFarSelfie: self.isFarSelfie, isAutoCapture: true, isAutoUpload: self.isAutoUpload)
                if self.isSelfie {
                    Instnt.shared.scanSelfie(from: self, instnttxnid: transactionID, settings: settings)
                } else {
                    self.verifyDocument()
                }
            }
        } else if imageResult.documentSide == .front {
            DispatchQueue.main.async {
                let documentSettings = DocumentSettings(documentType: .license, documentSide: .back, captureMode: self.isAutoCapture ? .auto: .manual, isAutoUpload: self.isAutoUpload)
                Instnt.shared.scanDocument(instnttxnid: transactionID,  licenseKey: self.licenseKey, from: self, settings: documentSettings, isAutoUpload: self.isAutoUpload)
            }
        } else if imageResult.documentSide == .back {
            DispatchQueue.main.async {
                let settings = SelfieSettings(isFarSelfie: self.isFarSelfie, isAutoCapture: self.isAutoCapture, isAutoUpload: self.isAutoUpload)
                if self.isSelfie {
                    Instnt.shared.scanSelfie(from: self, instnttxnid: transactionID, settings: settings)
                } else {
                    self.verifyDocument()
                }
            }
        }
    }
    
    func onSelfieScanCancelled() {
        self.showSimpleAlert("Selfie scan failed, please try again later", target: self, completed: {
            self.autoUploadSwitchView?.isHidden = false
            self.autoCaptureSwitchView?.isHidden = false
            self.isFarSelfieSwitchView?.isHidden = false
            self.isSelfieSwitchView?.isHidden = false
        })
    }
    
    func onSelfieScanError(error: InstntError) {
        self.showSimpleAlert(error.message ?? "Selfie scan cancelled, please try again later", target: self, completed: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func onSelfieScanFailedVerification(error: InstntError) {
        self.showSimpleAlert(error.message ?? "Selfie scan verification failed, please try again later", target: self, completed: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func onDocumentScanCancelled(error: InstntError) {
        self.showSimpleAlert(error.message ?? "Document scan cancelled, please try again later", target: self, completed: {
            self.autoUploadSwitchView?.isHidden = false
            self.autoCaptureSwitchView?.isHidden = false
            self.isFarSelfieSwitchView?.isHidden = false
            self.isSelfieSwitchView?.isHidden = false
            
        })
    }
    
    func onDocumentScanFailedVerification(error: InstntError) {
        self.showSimpleAlert(error.message ?? "Document scan verification failed, please try again later", target: self, completed: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func onDocumentScanError(error: InstntError) {
        self.showSimpleAlert(error.message ?? "Document scan failed, please try again later", target: self, completed: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
}
