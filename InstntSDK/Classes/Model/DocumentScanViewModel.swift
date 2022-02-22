//
//  DocumentScanViewModel.swift
//  InstntSDK
//
//  Created by Jagruti Patel CW on 12/21/21.
//

import Foundation
public struct DocumentSettings {
    public init(documentType: DocumentType, documentSide: DocumentSide, captureMode: CaptureMode, isAutoUpload: Bool) {
        self.documentType = documentType
        self.documentSide = documentSide
        self.captureMode = captureMode
    }
    
    public let documentType: DocumentType
    public let documentSide: DocumentSide
    public let captureMode: CaptureMode
}

public enum DocumentType: String {
    case license = "License"
}

public enum DocumentSide  {
    case back
    case front
}

public enum SelfieType  {
    case back
    case front
}

public enum CaptureMode {
    case automatic
    case manual
}

public class CaptureResult {    
    public var resultBase64: Data
    let isFaceFaceDetected: Bool?
    let isBarcodeDetected: Bool?
    public let documentSide: DocumentSide?
    public let isAutoUpload: Bool?
    
    
    init(resultBase64: Data, isFaceFaceDetected:Bool, isBarcodeDetected:Bool, documentSide: DocumentSide, isAutoUpload: Bool) {
        self.resultBase64 = resultBase64
        self.isFaceFaceDetected = isFaceFaceDetected
        self.isBarcodeDetected = isBarcodeDetected
        self.documentSide = documentSide
        self.isAutoUpload = isAutoUpload
    }
}

public class CaptureSelfieResult : NSObject{
    public var selfieData: Data
    public var farSelfieData: Data?
    public let isAutoUpload: Bool?
    
    init(selfieData: Data, farSelfieData: Data? = nil, isAutoUpload: Bool) {
        self.selfieData = selfieData
        self.farSelfieData = farSelfieData
        self.isAutoUpload = isAutoUpload
    }
}

public class InstntImageData: NSObject {
    public let data: Data?
    public let isSelfie: Bool
    public let documentType: DocumentType
    public let documentSide: DocumentSide?
    
    init(data: Data?, isSelfie: Bool, documentType: DocumentType, documentSide: DocumentSide?) {
        self.data = data
        self.isSelfie = isSelfie
        self.documentSide = documentSide
        self.documentType = documentType
    }
}

public enum StatusCode: String {
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

