//
//  ViewController.swift
//  SwiftyInstntDemo
//
//  Created by Admin on 5/25/21.
//

import UIKit
import SVProgressHUD
import SnapKit

class ViewController: UIViewController {

    @IBOutlet weak var keyField: UITextField!
    @IBOutlet weak var jwtTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        keyField.text = "v876130100000"
        jwtTextView.text = "No JWT"
    }
    
    private func showError(message: String?) {
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: ("OK"), style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - UI Action
    @IBAction func onShow(_ sender: Any) {
        keyField.resignFirstResponder()
        
        let formId = keyField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        SwiftyInstnt.shared.setup(with: formId, isSandBox: true)
        SwiftyInstnt.shared.delegate = self
        
        SVProgressHUD.show()
        SwiftyInstnt.shared.showForm(from: self) { [weak self] (success, message) in
            SVProgressHUD.dismiss()
            
            if !success {
                self?.jwtTextView.text = "No JWT"
                
                self?.showError(message: message)
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
}

extension ViewController: SwiftyInstntDelegate {
    func swiftyInstntDidCancel(_ sender: SwiftyInstnt) {
        jwtTextView.text = "No JWT"
        
        showError(message: "Canceled By User!")
    }
    
    func swiftyInstntDidSubmit(_ sender: SwiftyInstnt, decision: String, jwt: String) {
        jwtTextView.text = jwt
        
        showError(message: decision)
    }
}
