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
    let instnttxnid: String
    enum CodingKeys: String, CodingKey {
        case instnttxnid
    }
}

struct RequestGetUploadUrl: Encodable {
    let transactionType: String
    let documentType: String
    let docSuffix: String
    let transactionStatus: String

    enum CodingKeys: String, CodingKey {
        case transactionType = "transaction_attachment_type"
        case documentType = "document_type"
        case docSuffix = "doc_suffix"
        case transactionStatus = "transaction_status"
    }
}

struct VerifyDocument: Encodable {
    let formKey, documentType, instnttxnid: String
}

struct ResultverifyDocument: Decodable {
    
}

struct RequestSendOTP: Encodable {
    let requestData: String
    let isVerify: Bool
}

struct ResultSendOTP: Decodable {
    
}

struct RequestVerifyOTP: Encodable {
    let requestData: String
    let isVerify: Bool
}

struct ResultVerifyOTP: Decodable {
    
}
