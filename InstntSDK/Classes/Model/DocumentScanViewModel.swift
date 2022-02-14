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
    case license = "License"
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
    let frontfocus: Bool?
    let frontGlare: Bool?
    let backfocus: Bool?
    let backGlare: Bool?
    let isFaceFaceDetected: Bool?
    let isBarcodeDetected: Bool?
    public let documentSide: DocumentSide?
    
    
    init(resultBase64: Data, frontfocus:Bool, frontGlare:Bool, backfocus:Bool, backGlare:Bool, isFaceFaceDetected:Bool, isBarcodeDetected:Bool, documentSide: DocumentSide) {
        self.resultBase64 = resultBase64
        self.frontfocus = frontfocus
        self.frontGlare = frontGlare
        self.backfocus = backfocus
        self.backGlare = backGlare
        self.isFaceFaceDetected = isFaceFaceDetected
        self.isBarcodeDetected = isBarcodeDetected
        self.documentSide = documentSide
    }
}

public class CaptureSelfieResult : NSObject{
    public var resultBase64: Data
    init(resultBase64: Data) {
        self.resultBase64 = resultBase64
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

