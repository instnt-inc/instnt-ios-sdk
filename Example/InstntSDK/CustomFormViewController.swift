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

class CustomFormViewController: UIViewController {

    @IBOutlet weak var keyField: UITextField!
    @IBOutlet weak var sandboxSwitch: UISwitch!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var responseTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        keyField.text = "v163875646772327"
        responseTextView.text = "No Response"
        
        firstNameField.isEnabled = false
        surnameField.isEnabled = false
        emailField.isEnabled = false
        submitButton.isEnabled = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    private func showError(message: String?) {
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: ("OK"), style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - UI Action
    @IBAction func onGetFormCode(_ sender: Any) {
        keyField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        surnameField.resignFirstResponder()
        emailField.resignFirstResponder()
        
        let formId = keyField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let isSandbox = sandboxSwitch.isOn
        
        Instnt.shared.setup(with: formId, isSandBox: isSandbox)
        
        SVProgressHUD.show()
        Instnt.shared.getFormCodes { [weak self] response in
            SVProgressHUD.dismiss()
            
            if let response = response {
                let responseString = String.jsonString(from: response)
                
                self?.responseTextView.text = responseString
                
                self?.firstNameField.isEnabled = true
                self?.surnameField.isEnabled = true
                self?.emailField.isEnabled = true
                self?.submitButton.isEnabled = true
            } else {
                self?.responseTextView.text = "No Response"
                
                self?.firstNameField.isEnabled = false
                self?.surnameField.isEnabled = false
                self?.emailField.isEnabled = false
                self?.submitButton.isEnabled = false
            }
        }
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        keyField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        surnameField.resignFirstResponder()
        emailField.resignFirstResponder()
        
        guard let firstName = firstNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !firstName.isEmpty else {
            showError(message: "Please input First Name")
            return
        }
        guard let surname = surnameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !surname.isEmpty else {
            showError(message: "Please input Surname")
            return
        }
        guard let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty else {
            showError(message: "Please input Email")
            return
        }
        guard email.isValidEmail else {
            showError(message: "Please input a valid email")
            return
        }
        
        let formData: [String: Any] = [
            "email": email,
            "firstName": firstName,
            "surName": surname
        ]
        SVProgressHUD.show()
        Instnt.shared.submitFormData(formData) { [weak self] response in
            SVProgressHUD.dismiss()
            
            if let response = response {
                let responseString = String.jsonString(from: response)
                
                self?.responseTextView.text = responseString
            } else {
                self?.responseTextView.text = "No Response"
            }
        }
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
