//
//  String+Utils.swift
//  InstntSDK_Example
//
//  Created by Jagruti Patel CW on 12/28/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
extension String {
    func isEmailValid() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
