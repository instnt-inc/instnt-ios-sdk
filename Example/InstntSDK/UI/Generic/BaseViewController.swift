//
//  File.swift
//  taxiapp
//
//  Created by Jagruti on 9/23/19.
//  Copyright © 2019 ROBAB. All rights reserved.
//

import Foundation
import UIKit
import InstntSDK


class BaseViewController: UIViewController {
    @IBOutlet public weak var stackView: UIStackView!
    @IBOutlet public var contentscrollView: UIScrollView?
    @IBOutlet public weak var presenterObject: AnyObject?
    var alert: UIAlertController?
    var changeInsets: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardNotificationObserver()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
       
    }

    func addKeyboardNotificationObserver() {
        
    }

    
    

    @objc func keyBoardWillHide(notification _: NSNotification) {
        // Override this method if we have to show something
    }

    @objc func keyBoardDidHide(notification _: NSNotification) {
        self.scrollDownOnhideKeyboard()
    }

    func scrollDownOnhideKeyboard() {
        if let scrollView = contentscrollView {
            UIView.animate(withDuration: 0.1, animations: {
                scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                scrollView.scrollIndicatorInsets = contentInsets
                scrollView.contentInset = contentInsets
            })
        }
    }

    @objc func keyBoardDidShow(notification _: NSNotification) {

        guard let scrollView = contentscrollView else {
            return
        }
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 100, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    func showStatusViewController(completion: (() -> Void)? = nil) {
        alert = UIAlertController(title: nil, message: NSLocalizedString("Please.wait.status", comment: ""), preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert?.view.addSubview(loadingIndicator)
        present(alert!, animated: true, completion: completion)
    }
    func dissmissStatusController(completion: @escaping (() -> Void)) {
        if self.alert == nil {
            completion()
        }
        alert?.dismiss(animated: true, completion: completion)
    }

    public func showSimpleAlert(_ title: String, message: String? = "", cancelTitle: String? = NSLocalizedString("Alert.OK.Action", comment: ""), target: UIViewController, completed: @escaping () -> Void = {}) {
        let alertController = self.getAlert(title, target: target, completed: completed)
        alertController.message = message
        target.present(alertController, animated: true, completion: nil)
    }

    public func getAlert(_ title: String, message: String? = "", cancelTitle: String? = "OK", target: UIViewController, completed: @escaping () -> Void = {}) ->  UIAlertController {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let alertAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: .cancel) { (_: UIAlertAction) in
            completed()
        }
        alertController.addAction(alertAction)
        return alertController
    }

}
