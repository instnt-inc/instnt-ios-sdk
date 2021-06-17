//
//  Instnt.swift
//  InstntSDK
//
//  Created by Nate Eckerson on 5/25/21.
//

import UIKit

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
    
    private override init() {
        super.init()
        
        formId = ""
        APIClient.shared.isSandbox = false
    }
    
    // MARK: - Public Function
    public func setup(with formId: String, isSandBox: Bool = false) {
        self.formId = formId
        APIClient.shared.isSandbox = isSandBox
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
}

extension Instnt: FormViewControllerDelegate {
    func formViewControllerDidCancel(_ sender: FormViewController) {
        delegate?.instntDidCancel(self)
    }
    
    func formViewControllerDidSubmitForm(_ sender: FormViewController, response: FormSubmitResponse) {
        delegate?.instntDidSubmit(self, decision: response.decision, jwt: response.jwt)
    }
}
