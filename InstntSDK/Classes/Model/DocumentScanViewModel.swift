//
//  DocumentScanViewModel.swift
//  InstntSDK
//
//  Created by Jagruti Patel CW on 12/21/21.
//

import Foundation
public struct DocumentSettings {
    public init(documentType: DocumentType, documentSide: DocumentSide, captureMode: CaptureMode) {
        self.documentType = documentType
        self.documentSide = documentSide
        self.captureMode = captureMode
    }
    
    let documentType: DocumentType
    let documentSide: DocumentSide
    let captureMode: CaptureMode
}

public enum DocumentType: String {
    case licence = "Licence"
    case passport = "Passport"
}

public enum DocumentSide  {
    case back
    case front
}

public enum CaptureMode {
    case automatic
    case manual
}

public class CaptureResult : NSObject{    
    public var resultBase64: Data
    var frontfocus: Bool?
    var frontGlare: Bool?
    var backfocus: Bool?
    var backGlare: Bool?
    var isFaceFaceDetected: Bool?
    var isBarcodeDetected: Bool?
    
    init(resultBase64: Data, frontfocus:Bool, frontGlare:Bool, backfocus:Bool, backGlare:Bool, isFaceFaceDetected:Bool, isBarcodeDetected:Bool) {
        self.resultBase64 = resultBase64
        self.frontfocus = frontfocus
        self.frontGlare = frontGlare
        self.backfocus = backfocus
        self.backGlare = backGlare
        self.isFaceFaceDetected = isFaceFaceDetected
        self.isBarcodeDetected = isBarcodeDetected

    }
}

public class CaptureResultData: NSObject {
    var eventCount: Int
    var faceDetectionStatus: faceDetectionStatus
    var image: String
    
    init(eventCount:Int, faceDetectionStatus:faceDetectionStatus, image:String) {
        self.eventCount = eventCount
        self.faceDetectionStatus = faceDetectionStatus
        self.image = image
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

