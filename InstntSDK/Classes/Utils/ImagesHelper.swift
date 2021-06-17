//
//  ImagesHelper.swift
//  InstntSDK
//
//  Created by Nate Eckerson on 6/14/21.
//

import UIKit

struct ImagesHelper {
    static func image(named name: String) -> UIImage? {
        let podBundle = Bundle(for: Instnt.self)
        if let url = podBundle.url(forResource: "InstntSDK", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        } else {
            return nil
        }
    }
}
