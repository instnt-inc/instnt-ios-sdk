//
//  ErrorEntity.swift
//  InstntSDK
//
//  Created by Jagruti Patel CW on 12/10/21.
//

import Foundation
public enum ErrorConstants: Int {
    case error_CANCELLED_CAPTURE
    case error_CAPTURE
    case error_EXTERNAL
    case error_NO_CONNECTIVITY
    case error_NETWORK_TIMEOUT
    case error_PARSER
    case error_INVALID_OTP
}

open class InstntError: Error {
    public var errorConstant: ErrorConstants
    public var code: String?
    public var message: String?
    public var statusCode: Int = 999
    public var api: String?

    public init(errorConstant: ErrorConstants, code: String? = nil, message: String? = nil, statusCode: Int = 999) {
        self.code = code
        self.errorConstant = errorConstant
        self.message = message ?? self.getErrorMessage(errorConstant)
        self.statusCode = statusCode
    }
    func getErrorMessage(_ constant: ErrorConstants) -> String {
        var message: String = ""

        switch constant {
        case .error_CANCELLED_CAPTURE:
            message = NSLocalizedString("Document capture was cancelled", comment: "")
        case .error_CAPTURE:
            message = NSLocalizedString("There was error capturing the document, please try again", comment: "")
        case .error_NETWORK_TIMEOUT:
            message = NSLocalizedString("Network time out", comment: "")
        case .error_EXTERNAL:
            message = NSLocalizedString("We are experiencing technical issues, please try again later", comment: "")
        case .error_PARSER:
            message = NSLocalizedString("ERROR_PARSER", comment: "")
        case .error_NO_CONNECTIVITY:
            message = NSLocalizedString("ERROR_NO_CONNECTIVITY", comment: "")
        case .error_INVALID_OTP:
            message = NSLocalizedString("error_INVALID_OTP", comment: "")
        }

        return NSLocalizedString(message, comment: "Error Message")
    }
}
