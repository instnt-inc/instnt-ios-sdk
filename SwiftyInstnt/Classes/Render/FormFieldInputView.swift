//
//  FormFieldInputViewProtocol.swift
//  SwiftyInstntDemo
//
//  Created by Admin on 5/25/21.
//

import UIKit
import SnapKit

class FormFieldInputView: UIView {
    // MARK: - Render
    var formField: FormField! = nil {
        didSet {
            formFieldDidUpdate()
        }
    }
    var fontSize: CGFloat = 18 {
        didSet {
            fontSizeDidUpdate()
            
            invalidateIntrinsicContentSize()
        }
    }
    
    internal func formFieldDidUpdate() {}
    internal func fontSizeDidUpdate() {}

    // MARK: - Input & Validation
    var input: (name: String, value: String)? { return nil }
    
    internal func validateInput() -> InputError? { return nil }
    internal func beginEditing() {}
}
