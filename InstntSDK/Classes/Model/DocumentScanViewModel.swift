//
//  DocumentScanViewModel.swift
//  InstntSDK
//
//  Created by Jagruti Patel CW on 12/21/21.
//

import Foundation
public struct DocumentSettings {
    public init(documentType: documentType, documentSide: documentSide, captureMode: captureMode, backFocusThreshold: Int, nativeBackFocusThreshold: Int, backGlareThreshold: Float, nativeBackGlareThreshold: Float, backCaptureAttempts: Int) {
        self.documentType = documentType
        self.documentSide = documentSide
        self.captureMode = captureMode
        self.backFocusThreshold = backFocusThreshold
        self.nativeBackFocusThreshold = nativeBackFocusThreshold
        self.backGlareThreshold = backGlareThreshold
        self.nativeBackGlareThreshold = nativeBackGlareThreshold
        self.backCaptureAttempts = backCaptureAttempts
    }
    
    let documentType: documentType
    let documentSide: documentSide
    let captureMode: captureMode
    let backFocusThreshold: Int
    let nativeBackFocusThreshold: Int
    let backGlareThreshold: Float
    let nativeBackGlareThreshold: Float
    let backCaptureAttempts: Int
    
}

public enum documentType {
    case licence
    case passport
}

public enum documentSide  {
    case back
    case front
}

public enum captureMode {
    case automatic
    case manual
}

struct CaptureResult {
    let resultBase64: String
    let frontfocus: Bool?
    let frontGlare: Bool?
    let backfocus: Bool?
    let backGlare: Bool?
    let isFaceFaceDetected: Bool?
    let isBarcodeDetected: Bool?
}

struct CaptureResultData {
    let eventCount: Int
    let faceDetectionStatus: faceDetectionStatus
    let image: String
}

enum StatusCode: String {
    case noFaceFound = "no faces found"
    case badFocus = "bad focus"
    case badGlare = "bad glare"
    case noBarCode = "no BarCode"
}

enum faceDetectionStatus: String {
    case yes = "Yes"
    case no = "No"
    case disabled = "Disabled"
}

