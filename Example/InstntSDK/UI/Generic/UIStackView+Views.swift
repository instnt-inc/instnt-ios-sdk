//
//  UIStackView+Views.swift
//  taxiapp
//
//  Created by Jagruti on 9/23/19.
//  Copyright © 2019 ROBAB. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    func clearStack() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    func addOptionalArrangedSubview(_ view: UIView?, atIndex: Int? = nil) {
        if let localView = view {
            if let atIndex = atIndex {
                insertArrangedSubview(localView, at: atIndex)
            } else {
                addArrangedSubview(localView)
            }
        }
    }

    func addSpacerView(color: UIColor = UIColor.clear, height: CGFloat = TaxiUIconstants.SPACER_HEIGHT, atIndex: Int? = nil) {

        if let view = Utils.getViewFromNib(name: "SpacerView") as? SpacerView, let spacer = view.spacerView {
            spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
            spacer.backgroundColor = color
            if let index = atIndex {
                insertArrangedSubview(view, at: index)
            } else {
                addArrangedSubview(spacer)
            }
        }
    }

    func addDividerView() {
        let separator = UIView()
        separator.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separator.backgroundColor = .lightGray
        self.addArrangedSubview(separator)

    }
}
