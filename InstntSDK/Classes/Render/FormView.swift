//
//  FormView.swift
//  InstntSDK
//
//  Created by Nate Eckerson on 5/25/21.
//

import UIKit
import SnapKit

protocol FormViewDelegate: class {
    func formCodeViewFieldShouldBeginEditting(_ formCodeView: FormView, formFieldTextInputView: FormFieldTextInputView) -> Bool
}

extension FormViewDelegate {
    func formCodeViewFieldShouldBeginEditting(_ formCodeView: FormView, formFieldTextInputView: FormFieldTextInputView) -> Bool { return true }
}

class FormView: UIView {
    private var stackView: UIStackView! = nil
    private var scrollView: UIScrollView! = nil
    private var topSpacingView: UIView? = nil
    private var bottomSpacingView: UIView? = nil
    
    weak var delegate: FormViewDelegate? = nil
    
    var formCodes: FormCodes! = nil {
        didSet {
            formCodesDidUpdate()
        }
    }
    
    var spacing: CGFloat = 10 {
        didSet {
            stackView.spacing = spacing
            
            bottomSpacingView?.snp.makeConstraints { (make) in
                make.height.equalTo(spacing)
            }
        }
    }
    
    var formFieldInputViews: [FormFieldInputView] {
        let formFieldInputViews: [FormFieldInputView] = stackView.subviews.compactMap { $0 as? FormFieldInputView }
        return formFieldInputViews
    }
    
    // MARK: - Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    // MARK: - Setup View
    private func setupView() {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .clear
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        self.scrollView = scrollView
        
        let stackView = UIStackView(frame: .zero)
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = spacing
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalToSuperview().offset(-40)
        }
        self.stackView = stackView
    }
    
    // MARK: - Render
    private func formCodesDidUpdate() {
        cleanUp()
        
        if let formCodes = formCodes {
            let topSpacingView = UIView(frame: .zero)
            topSpacingView.backgroundColor = .clear
            topSpacingView.snp.makeConstraints { (make) in
                make.height.equalTo(1)
            }
            stackView.addArrangedSubview(topSpacingView)
            self.topSpacingView = topSpacingView
            
            for formField in formCodes.fields {
                if formField.inputType == .checkbox {
                    let formFieldCheckBoxInputView = FormFieldCheckBoxInputView(frame: .zero)
                    formFieldCheckBoxInputView.formField = formField
                    stackView.addArrangedSubview(formFieldCheckBoxInputView)
                } else {
                    let formFieldTextInputView = FormFieldTextInputView(frame: .zero)
                    formFieldTextInputView.formField = formField
                    stackView.addArrangedSubview(formFieldTextInputView)
                    
                    formFieldTextInputView.inputField.delegate = self
                }
            }
            
            let bottomSpacingView = UIView(frame: .zero)
            bottomSpacingView.backgroundColor = .clear
            bottomSpacingView.snp.makeConstraints { (make) in
                make.height.equalTo(spacing)
            }
            stackView.addArrangedSubview(bottomSpacingView)
            self.bottomSpacingView = bottomSpacingView
        }
    }
    
    private func cleanUp() {
        let subviews = stackView.subviews
        for subview in subviews {
            stackView.removeArrangedSubview(subview)
        }
        
        topSpacingView = nil
        bottomSpacingView = nil
        
        scrollView.contentOffset = .zero
    }
}

// MARK: - JSON Value
extension FormView {
    var inputs: [String: String] {
        var inputs: [String: String] = [:]
        
        let formFieldInputViews = self.formFieldInputViews
        for formFieldInputView in formFieldInputViews {
            if let input = formFieldInputView.input {
                inputs[input.name] = input.value
            }
        }

        return inputs
    }
}

// MARK: - Validation
extension FormView {
    func validateInputs() -> (error: InputError, at: FormFieldInputView)? {
        var found: (error: InputError, at: FormFieldInputView)? = nil
        
        let formFieldInputViews = self.formFieldInputViews
        for formFieldInputView in formFieldInputViews {
            if let error = formFieldInputView.validateInput() {
                found = (error, formFieldInputView)
                break
            }
        }

        return found
    }
    
    @discardableResult func beginEditingNextFieldViewIfNeeded(_ fieldView: FormFieldInputView) -> Bool {
        let formFieldInputViews = self.formFieldInputViews
        
        if let index = formFieldInputViews.firstIndex(of: fieldView) {
            if index + 1 < formFieldInputViews.count {
                if let nextView = formFieldInputViews[index + 1] as? FormFieldTextInputView {
                    if nextView.inputField.text?.isEmpty ?? true {
                        if let currentView = fieldView as? FormFieldTextInputView {
                            currentView.inputField.resignFirstResponder()
                        }
                        nextView.inputField.becomeFirstResponder()
                        
                        return true
                    }
                }
            }
        }
        
        return false
    }
}

// MARK: - UITextField Delegate
extension FormView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let delegate = delegate else {
            return true
        }
        guard let formFieldTextInputView = textField.superview?.superview as? FormFieldTextInputView else {
            return true
        }
        
        return delegate.formCodeViewFieldShouldBeginEditting(self, formFieldTextInputView: formFieldTextInputView)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let formFieldInputViews = self.formFieldInputViews
        
        if let formFieldInputView = formFieldInputViews.first(where: {
            if let fromFieldTextInputView = $0 as? FormFieldTextInputView, fromFieldTextInputView.inputField == textField {
                return true
            } else {
                return false
            }
        }) {
            if !beginEditingNextFieldViewIfNeeded(formFieldInputView) {
                textField.resignFirstResponder()
            }
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
}
