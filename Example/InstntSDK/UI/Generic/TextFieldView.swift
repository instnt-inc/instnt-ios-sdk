//
//  TextFieldView.swift
//  taxiapp
//
//  Created by Jagruti on 9/23/19.
//  Copyright © 2019 ROBAB. All rights reserved.
//

import Foundation
import UIKit
class TextFieldView: UIView {
    let defaultCharacter = "-"
    @IBOutlet weak var textField: HSUnderLineTextField!
    var digitLabels = [UILabel]()
    var didEnterLastDigit: ((String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func decorateTextField(textfieldType: TextFieldTypes) {
        textField.leftViewMode = .always
        switch textfieldType {
        case .firstName:
             textField.keyboardType = .default
             textField.placeholder = NSLocalizedString("FirstName", comment: "")
        case .lastName:
            textField.keyboardType = .default
            textField.placeholder = NSLocalizedString("LastName", comment: "")
        case .email:
            textField.keyboardType = .emailAddress
            textField.placeholder = NSLocalizedString("Email", comment: "")
        case .mobile:
            textField.keyboardType = .phonePad
            textField.placeholder = NSLocalizedString("Phone Number", comment: "")
        case .amount:
            textField.keyboardType = .phonePad
            textField.placeholder = NSLocalizedString("Amount", comment: "")
        case .notes:
            textField.keyboardType = .default
            textField.placeholder = NSLocalizedString("Notes", comment: "")
        case .otp:
            if #available(iOS 12.0, *) {
                textField.textContentType = .oneTimeCode
            } else {
                // Fallback on earlier versions
            }
            textField.keyboardType = .numberPad
        case .address:
            textField.keyboardType = .default
            textField.placeholder = NSLocalizedString("Address", comment: "")
        case .city:
            textField.keyboardType = .default
            textField.placeholder = NSLocalizedString("City", comment: "")
        case .state:
            textField.keyboardType = .default
            textField.placeholder = NSLocalizedString("State", comment: "")
        case .zipcode:
            textField.keyboardType = .numberPad
            textField.placeholder = NSLocalizedString("Zip code", comment: "")
        case .country:
            textField.keyboardType = .default
            textField.placeholder = NSLocalizedString("Country", comment: "")
        case .dob:
            textField.keyboardType = .default
            textField.placeholder = NSLocalizedString("DOB", comment: "")
        case .nationalId:
            textField.keyboardType = .numberPad
            textField.placeholder = NSLocalizedString("National Id", comment: "")
        case .formKey:
            textField.keyboardType = .default
            textField.placeholder = NSLocalizedString("FormKey", comment: "")
        case .endPoint:
            textField.keyboardType = .default
            textField.placeholder = NSLocalizedString("EndPoint", comment: "")
        case .transactionID:
            textField.keyboardType = .default
            textField.placeholder = NSLocalizedString("TrabsactionID", comment: "")
        case .password:
            textField.keyboardType = .default
            textField.isSecureTextEntry = true
            textField.placeholder = NSLocalizedString("password", comment: "")
        }
    }
    func validate(textfieldType: TextFieldTypes, text: String) -> Bool {
        switch textfieldType {
        case .firstName, .lastName:
            return text.isValidName()
        case .address, .city, .state, .zipcode, .country, .formKey, .endPoint:
            return text.count > 0
        case .otp:
            return text.count == 6
        case .password:
            return text.count > 5
        case .email:
            return text.isEmailValid() 
        case .mobile:
            return text.count == 12 && text.prefix(2) == "+1"
        case .transactionID:
            return true
        case .notes:
            return true
        case .amount:
            return text.count > 0
        case .dob:
            return true
        case .nationalId:
            return text.count == 11
        }
    }

    func leftImageView(imageName: String) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 5, width: 20, height: 20))
        imageView.image = UIImage(named: imageName)
        return imageView
    }
    
}
