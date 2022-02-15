//
//  Instnt.swift
//  InstntSDK
//
//  Created by Nate Eckerson on 5/25/21.
//


import UIKit
import SVProgressHUD
import IDMetricsSelfieCapture


public protocol InstntDelegate: NSObjectProtocol {

    func onDocumentScanFinish(captureResult: CaptureResult)
    func onDocumentScanCancelled(error: InstntError)
    func onSelfieScanCancelled()
    func onSelfieScanFinish(captureResult: CFASelfieScanData)
    func onSelfieScanError(error: InstntError)
}

public class Instnt: NSObject {
    public enum DecisionType: String {
        case accept = "ACCEPT"
        case reject = "REJECT"
        case review = "REVIEW"
    }
    
    public static let shared = Instnt()
    
    private (set) var formId: String = ""
    public weak var delegate: InstntDelegate? = nil
    public var transactionID: String?
    public var isOTPSupported: Bool?
    private var fingerprint: String = ""
    private var serviceURL: String = ""
    private var submitURL: String = ""
    private var documentType: DocumentType = .license
    
    private override init() {
        super.init()
        
        formId = ""
        APIClient.shared.isSandbox = true
    }
    
    // conviniece init
    
    // MARK: - Public Function
    public func setup(with formId: String, endPOint: String, completion: @escaping(Result<String, InstntError>) -> Void) {
        self.formId = formId
        APIClient.shared.baseEndpoint = endPOint
        APIClient.shared.formKey = formId
        Instnt.shared.getTransactionID(completion: completion)
    }
    
    public func submitData(_ data: [String: Any], completion: @escaping(Result<FormSubmitResponse, InstntError>) -> Void) {
        var formData: [String: Any] = data
        formData["signature"] = self.transactionID
        if Instnt.shared.isOTPSupported ?? false {
            formData["OTPSignature"] = self.transactionID
        }
        formData["form_key"] = formId
        
        formData["fingerprint"] = [
            "requestId": self.fingerprint,
            "visitorId": self.fingerprint,
            "visitorFound": true
        ]
        
        formData["client_referer_url"] = self.serviceURL
        formData["client_referer_host"] = URL(string: self.serviceURL)?.host ?? ""
        
        var deviceInfo: [String: String] = [:]
        
        deviceInfo["screen_resolution_value"] = "\(Utils.getViewHeight()) * \(Utils.getViewWidth()) Pixels"
        deviceInfo["screen_size"] = "\(Utils.diagonalScreenSize()) inches"
        deviceInfo["screen_density"] = "\(Utils.getDPI()) dpi"
        deviceInfo["osversion"] = "\(Utils.getOSVersion())"
        deviceInfo["model"] = "\(Utils.getDeviceModel())"
        deviceInfo["serial"] = "\(Utils.getSerialNumber())"
        formData["mobileDeviceInfo"] = deviceInfo
        
        APIClient.shared.submitForm(to: self.submitURL, formData: formData, completion: completion)
    }
    
    public func scanDocument(licenseKey: String, from vc: UIViewController, settings: DocumentSettings) {
        DocumentScan.shared.scanDocument(licenseKey: licenseKey, from: vc, documentSettings: settings, delegate: self)
    }
    
    public func scanSelfie(from vc: UIViewController) {
        DocumentScan.shared.scanSelfie(from: vc, delegate: self, farSelfie: false)
    }
    
    private func getTransactionID(completion: @escaping(Result<String, InstntError>) -> Void) {
        let transactionRequest = CreateTransaction.init(formKey: self.formId, hideFormFields: true, idmetricsVersion: "4.5.0.5", format: "json", redirect: false)
        APIClient.shared.createTransaction(data: transactionRequest, completion: { result in
            switch result {
            case .success(let resultTransation):
                let transactionID = resultTransation.instnttxnid
                self.isOTPSupported = resultTransation.otp_verification
                self.transactionID = transactionID
                self.fingerprint = resultTransation.fingerprintjs_browser_token
                self.serviceURL = resultTransation.backend_service_url
                self.submitURL = resultTransation.signed_submit_form_url
                completion(.success(transactionID))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    private func getUploadUrl(completion: @escaping(Result<String, InstntError>) -> Void) {
        if self.documentType == .license {
            let requestGetuploadURL = RequestGetUploadUrl.init(transactionType: "IMAGE", documentType: "DRIVERS_LICENSE", docSuffix: "F", transactionStatus: "NEW");
            if let transactionID = transactionID {
                APIClient.shared.getUploadUrl(transactionId: transactionID, data: requestGetuploadURL, completion: completion)
            }
        }
    }
    
    private func uploadDocument(url: String, data: Data, completion: @escaping(Result<Void, InstntError>) -> Void) {
        APIClient.shared.upload(url: url, data: data, completion: completion)
    }
    
    public func uploadAttachment(data: Data, completion: @escaping(Result<Void, InstntError>) -> Void) {
        self.getUploadUrl(completion: { result in
            switch result {
            case .success(let url):
                self.uploadDocument(url: url, data: data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    public func sendOTP(phoneNumber: String, completion: @escaping(Result<Void, InstntError>) -> Void) {
        let requestSendOTP = RequestSendOTP(phone: phoneNumber)
        guard let transactionID = transactionID else {
            completion(.failure(InstntError(errorConstant: .error_INVALID_TRANSACTION_ID)))
            return
        }
        APIClient.shared.sendOTP(requestData: requestSendOTP, transactionId: transactionID, completion: completion)
    }
    public func verifyOTP(phoneNumber: String, otp: String, completion: @escaping(Result<Void, InstntError>) -> Void) {
        let requestVerifyOTP = RequestVerifyOTP(phone: phoneNumber, is_verify: true, otp: otp)
        guard let transactionID = transactionID else {
            completion(.failure(InstntError(errorConstant: .error_INVALID_TRANSACTION_ID)))
            return
        }
        APIClient.shared.verifyOTP(requestData: requestVerifyOTP, transactionId: transactionID, completion: completion)
    }
    
    public func verifyDocuments(completion: @escaping(Result<Void, InstntError>) -> Void) {
        guard let transactionID = transactionID else {
            completion(.failure(InstntError(errorConstant: .error_INVALID_TRANSACTION_ID)))
            return
        }
        let verifyDocument = VerifyDocument(formKey: Instnt.shared.formId, documentType: self.documentType.rawValue, instnttxnid:  transactionID)
        APIClient.shared.verifyDocuments(requestData: verifyDocument, transactionId: transactionID, completion: { result in
            switch result {
            case .success(_):
                print("verify succes")
                completion(.success(()))
                break
            case.failure(let error):
                print("verify failed with errro %@", error)
                completion(.failure(InstntError(errorConstant: .error_EXTERNAL)))
            }
        })
    }
}

extension Instnt: DocumentScanDelegate {
    public func onDocumentScanFinish(captureResult: CaptureResult) {
        self.delegate?.onDocumentScanFinish(captureResult: captureResult)
    }
    
    public func onDocumentScanCancelled(error: InstntError) {
        self.delegate?.onDocumentScanCancelled(error: error)
        print("onDocumentScanCancelled error \(String(describing: error.message))")
        print(error)
    }
}

extension Instnt: SelfieScanDelegate {
    
    public func onSelfieScanCancelled() {
        self.delegate?.onSelfieScanCancelled()
    }
    
    public func onSelfieScanFinish(captureResult: CFASelfieScanData) {
        self.delegate?.onSelfieScanFinish(captureResult: captureResult)
    }
    public func onSelfieScanError(error: InstntError) {
        self.delegate?.onSelfieScanError(error: error)
    }
}
