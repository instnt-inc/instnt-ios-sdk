//
//  FormFieldCheckBoxInputView.swift
//  SwiftyInstntDemo
//
//  Created by Admin on 6/2/21.
//

import UIKit

final class FormFieldCheckBoxInputView: FormFieldInputView {
    private var nameLabel: UILabel! = nil
    private var iconImageView: UIImageView! = nil

    private var checkButton: UIButton! = nil
    
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
        let height = 5 + nameLabel.intrinsicContentSize.height + 5 + fontSize * 0.5
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
    
    // MARK: -  Setup
    private func setupView() {
        let nameLabel = UILabel(frame: .zero)
        nameLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        nameLabel.numberOfLines = 0
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.leading.equalToSuperview().offset(24)
            make.trailing.lessThanOrEqualTo(self.snp.trailing)
        }
        self.nameLabel = nameLabel
        
        let iconImageView = UIImageView()
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.width.equalTo(18)
            make.height.equalTo(18)
        }
        self.iconImageView = iconImageView
        
        let checkButton = UIButton(type: .custom)
        checkButton.setTitle("", for: .normal)
        checkButton.setTitleColor(.clear, for: .normal)
        checkButton.backgroundColor = .clear
        checkButton.addTarget(self, action: #selector(onToggleCheck), for: .touchUpInside)
        checkButton.isSelected = false
        addSubview(checkButton)
        checkButton.snp.makeConstraints { (make) in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.greaterThanOrEqualTo(nameLabel.snp.trailing).offset(16)
        }
        self.checkButton = checkButton
        
        formFieldDidUpdate()
    }
    
    @objc private func onToggleCheck() {
        self.checkButton.isSelected = !self.checkButton.isSelected
        self.iconImageView.image = UIImage(named: self.checkButton.isSelected ? "square-check": "square-uncheck")!
    }
    
    // MARK: - Render
    override internal func formFieldDidUpdate() {
        if formField != nil {
            nameLabel.text = formField.label
            nameLabel.sizeToFit()
            
            iconImageView.isHidden = false
            
            self.checkButton.isSelected = Bool(formField.value ?? "") ?? false
            self.iconImageView.image = UIImage(named: self.checkButton.isSelected ? "square-check": "square-uncheck")!
        } else {
            nameLabel.text = nil
            nameLabel.sizeToFit()
            
            iconImageView.isHidden = true
        }
    }
    
    override internal func fontSizeDidUpdate() {
        nameLabel.font = nameLabel.font.withSize(fontSize)
        nameLabel.sizeToFit()
        
        invalidateIntrinsicContentSize()
    }

    // MARK: - Input & Validation
    override var input: (name: String, value: String)? {
        guard formField != nil else {
            return nil
        }
        
        return (name: formField.name, value: checkButton.isSelected ? "true": "false")
    }
    
    override func validateInput() -> InputError? {
        guard formField.isRequired else {
            return nil
        }
        
        return nil
    }
    
    override func beginEditing() {
    }
}

