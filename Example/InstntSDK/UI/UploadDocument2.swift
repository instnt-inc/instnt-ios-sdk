//
//  UploadDocument2.swift
//  InstntSDK_Example
//
//  Created by Jagruti Patel CW on 6/23/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import InstntSDK
import SVProgressHUD
import UIKit

class UploadDocument2: BaseViewController {
    
    let licenseKey = "AwF9un9folYArdZfq8gZ3dwNUARG9lop7ljR7ogi+5LzH5zJt0/xytKk3Le/P7fLai/SnAbdX4fso8jHlsb0VO+C5zNdwL3R8x6tZgf+31ZLe8vZ8/ivGjOLKsIKMsvZRo1kSUoWw7Pq5OUfdE40Q2aq"
    
    var documentType: DocumentType = .license
    var isAutoCapture: Bool = false
    
    var isSelfie: Bool = false
    var isFarSelfie: Bool = false
    var licenseFront: ImageButtonView?
    var licenseBack: ImageButtonView?
    var passport: ImageButtonView?
    var selfieImage: ImageButtonView?
    var farSelfieImage: ImageButtonView?
    
    var licenceFrontCapture: CaptureResult?
    var licenceBackCapture: CaptureResult?
    var passportCapture: CaptureResult?
    var selfieCapture: CaptureSelfieResult?
    var farSelfieCapture: CaptureSelfieResult?
    
    var licenceFrontUpload: Bool = false
    var licenceBackUpload: Bool = false
    var passportUpload: Bool = false
    var selfieUpload: Bool = false
    var farSelfieUpload: Bool = false
    
    
    var transactionID: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ExampleShared.shared.transactionID = "2b58f07e-d34c-49c8-ae39-ec98c06ab5ce"
        guard let transactionID = ExampleShared.shared.transactionID else {
            self.showSimpleAlert("Invalid transacation ID, please try again later.", target: self, completed: {
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        
        self.transactionID = transactionID
        Instnt.shared.delegate = self
        addImages()
    }
    
    lazy var buttonView: ButtonView? = {
        guard let view = Utils.getViewFromNib(name: "ButtonView") as? ButtonView  else {
            return nil
        }
        return view
    }()
    
    private func addImages() {
        if documentType == .license {
            addLicenceFront()
            addLicenceBack()
        } else {
            addPassportImage()
        }
        if isSelfie == true {
            addSelfieImage()
        }
        if isFarSelfie == true {
            addFarSelfie()
        }
    }
    private func addLicenceFront() {
        guard let licenseFront = Utils.getViewFromNib(name: "ImageButtonView") as? ImageButtonView  else {
            return
        }
        licenseFront.btnScan.setTitle("Scan front image", for: .normal)
        licenseFront.scanCompletionBlock = {
            licenseFront.btnImageUpload.isHidden = true
            licenseFront.imageView.image = nil
            self.licenceFrontCapture = nil
            self.licenceFrontUpload = false
            let documentSettings = DocumentSettings(documentType: self.documentType, documentSide: .front, captureMode: self.isAutoCapture ? .auto: .manual, isAutoUpload: false)
            Instnt.shared.scanDocument(instnttxnid: self.transactionID, licenseKey: self.licenseKey, from: self, settings: documentSettings, isAutoUpload: false)
        }
        licenseFront.uploadCompletionBlock = {
            guard let captureData = self.licenceFrontCapture?.resultBase64 else {
                return
            }
            SVProgressHUD.show()
            Instnt.shared.uploadAttachment(instnttxnid: self.transactionID, data: captureData, isSelfie: false, isFront: true, documentType: .license, completion: { result in
                SVProgressHUD.dismiss()
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.licenceFrontUpload = true
                        licenseFront.btnImageUpload.setImage(UIImage(named: "icons-check-mark"), for: .normal)
                        if self.licenceBackUpload != true {
                            return
                        }
                        self.selfieCheckForSubmitButton()
                    }
                case .failure(let error):
                    print("uploadAttachment error \(String(describing: error.message))")
                    DispatchQueue.main.async {
                        self.showSimpleAlert(error.localizedDescription, target: self, completed: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                    
                }
            })
        }
        self.licenseFront = licenseFront
        self.stackView.addOptionalArrangedSubview(self.licenseFront!)
    }
    private func addLicenceBack() {
        guard let licenseBack = Utils.getViewFromNib(name: "ImageButtonView") as? ImageButtonView  else {
            return
        }
        licenseBack.btnScan.setTitle("Scan back image", for: .normal)
        licenseBack.scanCompletionBlock = {
            licenseBack.btnImageUpload.isHidden = true
            licenseBack.imageView.image = nil
            self.licenceBackCapture = nil
            self.licenceBackUpload = false
            let documentSettings = DocumentSettings(documentType: .license, documentSide: .back, captureMode: self.isAutoCapture ? .auto: .manual, isAutoUpload: false)
            Instnt.shared.scanDocument(instnttxnid: self.transactionID, licenseKey: self.licenseKey, from: self, settings: documentSettings, isAutoUpload: false)
        }
        licenseBack.uploadCompletionBlock = {
            guard let captureData = self.licenceBackCapture?.resultBase64 else {
                return
            }
            SVProgressHUD.show()
            Instnt.shared.uploadAttachment(instnttxnid: self.transactionID, data: captureData, isSelfie: false, isFront: false, documentType: self.documentType, completion: { result in
                SVProgressHUD.dismiss()
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.licenceBackUpload = true
                        licenseBack.btnImageUpload.setImage(UIImage(named: "icons-check-mark"), for: .normal)
                        if self.licenceFrontUpload != true {
                            return
                        }
                        self.selfieCheckForSubmitButton()
                    }
                case .failure(let error):
                    print("uploadAttachment error \(String(describing: error.message))")
                    DispatchQueue.main.async {
                        self.showSimpleAlert(error.localizedDescription, target: self, completed: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                    
                }
            })
            
        }
        self.licenseBack = licenseBack
        self.stackView.addOptionalArrangedSubview(self.licenseBack!)
    }
    private func addPassportImage() {
        guard let passport = Utils.getViewFromNib(name: "ImageButtonView") as? ImageButtonView  else {
            return
        }
        passport.btnScan.setTitle("Scan passport image", for: .normal)
        passport.scanCompletionBlock = {
            passport.btnImageUpload.isHidden = true
            passport.imageView.image = nil
            self.passportCapture = nil
            self.passportUpload = false
            let documentSettings = DocumentSettings(documentType: self.documentType, documentSide: .back, captureMode: self.isAutoCapture ? .auto: .manual, isAutoUpload: false)
            Instnt.shared.scanDocument(instnttxnid: self.transactionID, licenseKey: self.licenseKey, from: self, settings: documentSettings, isAutoUpload: false)
        }
        passport.uploadCompletionBlock = {
            guard let captureData = self.licenceBackCapture?.resultBase64 else {
                return
            }
            SVProgressHUD.show()
            Instnt.shared.uploadAttachment(instnttxnid: self.transactionID, data: captureData, isSelfie: false, isFront: true, documentType: .passport, completion: { result in
                SVProgressHUD.dismiss()
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.passportUpload = true
                        passport.btnImageUpload.setImage(UIImage(named: "icons-check-mark"), for: .normal)
                        self.selfieCheckForSubmitButton()
                    }
                case .failure(let error):
                    print("uploadAttachment error \(String(describing: error.message))")
                    DispatchQueue.main.async {
                        self.showSimpleAlert(error.localizedDescription, target: self, completed: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                }
            })
        }
        self.passport = passport
        self.stackView.addOptionalArrangedSubview(self.passport!)
    }
    
    func addSelfieImage() {
        guard let selfieImage = Utils.getViewFromNib(name: "ImageButtonView") as? ImageButtonView  else {
            return
        }
        selfieImage.btnScan.setTitle("Scan selfie image", for: .normal)
        selfieImage.scanCompletionBlock = {
            selfieImage.btnImageUpload.isHidden = true
            selfieImage.imageView.image = nil
            self.selfieCapture = nil
            self.selfieUpload = false
            self.farSelfieImage?.imageView.image = nil
            self.farSelfieCapture = nil
            self.farSelfieUpload = false
            let settings = SelfieSettings(isFarSelfie: self.isFarSelfie, isAutoCapture: false, isAutoUpload: false)
            Instnt.shared.scanSelfie(from: self, instnttxnid: self.transactionID, settings: settings)
        }
        selfieImage.uploadCompletionBlock = {
            guard let captureData = self.selfieCapture?.selfieData else {
                return
            }
            SVProgressHUD.show()
            Instnt.shared.uploadAttachment(instnttxnid: self.transactionID, data: captureData, isSelfie: true, isFront: false, completion: { result in
                SVProgressHUD.dismiss()
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.selfieUpload = true
                        selfieImage.btnImageUpload.setImage(UIImage(named: "icons-check-mark"), for: .normal)
                        if self.documentType == .passport {
                            if self.passportUpload == false {
                                return
                            }
                        } else {
                            if !(self.licenceFrontUpload == true && self.licenceBackUpload == true) {
                                return
                            }
                        }
                        self.selfieCheckForSubmitButton()
                    }
                case .failure(let error):
                    print("uploadAttachment error \(error.localizedDescription)")
                    self.instntDocumentScanError()
                }
            })
        }
        self.selfieImage = selfieImage
        self.stackView.addOptionalArrangedSubview(self.selfieImage!)
    }
    
    func addFarSelfie() {
        guard let farSelfieImage = Utils.getViewFromNib(name: "ImageButtonView") as? ImageButtonView  else {
            return
        }
        farSelfieImage.btnScan.setTitle("", for: .normal)
        farSelfieImage.scanCompletionBlock = nil
        farSelfieImage.uploadCompletionBlock = {
            guard let captureData = self.farSelfieCapture?.farSelfieData else {
                return
            }
            SVProgressHUD.show()
            Instnt.shared.uploadAttachment(instnttxnid: self.transactionID, data: captureData, isSelfie: true, isFront: false, completion: { result in
                SVProgressHUD.dismiss()
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.farSelfieUpload = true
                        farSelfieImage.btnImageUpload.setImage(UIImage(named: "icons-check-mark"), for: .normal)
                        if self.documentType == .passport {
                            if self.passportUpload == false {
                                return
                            }
                        } else {
                            if !(self.licenceFrontUpload == true && self.licenceBackUpload == true) {
                                return
                            }
                        }
                        self.selfieCheckForSubmitButton()
                    }
                case .failure(let error):
                    print("uploadAttachment error \(error.localizedDescription)")
                    self.instntDocumentScanError()
                }
            })
        }
        self.farSelfieImage = farSelfieImage
        self.stackView.addOptionalArrangedSubview(self.farSelfieImage!)
    }
    
    
    func instntDocumentVerified() {
        self.showSimpleAlert("Document was uploaded successfully, please submit now", target: self)
        buttonView?.decorateView(type: .submitForm, completion:  {
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
    
    private func instntDidSubmitFailure(error: InstntError) {
        print("instntDidSubmitFailure")
        self.showSimpleAlert("Form submission is failed with error: \(error.message ?? "")", target: self, completed: {
        })
    }
    
    private func instntDidSubmitSuccess(decision: String, jwt: String) {
        print("instntDidSubmitSuccess")
        self.showSimpleAlert("Form is submitted and decision is \(decision)", target: self, completed: {
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    func instntDocumentScanError() {
        self.showSimpleAlert("Document scan was failed, please try again", target: self)
    }
    func addSubmitButton() {
        buttonView?.decorateView(type: .verify, completion: {
            if self.documentType == .license {
                self.verifyDocument()
            }
        })
        self.stackView.addOptionalArrangedSubview(buttonView)
    }
    
    private func selfieCheckForSubmitButton() {
        if self.isSelfie == true {
            if self.isFarSelfie == true {
                if self.farSelfieUpload == true && self.selfieUpload {
                    self.addSubmitButton()
                }
            } else {
                if self.selfieUpload == true {
                    self.addSubmitButton()
                }
            }
        } else {
            self.addSubmitButton()
        }
    }
    
}

extension UploadDocument2: InstntDelegate {
    
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
                let settings = SelfieSettings(isFarSelfie: self.isFarSelfie, isAutoCapture: self.isAutoCapture, isAutoUpload: false)
                if self.isSelfie {
                    Instnt.shared.scanSelfie(from: self, instnttxnid: transactionID, settings: settings)
                } else {
                    self.verifyDocument()
                }
            }
        } else if imageResult.documentSide == .front {
            DispatchQueue.main.async {
                let documentSettings = DocumentSettings(documentType: .license, documentSide: .back, captureMode: self.isAutoCapture ? .auto: .manual, isAutoUpload: false)
                Instnt.shared.scanDocument(instnttxnid: transactionID,  licenseKey: self.licenseKey, from: self, settings: documentSettings, isAutoUpload: false)
            }
        } else if imageResult.documentSide == .back {
            DispatchQueue.main.async {
                let settings = SelfieSettings(isFarSelfie: self.isFarSelfie, isAutoCapture: self.isAutoCapture, isAutoUpload: false)
                if self.isSelfie {
                    Instnt.shared.scanSelfie(from: self, instnttxnid: transactionID, settings: settings)
                } else {
                    self.verifyDocument()
                }
            }
        }
    }
   
    
    func onSelfieScanFinish(captureResult: CaptureSelfieResult) {
        if let selfieCapture = captureResult.farSelfieData {
            let image = UIImage(data: selfieCapture)
            farSelfieImage?.imageView.image = image
            farSelfieImage?.btnImageUpload.setImage(UIImage(named: "icon-upload"), for: .normal)
            farSelfieImage?.btnImageUpload.isHidden = false
            farSelfieCapture = captureResult
        }
        let image = UIImage(data: captureResult.selfieData)
        selfieImage?.imageView.image = image
        selfieImage?.btnImageUpload.setImage(UIImage(named: "icon-upload"), for: .normal)
        selfieImage?.btnImageUpload.isHidden = false
        selfieCapture = captureResult
    }

    func onSelfieScanCancelled() {
        self.showSimpleAlert("Selfie scan failed, please try again later", target: self, completed: {

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
    
    
    func onDocumentScanFinish(captureResult: CaptureResult) {
        if captureResult.documentType == .license {
            let image = UIImage(data: captureResult.resultBase64)
            if captureResult.documentSide == .front {
                licenseFront?.imageView.image = image
                licenseFront?.btnImageUpload.setImage(UIImage(named: "icon-upload"), for: .normal)
                licenseFront?.btnImageUpload.isHidden = false
                licenceFrontCapture = captureResult
            } else {
                licenseBack?.imageView.image = image
                licenseBack?.btnImageUpload.setImage(UIImage(named: "icon-upload"), for: .normal)
                licenseBack?.btnImageUpload.isHidden = false
                licenceBackCapture = captureResult
            }
        } else if captureResult.documentType == .passport {
            let image = UIImage(data: captureResult.resultBase64)
            passport?.imageView.image = image
            licenseFront?.btnImageUpload.setImage(UIImage(named: "icon-upload"), for: .normal)
            passport?.btnImageUpload.isHidden = false
            passportCapture = captureResult
        }
        self.view.layoutIfNeeded()
    }
    
    func onDocumentScanCancelled(error: InstntError) {
        self.showSimpleAlert(error.message ?? "Document scan cancelled, please try again later", target: self, completed: {
            
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
