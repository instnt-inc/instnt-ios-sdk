//
//  CustomFormViewController.swift
//  InstntSDK_Example
//
//  Created by Admin on 7/10/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import InstntSDK
import SVProgressHUD

class CustomFormViewController: BaseViewController {
        
    var presenter: CustomFormPresenter? {
        return presenterObject as? CustomFormPresenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.presentScene()
        
        print("CustomeFormView : viewDidLoad : signUpType : \(SignUpManager.shared.type.name)")
    }
}

extension CustomFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
}

private extension String {
    static func jsonString(from value: Any, prettyPrinted: Bool = true) -> String? {
        let options: JSONSerialization.WritingOptions = prettyPrinted ? [.prettyPrinted] : []
        if JSONSerialization.isValidJSONObject(value) {
            if let data = try? JSONSerialization.data(withJSONObject: value, options: options) {
                if let string = String(data: data, encoding: .utf8) {
                    return string
                }
            }
        }
        
        return nil
    }
    
    func jsonValue() -> Any? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailPredicate.evaluate(with: self)
    }
}
