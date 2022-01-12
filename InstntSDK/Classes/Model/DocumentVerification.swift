//
//  DocumentVerification.swift
//  InstntSDK
//
//  Created by Jagruti Patel CW on 12/21/21.
//

import Foundation

struct CreateTransaction: Encodable {
    let formKey: String
    let hideFormFields: Bool
    let idmetricsVersion, format: String
    let redirect: Bool

    enum CodingKeys: String, CodingKey {
        case formKey = "form_key"
        case hideFormFields = "hide_form_fields"
        case idmetricsVersion = "idmetrics_version"
        case format, redirect
    }
}

struct ResultCreateTransaction: Decodable {
    
}

struct CreateTransactionAttachment: Encodable {
    let formKey: String
    let hideFormFields: Bool
    let idmetricsVersion, format: String
    let redirect: Bool

    enum CodingKeys: String, CodingKey {
        case formKey = "form_key"
        case hideFormFields = "hide_form_fields"
        case idmetricsVersion = "idmetrics_version"
        case format, redirect
    }
}

struct ResultCreateTransactionAttachment: Decodable {
    
}

struct VerifyDocument: Encodable {
    let formKey, documentType, instnttxnid, documentFrontImage: String
    let documentBackImage, selfieImage: String
}

struct ResultverifyDocument: Decodable {
    
}
