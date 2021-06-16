//
//  SwiftyInstnt.swift
//  SwiftyInstntDemo
//
//  Created by Admin on 5/25/21.
//

import UIKit

@objc public protocol SwiftyInstntDelegate: NSObjectProtocol {
    func swiftyInstntDidCancel(_ sender: SwiftyInstnt)
    func swiftyInstntDidSubmit(_ sender: SwiftyInstnt, decision: String, jwt: String)
}

public class SwiftyInstnt: NSObject {
    public static let decisionTypeAccept = "ACCEPT"
    public static let decisionTypeReject = "REJECT"
    public static let decisionTypeReview = "REVIEW"
    
    public static let shared = SwiftyInstnt()
    
    private (set) var formId: String = ""
    private var isSandbox: Bool {
        return APIClient.shared.isSandbox
    }
    
    public weak var delegate: SwiftyInstntDelegate? = nil
    
    private override init() {
        super.init()
        
        formId = ""
        APIClient.shared.isSandbox = false
    }
    
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
        
        APIClient.shared.getFormCodes(with: formId) { [weak self] (formCodes, message) in
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
}

extension SwiftyInstnt: FormViewControllerDelegate {
    func formViewControllerDidCancel(_ sender: FormViewController) {
        delegate?.swiftyInstntDidCancel(self)
    }
    
    func formViewControllerDidSubmitForm(_ sender: FormViewController, response: FormSubmitResponse) {
        delegate?.swiftyInstntDidSubmit(self, decision: response.decision, jwt: response.jwt)
    }
}
