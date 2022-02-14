//
//  FormViewController.swift
//  InstntSDK
//
//  Created by Nate Eckerson on 5/25/21.
//

import UIKit
import SnapKit
import ActionSheetPicker_3_0
import IQKeyboardManagerSwift
import SVProgressHUD
protocol FormViewControllerDelegate: AnyObject {
    func formViewControllerDidCancel(_ sender: FormViewController)
    func formViewControllerDidSubmitForm(_ sender: FormViewController, response: FormSubmitResponse)
}

class FormViewController: UIViewController {
    
    private weak var formView: FormView! = nil
    private weak var submitButton: UIButton! = nil
    
    var formCodes: FormCodes! = nil {
        didSet {
            title = formCodes.title
            
            formView?.formCodes = formCodes
        }
    }
    
    weak var delegate: FormViewControllerDelegate? = nil
    
    // MARK: - Override
    override func loadView() {
        super.loadView()
        
        view = UIView()
        view.backgroundColor = .white
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("   Submit   ", for: .normal)
        submitButton.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(44)
        }
        self.submitButton = submitButton
        
        let formView = FormView(frame: .zero)
        formView.backgroundColor = .clear
        formView.delegate = self
        view.addSubview(formView)
        formView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(submitButton.snp.top).offset(-24)
        }
        self.formView = formView
        let imageView = UIImageView(image: ImagesHelper.image(named: "powerbyinstnt"))
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(submitButton)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(120)
        }
        
        submitButton.layer.masksToBounds = true
        submitButton.layer.cornerRadius = 4
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.gray.cgColor
        submitButton.setTitleColor(UIColor.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = formCodes.title
        formView.formCodes = formCodes
        submitButton.setTitle("   \(formCodes.submitLabel)   ", for: .normal)
        submitButton.sizeToFit()
        
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var bottomPadding = view.safeAreaInsets.bottom
        if bottomPadding > 0 {
            bottomPadding = 0
        } else {
            bottomPadding = 30
        }
        
        submitButton.snp.updateConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-bottomPadding)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Navigation Bar
    private func setupNavigationBar() {
        let dismissBaritem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onCancel))
        navigationItem.leftBarButtonItem = dismissBaritem
    }
    
    // MARK: - Show Picker
    private func showStringPicker(for formFieldTextInputView: FormFieldTextInputView) {
        let formField = formFieldTextInputView.formField!
        let textField = formFieldTextInputView.inputField
        
        let rows = formField.selectableValues ?? []
        let initialSelection = rows.firstIndex(of: textField?.text ?? "") ?? 0
        
        let picker = ActionSheetStringPicker(title: formField.placeholder ?? "", rows: rows, initialSelection: initialSelection, doneBlock: { [weak self] (_, index, _) in
            textField?.text = rows[index]
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.formView.beginEditingNextFieldViewIfNeeded(formFieldTextInputView)
            }
        }, cancel: nil,
        origin: view)
        
        picker?.popoverDisabled = true
        picker?.show()
    }
    
    private func showDatePicker(for formFieldTextInputView: FormFieldTextInputView) {
        let formField = formFieldTextInputView.formField!
        let textField = formFieldTextInputView.inputField
        
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd"
        let selectedDate = df.date(from: textField?.text ?? "")
        
        let picker = ActionSheetDatePicker(title: formField.placeholder ?? "", datePickerMode: .date, selectedDate: selectedDate, doneBlock: { (_, date, _) in
            textField?.text = df.string(from: date as? Date ?? Date())
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.formView.beginEditingNextFieldViewIfNeeded(formFieldTextInputView)
            }
        }, cancel: nil,
        origin: view)
        
        picker?.popoverDisabled = true
        picker?.show()
    }
    
    // MARK: - UI Action
    @objc private func onCancel() {
        navigationController?.dismiss(animated: true, completion: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.delegate?.formViewControllerDidCancel(strongSelf)
        })
    }
    
    @objc private func onSubmit() {
        view.endEditing(false)
        
        if let (error, formFieldView) = formView.validateInputs() {
            showInputErrorAlert(message: error.localizedDescription) {
                formFieldView.beginEditing()
            }
            return
        }
        
        var formData: [String: Any] = formView.inputs
        formData["form_key"] = formCodes.id
        formData["fingerprint"] = [
            "requestId": formCodes.fingerprint,
            "visitorId": formCodes.fingerprint,
            "visitorFound": true
        ]
        formData["client_referer_url"] = formCodes.serviceURL
        formData["client_referer_host"] = URL(string: formCodes.serviceURL)?.host ?? ""
        
        SVProgressHUD.show()
        APIClient.shared.submitForm(to: formCodes.submitURL, formData: formData) { result in
            SVProgressHUD.dismiss()
//            switch result {
//            case .success(let response):
//                break
//
//            case .failure(let error):
//                break
//            }
           
//
//            if let response = response {
//                self?.navigationController?.dismiss(animated: true, completion: { [weak self] in
//                    guard let strongSelf = self else {
//                        return
//                    }
//
//                    strongSelf.delegate?.formViewControllerDidSubmitForm(strongSelf, response: response)
//                })
//            } else {
//
//            }
        }
    }
}

// MARK: - Alert
private extension FormViewController {
    func showAlert(title: String? = nil, message: String? = nil, actions: [UIAlertAction]? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let actions = actions, actions.count > 0 {
            for action in actions {
                alertVC.addAction(action)
            }
        } else {
            let okAction = UIAlertAction(title: ("OK"), style: .default, handler: nil)
            alertVC.addAction(okAction)
        }
        
        present(alertVC, animated: true, completion: nil)
    }
    
    func showInputErrorAlert(message: String?, action: @escaping (() -> Void)) {
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            action()
        }
        showAlert(title: "Error!", message: message, actions: [okAction])
    }
}

// MARK: - FormView Delegate
extension FormViewController: FormViewDelegate {
    func formCodeViewFieldShouldBeginEditting(_ formCodeView: FormView, formFieldTextInputView: FormFieldTextInputView) -> Bool {
        guard let formField = formFieldTextInputView.formField else {
            return true
        }
        
        switch formField.inputType {
        case .select:
            if let rows = formField.selectableValues, rows.count > 0 {
                showStringPicker(for: formFieldTextInputView)
                
                return false
            }
        case .date:
            showDatePicker(for: formFieldTextInputView)
            
            return false
        default:
            break
        }
        
        return true
    }
}
