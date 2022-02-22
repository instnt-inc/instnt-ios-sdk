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
    var isFarSelfie: Bool? = false
    var isAutoUpload: Bool? = true
    let licenseKey = "AwG5mCdqXkmCj9oNEpGV8UauciP8s4cqFT848FfjUjwAZQJfa8ZvrEpmYsPME0RTo/Q0kRowDCGz7HPhfSdyeE7rOLtB3JAhuABdQ2R7dGhVy2EUdt5ENQBBIoveIZdf1pwVY2EUgDoGm8REDU+rr2C2"
    
    @IBOutlet private var driverLicenceBtn: UIButton! {
        didSet{
            driverLicenceBtn.tintColor = .black
            driverLicenceBtn.setImage(UIImage(named:"circle_radio_unselected"), for: .normal)
            driverLicenceBtn.setImage(UIImage(named:"circle_radio_selected"), for: .selected)
        }
    }
    
    @IBOutlet private var passportBtn: UIButton! {
        didSet{
            passportBtn.tintColor = .black
            passportBtn.setImage(UIImage(named:"circle_radio_unselected"), for: .normal)
            passportBtn.setImage(UIImage(named:"circle_radio_selected"), for: .selected)
        }
    }


    @IBOutlet weak var docView: UIView!
    
    lazy var buttonView: ButtonView? = {
        guard let view = Utils.getViewFromNib(name: "ButtonView") as? ButtonView  else {
            return nil
        }
        return view
    }()
    
    lazy var switchView: SwitchView? = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackView.addSpacerView()
        addFarSelfieSwitch()
        addAutoUploadSwitch()
        addNextButton()
        Instnt.shared.delegate = self
    }
    
    private func addNextButton() {
        self.stackView.addSpacerView()
        buttonView?.decorateView(type: .next, completion: {
            let documentSettings = DocumentSettings(documentType: .license, documentSide: .front, captureMode: .manual, isAutoUpload: self.isAutoUpload ?? true)
            guard let transactionID = ExampleShared.shared.transactionID else {
                self.instntDidSubmitFailure(error: InstntError(errorConstant: .error_INVALID_TRANSACTION_ID))
                return
            }
            Instnt.shared.scanDocument(transactionID: transactionID, licenseKey: self.licenseKey, from: self, settings: documentSettings, isAutoUpload: self.isAutoUpload ?? true)
        })
        self.stackView.addOptionalArrangedSubview(buttonView)
    }
    
    private func addFarSelfieSwitch() {
        switchView?.decorateView(title: "Far Selfie", completion: { isOn in
            self.isFarSelfie = isOn
        })
        switchView?.uiswitch.isOn = false
        self.stackView.addOptionalArrangedSubview(switchView)
    }
    
    private func addAutoUploadSwitch() {
        switchView?.decorateView(title: "Auto Upload", completion: { isOn in
            self.isAutoUpload = isOn
        })
        switchView?.uiswitch.isOn = true
        self.stackView.addOptionalArrangedSubview(switchView)
    }
    
    func uncheck(){
        driverLicenceBtn.isSelected = false
        passportBtn.isSelected = false
    }
    
    @IBAction private func onClickLicence(_ sender: UIButton){
        uncheck()
        sender.checkboxAnimation {
            print(sender.titleLabel?.text ?? "")
            print(sender.isSelected)
        }
    }
    
    @IBAction private func onClickPassport(_ sender: UIButton){
        uncheck()
        sender.checkboxAnimation {
            print(sender.titleLabel?.text ?? "")
            print(sender.isSelected)
        }
    }
    func instntDocumentVerified() {
        self.showSimpleAlert("Document was uploaded successfully, please submit now", target: self)
        self.buttonView?.decorateView(type: .submitForm, completion: {
            SVProgressHUD.show()
            guard let transactionID = ExampleShared.shared.transactionID else {
                self.instntDidSubmitFailure(error: InstntError(errorConstant: .error_INVALID_TRANSACTION_ID))
                return
            }
            Instnt.shared.submitData(transactionID: transactionID, data: ExampleShared.shared.formData, completion: { result in
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
    }
    
    func instntDocumentScanError() {
        self.showSimpleAlert("Document scan failed, please try again later", target: self, completed: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func instntDidSubmitSuccess(decision: String, jwt: String) {
        print("instntDidSubmitSuccess")
        self.showSimpleAlert("Form is submitted and decision is \(decision)", target: self, completed: {
            guard let nvc = Utils.getStoryboardInitialViewController("CustomForm") as? UINavigationController else {
                return
            }
            guard let vc = nvc.viewControllers.first else {
                return
            }
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    func instntDidSubmitFailure(error: InstntError) {
        print("instntDidSubmitFailure")
        self.showSimpleAlert("Form submission is failed with error: \(error.message ?? "")", target: self, completed: {
//            guard let nvc = Utils.getStoryboardInitialViewController("CustomForm") as? UINavigationController else {
//                return
//            }
//            guard let vc = nvc.viewControllers.first else {
//                return
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
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
    
    private func verifyDocument() {
        guard let transactionID = ExampleShared.shared.transactionID else {
            self.showSimpleAlert("Invalid transacation ID, please try again later.", target: self, completed: {
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        Instnt.shared.verifyDocuments(transactionID: transactionID, completion: { result in
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
        } else if imageResult.documentSide == .front {
            DispatchQueue.main.async {
                let documentSettings = DocumentSettings(documentType: .license, documentSide: .back, captureMode: .manual, isAutoUpload: self.isAutoUpload ?? true)
                Instnt.shared.scanDocument(transactionID: transactionID,  licenseKey: self.licenseKey, from: self, settings: documentSettings, isAutoUpload: self.isAutoUpload ?? true)
            }
        } else if imageResult.documentSide == .back {
            DispatchQueue.main.async {
                Instnt.shared.scanSelfie(from: self, transactionID: transactionID, farSelfie: self.isFarSelfie ?? false, isAutoUpload: self.isAutoUpload ?? true)
            }
        }
    }
   
    
    func onSelfieScanFinish(captureResult: CaptureSelfieResult) {
        guard let transactionID = ExampleShared.shared.transactionID else {
            self.showSimpleAlert("Invalid transacation ID, please try again later.", target: self, completed: {
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        if captureResult.isAutoUpload == true {
            return
        }
        SVProgressHUD.show()
        
        Instnt.shared.uploadAttachment(transactionID: transactionID, data: captureResult.selfieData, completion: { result in
            switch result {
            case .success(_):
                if captureResult.farSelfieData != nil {
                    Instnt.shared.uploadAttachment(transactionID: transactionID, data: captureResult.selfieData, isFarSelfieData: true, completion:  { result in
                        switch result {
                        case .success():
                            self.verifyDocument()
                        case .failure(let error):
                            SVProgressHUD.dismiss()
                            print("uploadAttachment error \(error.localizedDescription)")
                            self.instntDocumentScanError()
                        }
                    })
                } else {
                    self.verifyDocument()
                }
                
            case .failure(let error):
                SVProgressHUD.dismiss()
                print("uploadAttachment error \(error.localizedDescription)")
                self.instntDocumentScanError()
            }
        })
    }
    
    func onSelfieScanCancelled() {
        self.showSimpleAlert("Selfie scan failed, please try again later", target: self, completed: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func onSelfieScanError(error: InstntError) {
        self.showSimpleAlert(error.message ?? "Selfie scan cancelled, please try again later", target: self, completed: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    
    func onDocumentScanFinish(captureResult: CaptureResult) {
        if captureResult.isAutoUpload == true {
            return
        }
        SVProgressHUD.show()
        guard let transactionID = ExampleShared.shared.transactionID else {
            self.showSimpleAlert("Invalid transacation ID, please try again later.", target: self, completed: {
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        Instnt.shared.uploadAttachment(transactionID: transactionID, data: captureResult.resultBase64, completion: { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(_):
                if captureResult.documentSide == .front {
                    DispatchQueue.main.async {
                        let documentSettings = DocumentSettings(documentType: .license, documentSide: .back, captureMode: .manual, isAutoUpload: self.isAutoUpload ?? true)
                        Instnt.shared.scanDocument(transactionID: transactionID, licenseKey: self.licenseKey, from: self, settings: documentSettings, isAutoUpload: self.isAutoUpload ?? true)
                    }
                } else if captureResult.documentSide == .back {
                    DispatchQueue.main.async {
                        Instnt.shared.scanSelfie(from: self, transactionID: transactionID, farSelfie: self.isFarSelfie ?? false, isAutoUpload: self.isAutoUpload ?? true)
                    }

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
    
    func onDocumentScanCancelled(error: InstntError) {
        self.showSimpleAlert(error.localizedDescription, target: self, completed: {
            self.navigationController?.popViewController(animated: true)
        })
    }
}
