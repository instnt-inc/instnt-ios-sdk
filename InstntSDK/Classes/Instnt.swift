//
//  Instnt.swift
//  InstntSDK
//
//  Created by Nate Eckerson on 5/25/21.
//


import UIKit
import SVProgressHUD
//import BehavioSecIOSSDK

public protocol InstntDelegate: NSObjectProtocol {

    func onDocumentScanFinish(captureResult: CaptureResult)
    func onDocumentScanCancelled(error: InstntError)
    func onDocumentScanFailedVerification(error: InstntError)
    func onDocumentScanError(error: InstntError)

    
    func onSelfieScanCancelled()
    func onSelfieScanFinish(captureResult: CaptureSelfieResult)
    func onSelfieScanError(error: InstntError)
    func onSelfieScanFailedVerification(error: InstntError)
    
    func onDocumentUploaded(imageResult: InstntImageData, error: InstntError?)
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
    public var isOTPverificationEnabled: Bool?
    public var isDocumentVerificationEnabled: Bool?
    var visitorId: String = ""
    var requestId: String = ""
    private var fingerprint: String = "" {
        didSet {
            FingerprintjsHandler.shared.configure(fingerPrintToken: fingerprint) { result in
                switch result {
                case .success(let (visitorId, requestId)):
                    self.visitorId = visitorId!
                    self.requestId = requestId!
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    private var serviceURL: String = ""
    internal var behaviosecAPiUrl: String = ""
    internal var behaviosecTenantId: String = ""
    
    private var documentType: DocumentType = .license
    private var documentSide: DocumentSide = .front
    private var isSelfie: Bool = false
    private var isFarSelfie: Bool = false
    private var documentSettings: DocumentSettings?
    
    private override init() {
        super.init()
        
        formId = ""
        APIClient.shared.isSandbox = true
    }
    
    public func testMethodToCheck() -> Bool {
        
        return true
        
    }
    
    // conviniece init
    
    // MARK: - Public Function
    public func setup(with formId: String, endPOint: String, completion: @escaping(Result<String, InstntError>) -> Void) {
        self.formId = formId
        APIClient.shared.baseEndpoint = endPOint
        APIClient.shared.formKey = formId
        
        //BehavioSecIOSSDK.shared().clearRegistrations()
        //BehavioSecIOSSDK.shared().clearTimingData()
        //BehavioSecIOSSDK.shared().stopMotionDetect()
        
        BehaviosecHandlerImpl.shared.configure(application: UIApplication.shared, view: nil)
        Instnt.shared.getTransactionID(completion: completion)
    }
    
    public func resumeSignup(view: UIViewController, with formId: String, endPOint: String, instnttxnid: String, completion: @escaping(Result<String, InstntError>) -> Void) {
        self.formId = formId
        APIClient.shared.baseEndpoint = endPOint
        APIClient.shared.formKey = formId
        
        Instnt.shared.reInitializeTransaction(withView: view, instnttxnid: instnttxnid, completion: completion)
    }
    
    public func submitData(instnttxnid: String, data: [String: Any], completion: @escaping(Result<FormSubmitResponse, InstntError>) -> Void) {
        var formData: [String: Any] = data
        formData["signature"] = instnttxnid
        if Instnt.shared.isOTPverificationEnabled ?? false {
            formData["OTPSignature"] = instnttxnid
        }
        formData["form_key"] = formId
        
        let timingData = BehaviosecHandlerImpl.shared.getData()
        
        print("timingData - \(timingData.count)")
        
        formData["bdata"] = timingData

        print("browser token :",fingerprint)

        formData["fingerprint"] = [
            "requestId": requestId,
            "visitorId": visitorId,
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
        
        APIClient.shared.submitForm(instnttxnid: instnttxnid, formData: formData, completion: completion)
    }
    
    public func submitVerifyData(instnttxnid: String, data: [String: Any], completion: @escaping(Result<FormSubmitResponse, InstntError>) -> Void) {
        var formData: [String: Any] = data
        formData["signature"] = instnttxnid
        if Instnt.shared.isOTPverificationEnabled ?? false {
            formData["OTPSignature"] = instnttxnid
        }
        
        //formData["form_key"] = formId
        
        let timingData = BehaviosecHandlerImpl.shared.getData()
        
        // adding new sept 15
        //BehavioSecIOSSDK.shared().clearRegistrations()
        //BehavioSecIOSSDK.shared().clearTimingData()
        //BehavioSecIOSSDK.shared().stopMotionDetect()
        
        //todo - check timingdata size
        
        print("timingData - \(timingData.count)")
        
        formData["bdata"] = timingData

        formData["fingerprint"] = [
            "requestId": requestId,
            "visitorId": visitorId,
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
        
        APIClient.shared.submitVerifyData(instnttxnid: instnttxnid, formData: formData, completion: completion)
    }
    
    public func scanDocument(instnttxnid: String, licenseKey: String, from vc: UIViewController, settings: DocumentSettings, isAutoUpload: Bool? = true) {
        self.documentSide = settings.documentSide
        self.isSelfie = false
        self.isFarSelfie = false
        self.documentType = settings.documentType
        documentSettings = settings
        self.transactionID = instnttxnid
        DocumentScan.shared.scanDocument(licenseKey: licenseKey, from: vc, documentSettings: settings, delegate: self, isAutoUpload: isAutoUpload)
    }
    
    public func scanSelfie(from vc: UIViewController, instnttxnid: String, settings: SelfieSettings) {
        print("Instnt scanSelfie")
        self.isSelfie = true
        self.isFarSelfie = settings.isFarSelfie
        self.transactionID = instnttxnid
        DocumentScan.shared.scanSelfie(from: vc, delegate: self, settings: settings)
    }
    
    private func getTransactionID(completion: @escaping(Result<String, InstntError>) -> Void) {
        let transactionRequest = CreateTransaction.init(formKey: self.formId, hideFormFields: true, idmetricsVersion: "4.7.0", format: "json", redirect: false)
        APIClient.shared.createTransaction(data: transactionRequest, completion: { result in
            switch result {
            case .success(let resultTransation):
                let transactionID = resultTransation.instnttxnid
                self.isOTPverificationEnabled = resultTransation.otp_verification
                self.fingerprint = resultTransation.fingerprintjs_browser_token
                self.serviceURL = resultTransation.backend_service_url
                self.isDocumentVerificationEnabled = resultTransation.document_verification
                self.behaviosecAPiUrl = resultTransation.behaviosec_api_url ?? ""
                self.behaviosecTenantId = resultTransation.behaviosec_tenant_id
                completion(.success(transactionID))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    private func reInitializeTransaction(withView: UIViewController, instnttxnid: String, completion: @escaping(Result<String, InstntError>) -> Void) {
            let transactionRequest = ReInitializeTransaction.init(formKey: self.formId, hideFormFields: true, idmetricsVersion: "4.7.0", format: "json", redirect: false, instnttxnid: instnttxnid)
            APIClient.shared.reInitializeTransaction(data: transactionRequest, completion: { result in
                switch result {
                case .success(let resultTransation):
                    let transactionID = resultTransation.instnttxnid
                    self.isOTPverificationEnabled = resultTransation.otp_verification
                    self.fingerprint = resultTransation.fingerprintjs_browser_token
                    
                    //BehavioSecIOSSDK.shared().clearRegistrations()
                    //BehavioSecIOSSDK.shared().clearTimingData()
                    //BehavioSecIOSSDK.shared().stopMotionDetect()
                    
                    // added Aug 18, 2022
                    self.behaviosecAPiUrl = resultTransation.behaviosec_api_url ?? ""
                    self.behaviosecTenantId = resultTransation.behaviosec_tenant_id
                    BehaviosecHandlerImpl.shared.configure(application: UIApplication.shared, view: withView)
                    ///
                    
                    self.serviceURL = resultTransation.backend_service_url
                    self.isDocumentVerificationEnabled = resultTransation.document_verification
                    completion(.success(transactionID))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
    
    private func getUploadUrl(instnttxnid: String, isFarSelfieData: Bool? = false, completion: @escaping(Result<String, InstntError>) -> Void) {
        var docSuffix = "F"
        if isSelfie == true {
            if isFarSelfieData == true {
                docSuffix = "FS"
            } else {
                docSuffix = "S"
            }
        } else if self.documentType == .license {
            if self.documentSide == .front {
                docSuffix = "F"
            } else if self.documentSide == .back {
                docSuffix = "B"
            }
        } else if self.documentType == .passport {
            docSuffix = "F"
        }
        var documentType = "DRIVERS_LICENSE"
        if self.documentType == .passport {
            documentType = "PASSPORT"
        }
        let requestGetuploadURL = RequestGetUploadUrl.init(transactionType: "IMAGE", documentType: documentType, docSuffix: docSuffix, transactionStatus: "NEW");
        APIClient.shared.getUploadUrl(transactionId: instnttxnid, data: requestGetuploadURL, completion: completion)
    }
    
    private func uploadDocument(url: String, data: Data, completion: @escaping(Result<Void, InstntError>) -> Void) {
        APIClient.shared.upload(url: url, data: data, completion: completion)
    }
    
    public func uploadAttachment(instnttxnid: String, data: Data, isFarSelfieData: Bool? = false, isSelfie: Bool, isFront: Bool, documentType: DocumentType? = nil, completion: @escaping(Result<Void, InstntError>) -> Void) {
        self.documentSide = isFront ? .front: .back
        self.isSelfie = isSelfie
        self.isFarSelfie = isFarSelfieData ?? false
        if let documentType = documentType {
            self.documentType = documentType
        }
       
        
        self.getUploadUrl(instnttxnid: instnttxnid, isFarSelfieData: isFarSelfieData, completion: { result in
            switch result {
            case .success(let url):
                self.uploadDocument(url: url, data: data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    public func sendOTP(instnttxnid: String, phoneNumber: String, completion: @escaping(Result<Void, InstntError>) -> Void) {
        let requestSendOTP = RequestSendOTP(phone: phoneNumber)
        APIClient.shared.sendOTP(requestData: requestSendOTP, transactionId: instnttxnid, completion: completion)
    }
    public func verifyOTP(instnttxnid: String, phoneNumber: String, otp: String, completion: @escaping(Result<Void, InstntError>) -> Void) {
        let requestVerifyOTP = RequestVerifyOTP(phone: phoneNumber, is_verify: true, otp: otp)
        APIClient.shared.verifyOTP(requestData: requestVerifyOTP, transactionId: instnttxnid, completion: completion)
    }
    
    public func verifyDocuments(instnttxnid: String, completion: @escaping(Result<Void, InstntError>) -> Void) {
        let verifyDocument = VerifyDocument(formKey: Instnt.shared.formId, documentType: self.documentType.rawValue, instnttxnid:  instnttxnid)
        APIClient.shared.verifyDocuments(requestData: verifyDocument, transactionId: instnttxnid, completion: { result in
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
        print("I m here")
        self.delegate?.onDocumentScanFinish(captureResult: captureResult)
        print(captureResult)
        
        if captureResult.isAutoUpload ?? false {
            SVProgressHUD.show()
            guard let transactionID = transactionID else {
                self.delegate?.onDocumentScanCancelled(error: InstntError(errorConstant: .error_INVALID_TRANSACTION_ID))
                return
            }
            guard let documentSettings = self.documentSettings else {
                //this will never happen
                self.delegate?.onDocumentScanCancelled(error: InstntError(errorConstant: .error_INVALID_DATA))
                return
            }
            Instnt.shared.uploadAttachment(instnttxnid: transactionID, data: captureResult.resultBase64, isSelfie: false, isFront: self.documentSide == .front ? true: false, documentType: self.documentType, completion: { result in
                self.transactionID = nil
                SVProgressHUD.dismiss()
                switch result {
                case .success(_):
                    let imageData = InstntImageData(data: captureResult.resultBase64, isSelfie: false, documentType: documentSettings.documentType, documentSide: documentSettings.documentSide)
                    self.delegate?.onDocumentUploaded(imageResult: imageData, error: nil)
                    break
                case .failure(let error):
                    let imageData = InstntImageData(data: captureResult.resultBase64, isSelfie: false, documentType: documentSettings.documentType, documentSide: documentSettings.documentSide)
                    self.delegate?.onDocumentUploaded(imageResult: imageData, error: error)
                    break
                }
            })
        }
    }
    
    public func onDocumentScanCancelled(error: InstntError) {
        self.delegate?.onDocumentScanCancelled(error: error)
        print("onDocumentScanCancelled error \(String(describing: error.message))")
        print(error)
    }
    public func onDocumentScanFailedVerification(error: InstntError) {
        self.delegate?.onDocumentScanFailedVerification(error: error)
    }
    
    public func onDocumentScanError(error: InstntError) {
        self.delegate?.onDocumentScanError(error: error)
    }

}

extension Instnt: SelfieScanDelegate {
    
    public func onSelfieScanCancelled() {
        self.delegate?.onSelfieScanCancelled()
    }
    
    public func onSelfieScanFinish(captureResult: CaptureSelfieResult) {
        self.delegate?.onSelfieScanFinish(captureResult: captureResult)
        if captureResult.isAutoUpload ?? false {
            SVProgressHUD.show()
            guard let transactionID = transactionID else {
                self.delegate?.onDocumentScanCancelled(error: InstntError(errorConstant: .error_INVALID_TRANSACTION_ID))
                return
            }
            guard let documentSettings = self.documentSettings else {
                //this will never happen
                self.delegate?.onDocumentScanCancelled(error: InstntError(errorConstant: .error_INVALID_DATA))
                return
            }
            Instnt.shared.uploadAttachment(instnttxnid: transactionID, data: captureResult.selfieData, isSelfie: true, isFront: false,  completion: { result in
                switch result {
                case .success(_):
                    if captureResult.farSelfieData != nil {
                        Instnt.shared.uploadAttachment(instnttxnid: transactionID, data: captureResult.selfieData, isFarSelfieData: true, isSelfie: true, isFront: false, completion:  { result in
                            self.transactionID = nil
                            SVProgressHUD.dismiss()
                            switch result {
                            case .success():
                                let imageData = InstntImageData(data: captureResult.selfieData, isSelfie: true, documentType: documentSettings.documentType, documentSide: nil)
                                self.delegate?.onDocumentUploaded(imageResult: imageData, error: nil)
                               
                            case .failure(let error):
                                let imageData = InstntImageData(data:nil, isSelfie: true, documentType: documentSettings.documentType, documentSide: nil)
                                print("uploadAttachment error \(error.localizedDescription)")
                                self.delegate?.onDocumentUploaded(imageResult: imageData, error: error)
                            }
                        })
                    } else {
                        let imageData = InstntImageData(data:captureResult.selfieData, isSelfie: true, documentType: documentSettings.documentType, documentSide: nil)
                        self.delegate?.onDocumentUploaded(imageResult: imageData, error: nil)
                    }
                    
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print("uploadAttachment error \(error.localizedDescription)")
                    let imageData = InstntImageData(data: nil, isSelfie: true, documentType: documentSettings.documentType, documentSide: nil)
                    self.delegate?.onDocumentUploaded(imageResult: imageData, error: error)
                   
                }
            })
            
        }
        
    }
    public func onSelfieScanError(error: InstntError) {
        self.delegate?.onSelfieScanError(error: error)
    }
    
    public func onSelfieScanFailedVerification(error: InstntError) {
        self.delegate?.onSelfieScanFailedVerification(error: error)
        
    }
}
