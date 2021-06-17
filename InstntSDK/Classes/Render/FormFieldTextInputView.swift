//
//  FormFieldTextInputView.swift
//  InstntSDK
//
//  Created by Nate Eckerson on 6/2/21.
//

import UIKit

final class FormFieldTextInputView: FormFieldInputView {
    private var nameLabel: UILabel! = nil
    private var markLabel: UILabel! = nil
    
    private (set) var inputField: UITextField! = nil

    // MARK: - Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = 5 + nameLabel.intrinsicContentSize.height + 10 + fontSize * 2
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
    
    // MARK: -  Setup
    private func setupView() {
        let nameLabel = UILabel(frame: .zero)
        nameLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview()
        }
        self.nameLabel = nameLabel
        
        let markLabel = UILabel(frame: .zero)
        markLabel.text = "*"
        markLabel.textColor = UIColor.red
        markLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        markLabel.sizeToFit()
        addSubview(markLabel)
        markLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel.snp.trailing).offset(fontSize * 0.2)
            make.top.equalTo(nameLabel.snp.top).offset(-fontSize * 0.2)
        }
        self.markLabel = markLabel
        
        let inputView = UIView(frame: .zero)
        inputView.backgroundColor = .clear
        addSubview(inputView)
        inputView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.height.equalTo(fontSize * 2)
        }
        
        let inputField = UITextField(frame: .zero)
        inputField.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        inputField.textAlignment = .left
        inputField.returnKeyType = .next
        inputView.addSubview(inputField)
        inputField.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
        }
        self.inputField = inputField
        
        inputView.layer.masksToBounds = true
        inputView.layer.cornerRadius = 4
        inputView.layer.borderWidth = 1
        inputView.layer.borderColor = UIColor.gray.cgColor
        
        formFieldDidUpdate()
    }
    
    // MARK: - Render
    override internal func formFieldDidUpdate() {
        if formField != nil {
            nameLabel.text = formField.label
            nameLabel.sizeToFit()
            
            markLabel.isHidden = !formField.isRequired
            
            inputField.placeholder = formField.placeholder
            inputField.text = formField.value
            inputField.sizeToFit()
            
            switch formField.inputType {
            case .email:
                inputField.textContentType = .emailAddress
                inputField.keyboardType = .emailAddress
            case .number:
                inputField.textContentType = nil
                inputField.keyboardType = .numberPad
            default:
                inputField.textContentType = nil
                inputField.keyboardType = .default
            }
        } else {
            nameLabel.text = nil
            nameLabel.sizeToFit()
            
            markLabel.isHidden = false
            
            inputField.placeholder = nil
            inputField.text = nil
            inputField.sizeToFit()
            
            inputField.textContentType = nil
            inputField.keyboardType = .default
        }
    }
    
    override internal func fontSizeDidUpdate() {
        nameLabel.font = nameLabel.font.withSize(fontSize)
        nameLabel.sizeToFit()
        
        markLabel.font = markLabel.font.withSize(fontSize)
        markLabel.sizeToFit()
        markLabel.snp.updateConstraints { (make) in
            make.leading.equalTo(nameLabel.snp.trailing).offset(fontSize * 0.2)
            make.top.equalTo(nameLabel.snp.top).offset(-fontSize * 0.2)
        }
        
        inputField.font = inputField.font?.withSize(fontSize)
        inputField.sizeToFit()
        inputField.snp.updateConstraints { (make) in
            make.height.equalTo(fontSize * 2)
        }
        
        invalidateIntrinsicContentSize()
    }

    // MARK: - Input & Validation
    override var input: (name: String, value: String)? {
        guard formField != nil, let inputedString = inputField.text else {
            return nil
        }
        
        return (name: formField.name, value: inputedString)
    }
    
    override func validateInput() -> InputError? {
        guard formField.isRequired else {
            return nil
        }
        
        guard let text = inputField.text, !text.isEmpty else {
            return .empty
        }

        if formField.inputType == .email {
            if !text.isValidEmail {
                return .invalidEmail
            }
        }
        
        return nil
    }
    
    override func beginEditing() {
        inputField.selectAll(nil)
        inputField.becomeFirstResponder()
    }
}
