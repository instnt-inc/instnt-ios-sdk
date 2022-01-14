//
//  Instnt.swift
//  InstntSDK
//
//  Created by Nate Eckerson on 5/25/21.
//


import UIKit
import SVProgressHUD


@objc public protocol InstntDelegate: NSObjectProtocol {
    func instntDidCancel(_ sender: Instnt)
    func instntDidSubmit(_ sender: Instnt, decision: String, jwt: String)
}

public class Instnt: NSObject {
    public static let decisionTypeAccept = "ACCEPT"
    public static let decisionTypeReject = "REJECT"
    public static let decisionTypeReview = "REVIEW"
    
    public static let shared = Instnt()
    
    private (set) var formId: String = ""
    private (set) var formCodes: FormCodes? = nil
    
    private var isSandbox: Bool {
        return APIClient.shared.isSandbox
    }
    
    public weak var delegate: InstntDelegate? = nil
    public var transactionID: String?
    private var documentType: DocumentType = .licence
    private var documentSide: DocumentSide = .front
    private var parentVC: UIViewController?
    
    private override init() {
        super.init()
        
        formId = ""
        APIClient.shared.isSandbox = true
    }
    
    // conviniece init
    
    // MARK: - Public Function
    public func setup(with formId: String, isSandBox: Bool = false) {
        self.formId = formId
        APIClient.shared.isSandbox = isSandBox
        Instnt.shared.getTransactionID(completion: { result in
        
        })
    }
    
    public func showForm(from viewController: UIViewController, completion: @escaping ((Bool, String?) -> Void)) {
        guard !formId.isEmpty else {
            let message = "Empty Form Id!"
            if Thread.isMainThread {
                completion(false, message)
            } else {
                DispatchQueue.main.async {
                    completion(false, message)
                }
            }
            
            return
        }
        
        APIClient.shared.getFormCodes(with: formId) { [weak self] (formCodes, _, message) in
            if let formCodes = formCodes {
                let formViewController = FormViewController()
                let navigationViewController = UINavigationController(rootViewController: formViewController)
                formViewController.formCodes = formCodes
                formViewController.delegate = self
                viewController.present(navigationViewController, animated: true) {
                    completion(true, nil)
                }
            } else {
                completion(false, message)
            }
        }
    }
    
    // MARK: - Custom Usage
    public func getFormCodes(_ completion: @escaping (([String: Any]?) -> Void)) {
        APIClient.shared.getFormCodes(with: formId) { [weak self] (fromCodes, responseJSON, _) in
            self?.formCodes = fromCodes
            
            completion(responseJSON)
        }
    }
    
    public func submitFormData(_ data: [String: Any], completion: @escaping (([String: Any]?) -> Void)) {
        guard let formCodes = formCodes else {
            if Thread.isMainThread {
                completion(nil)
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            return
        }
        
        var formData: [String: Any] = data
        formData["form_key"] = formCodes.id
        formData["fingerprint"] = [
            "requestId": formCodes.fingerprint,
            "visitorId": formCodes.fingerprint,
            "visitorFound": true
        ]
        formData["client_referer_url"] = formCodes.serviceURL
        formData["client_referer_host"] = URL(string: formCodes.serviceURL)?.host ?? ""
        
        APIClient.shared.submitForm(to: formCodes.submitURL, formData: formData) { (_, responseJSON, _) in
            completion(responseJSON)
        }
    }
    
    public func scanDocument(from vc: UIViewController, documentType: DocumentType) {
        parentVC = vc
        self.documentType = documentType
        let documentSettings = DocumentSettings(documentType: .licence, documentSide: self.documentSide, captureMode: .manual)
        DocumentScan.shared.scanDocument(from: vc, documentSettings: documentSettings, delegate: self)
    }
    
    func getTransactionID(completion: @escaping(Result<String, InstntError>) -> Void) {
        let transactionRequest = CreateTransaction.init(formKey: "v163875646772327", hideFormFields: true, idmetricsVersion: "4.5.0.5", format: "json", redirect: false)
        APIClient.shared.createTransaction(data: transactionRequest, completion: { result in
            switch result {
            case .success(let transactionID):
                self.transactionID = transactionID
                completion(.success(transactionID))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    private func getUploadUrl(completion: @escaping(Result<String, InstntError>) -> Void) {
        let requestGetuploadURL = RequestGetUploadUrl.init(transactionType: "IMAGE", documentType: "DRIVERS_LICENSE", docSuffix: "F", transactionStatus: "NEW");
        if let transactionID = transactionID {
            APIClient.shared.getUploadUrl(transactionId: transactionID, data: requestGetuploadURL, completion: completion)
        }
        
    }
    
    private func uploadDocument(url: String, data: CaptureResult, completion: @escaping(Result<Void, InstntError>) -> Void) {
        APIClient.shared.upload(url: url, data: data, completion: completion)
    }
    
    private func uploadAttachment(data: CaptureResult, completion: @escaping(Result<Void, InstntError>) -> Void) {
        self.getUploadUrl(completion: { result in
            switch result {
            case .success(let url):
                self.uploadDocument(url: url, data: data, completion: { result in
                    completion(.success((())))
                })
            case .failure(_):
                break
            }
            
        })
    }
    
    public func sendOTP(phoneNumber: String, completion: @escaping(Result<Void, InstntError>) -> Void) {
        let requestSendOTP = RequestSendOTP(requestData: "{\"phoneNumber\": \"\(phoneNumber)\"}", isVerify: false)
        APIClient.shared.sendOTP(requestData: requestSendOTP, completion: completion)
    }
    
    public func verifyOTP(phoneNumber: String, otp: String, completion: @escaping(Result<Void, InstntError>) -> Void) {
        let requestVerifyOTP = RequestVerifyOTP(requestData: "{\"phoneNumber\": \"\(phoneNumber)\", \"otpCode\": \"\(otp)\"}", isVerify: true)
        APIClient.shared.verifyOTP(requestData: requestVerifyOTP, completion: completion)
    }
    public func verifyDocuments() {
        guard let transactionID = transactionID else {
            return
        }

        let verifyDocument = VerifyDocument(formKey: Instnt.shared.formId, documentType: self.documentType.rawValue, instnttxnid:  transactionID)
        APIClient.shared.verifyDocuments(requestData: verifyDocument, completion: { result in
            switch result {
            case .success(_):
                print("verify succes")
                break
            case.failure(let error):
                print("verify failed with errro %@", error)
            }
            
        })
        
    }
    
    public func getTransactionStatus() {
        
    }
    
    public func submitData() {
        
    }
}


extension Instnt: FormViewControllerDelegate {
    func formViewControllerDidCancel(_ sender: FormViewController) {
        delegate?.instntDidCancel(self)
    }
    
    func formViewControllerDidSubmitForm(_ sender: FormViewController, response: FormSubmitResponse) {
        delegate?.instntDidSubmit(self, decision: response.decision, jwt: response.jwt)
    }
}

extension Instnt: DocumentScanDelegate {    
    public func onScanFinish(captureResult: CaptureResult) {
        SVProgressHUD.show()
        Instnt.shared.uploadAttachment(data: captureResult, completion: { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(_):
                if let parentVC = self.parentVC {
                    if self.documentSide == .front {
                        self.documentSide = .back
                        DispatchQueue.main.async {
                            self.scanDocument(from: parentVC, documentType: self.documentType)
                        }
                    } else if self.documentSide == .back {
                        self.verifyDocuments()
                    }
                }
            case .failure(_):
                break
            }
        })
        
        
    }
    
    public func onScanCancelled(error: String) {
        print(error)
    }
}
