//
//  UIView+Utils.swift
//  taxiapp
//
//  Created by Jagruti on 10/3/19.
//  Copyright © 2019 ROBAB. All rights reserved.
//

import Foundation
import UIKit
public extension UIView {
    func addCardShadow(cornerRadius: CGFloat? = nil) {
        // makes view look like card
        layer.cornerRadius = cornerRadius ?? 12.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }

    func applyBorder(width: CGFloat? = nil) {
        layer.borderWidth = width ?? 2
        layer.borderColor = UIColor.darkGray.cgColor
    }

    func addBlurView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    func removeBlurView() {
      let blurredEffectViews = self.subviews.filter{$0 is UIVisualEffectView}
      blurredEffectViews.forEach{ blurView in
        blurView.removeFromSuperview()
      }
    }

}
