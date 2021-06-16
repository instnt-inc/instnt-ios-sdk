//
//  ImagesHelper.swift
//  SwiftyInstnt
//
//  Created by Admin on 6/14/21.
//

import UIKit

struct ImagesHelper {
    static func image(named imageName: String) -> UIImage? {
        return UIImage.init(named: imageName, in: Bundle(for: SwiftyInstnt.self), compatibleWith: nil)
    }
}
