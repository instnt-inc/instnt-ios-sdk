//
//  SelectDocTypeVCViewController.swift
//  InstntSDK_Example
//
//  Created by Sanjeev Mehta on 28/12/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import InstntSDK
import CFDocumentScanSDK
import SVProgressHUD


class UploadDocumentVC: UIViewController {
    @IBOutlet var stackView: UIStackView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNextButton()
        Instnt.shared.delegate = self

    }
    
    private func addNextButton() {
        self.stackView.addSpacerView()
        buttonView?.decorateView(type: .next, completion: {
            Instnt.shared.scanDocument(from: self, documentType: DocumentType.licence)
        })
        self.stackView.addOptionalArrangedSubview(buttonView)
    }
    
    private func onSubmit() {
        Instnt.shared.submitFormData(Instnt.shared.formData) { response in
            print("Submit form respose %@", response ?? "")
        }
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
    func instntDidCancel(_ sender: Instnt) {
        print("Sign Up is cancelled")
    }
    
    func instntDidSubmit(_ sender: Instnt, decision: String, jwt: String) {
        print("Form is submitted successfully")
    }
    
    func instntDocumentScanError() {
        print("Document scan failed, please try again later")
    }
    
    func instntDocumentVerified() {
        Instnt.shared.submitFormData(Instnt.shared.formData, completion: {_ in
            print("Data was uploaded successfully")
        })
    }
}
