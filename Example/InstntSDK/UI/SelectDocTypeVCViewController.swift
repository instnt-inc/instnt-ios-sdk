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

class SelectDocTypeVCViewController: UIViewController {
    @IBOutlet var stackView: UIStackView!

    @IBOutlet private var multiRadioButton: [UIButton]!{
        didSet{
            multiRadioButton.forEach { (button) in
                button.tintColor = .black
                button.setImage(UIImage(named:"circle_radio_unselected"), for: .normal)
                button.setImage(UIImage(named:"circle_radio_selected"), for: .selected)
            }
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
        Instnt.shared.setup(with: "v163875646772327", isSandBox: true)
        addNextButton()

    }
    
    func addNextButton() {
        self.stackView.addSpacerView()
        buttonView?.decorateView(type: .next, completion: {
            Instnt.shared.scanDocument(from: self, documentType: DocumentType.licence)
        })
        self.stackView.addOptionalArrangedSubview(buttonView)
    }
    
    func uncheck(){
        multiRadioButton.forEach { (button) in
            button.isSelected = false
        }
    }
    
    @IBAction private func radioBtnAction(_ sender: UIButton){
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
