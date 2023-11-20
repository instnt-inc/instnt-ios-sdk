//
//  DocumentScan.swift
//  InstntSDK
//
//  Created by Jagruti Patel CW on 12/6/21.
//

import Foundation
import CFDocumentScanSDK
import AVFoundation
import CoreLocation
import IDMetricsSelfieCapture

public protocol DocumentScanDelegate: NSObjectProtocol {
    func onDocumentScanFinish(captureResult: CaptureResult)
    func onDocumentScanCancelled(error: InstntError)
    func onDocumentScanFailedVerification(error: InstntError)
    func onDocumentScanError(error: InstntError)
}

public protocol SelfieScanDelegate: NSObjectProtocol {
    func onSelfieScanCancelled()
    func onSelfieScanFinish(captureResult: CaptureSelfieResult)
    func onSelfieScanError(error: InstntError)
    func onSelfieScanFailedVerification(error: InstntError)
}

class DocumentScan: NSObject {
    static let shared = DocumentScan()
    private let locationManager = CLLocationManager()
    private lazy var scanHandler = DSHandler(delegate: self)
    weak var documentScanDelegate: DocumentScanDelegate? = nil
    weak var selfieScandelegate: SelfieScanDelegate? = nil
    private var isAutoUpload: Bool = true
    
    private override init() {
        super.init()
        setUpScanPermission()
        setUpLocationUpdate()
    }
    
    private func setUpScanPermission() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            
        }
        else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted == true {
                }
                else {
                    
                }
            }
        }
    }
    
    private func setUpLocationUpdate() {
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        handle(authorizationStatus: status)
    }
    
    private func handle(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
        default: break
        }
    }
    
    func scanDocument(licenseKey: String, from vc: UIViewController, documentSettings: DocumentSettings, delegate:DocumentScanDelegate, isAutoUpload: Bool? = true) {
        self.isAutoUpload  = isAutoUpload ?? true
        DSCapture.setLicense(key: licenseKey)
        self.documentScanDelegate = delegate
        if documentSettings.documentType == .license {
            
            let options = DSID1Options()
            options.side = documentSettings.documentSide == .back ? .Back: .Front
            options.detectFace = documentSettings.documentSide == .front ? true: false
            options.captureMode = documentSettings.captureMode == .auto ? .Auto: .Manual
            
            print("mode - \(options.captureMode)")
            
            if documentSettings.captureMode == .auto {
                options.autoCaptureTimeoutDuration = 10
            }
            options.detectBarcodeOrMRZ = documentSettings.documentSide == .back ? true: false
            options.showReviewScreen = true
            scanHandler.options = options
            print("Start scan")
            vc.present(scanHandler.scanController, animated: true)
            scanHandler.start()
        }
        if documentSettings.documentType == .passport {
            let options = DSPassportOptions()
            options.detectMRZ = true
            if documentSettings.captureMode == .auto {
                options.autoCaptureTimeoutDuration = 10
            }
            options.showReviewScreen = true
            scanHandler.options = options
            vc.present(scanHandler.scanController, animated: true)
            scanHandler.start()
        }
    }
    
    func scanSelfie(from vc: UIViewController, delegate: SelfieScanDelegate, settings: SelfieSettings) {
        print("DocumentScan scanSelfie")
        self.isAutoUpload  = settings.isAutoUpload
        let selfieSettings = CFASelfieSettings()
        selfieSettings?.showConfirmationScreen = true
        selfieSettings?.captureMode = settings.isAutoCapture ? .AutoCapture: .ManualCapture
        selfieSettings?.resetTimeOutInSec = 10
        selfieSettings?.enableFarSelfie = settings.isFarSelfie ? true: false
        self.selfieScandelegate = delegate
        if let selfieScan = CFASelfieController.sharedInstance() as? CFASelfieController {
            selfieScan.scanSelfie(vc, selfieSettings: selfieSettings, selfieScanDelegate: self)
        }
    }
}

extension DocumentScan: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager)
    {
        let status = CLLocationManager.authorizationStatus()
        handle(authorizationStatus: status)
    }
       
}

extension DocumentScan: DSHandlerDelegate {
    func handleScan(result: DSResult) {
        
        print("handleScan")
     if let result = result as? DSID1Result {
         print("DocumentScan handleScan DSID1Result")
            let documentSide: DocumentSide = result.side == .Front ? .front: .back

         print(result.image)

         NSLog("Result image is \(result.image)")
         NSLog("Result croppedImage is \(result.croppedImage)")
         NSLog("Result originalImage is \(result.originalImage)")
         NSLog("Result originalFlashImage is \(result.originalFlashImage)")
         NSLog("Result uncroppedImage is \(result.uncroppedImage)")

            guard let img = result.image else { return  }
            let barCodeDetected = result.barcodeDetected
            let faceDetected = result.captureAnalysis.faceDetected


//            if documentSide == .front && !faceDetected {
//                let error = InstntError(errorConstant: .error_FACE_UNDETECTED)
//                documentScanDelegate?.onDocumentScanFailedVerification(error: error)
//            }
//            if documentSide == .back && !barCodeDetected {
//                let error = InstntError(errorConstant: .error_BARCODE_UNDETECTED)
//                documentScanDelegate?.onDocumentScanFailedVerification(error: error)
//            }

         let capture = CaptureResult(resultBase64: img,  isFaceFaceDetected: faceDetected, isBarcodeDetected: barCodeDetected, documentSide: documentSide, isAutoUpload: isAutoUpload, isMrzDetected: nil, documentType: .license)
            documentScanDelegate?.onDocumentScanFinish(captureResult: capture)

        } else if let passportResult = result as? CFDocumentScanSDK.DSPassportResult {
            print("DocumentScan handleScan DSPassportResult")
            let mrzDetected = passportResult.mrzDetected
//            if mrzDetected == false {
//                let error = InstntError(errorConstant: .error_MRZ_UNDETECTED)
//                documentScanDelegate?.onDocumentScanFailedVerification(error: error)
//                return
//            }
            guard let img = result.image else { return  }
            let faceDetected = passportResult.captureAnalysis.faceDetected

            let capture = CaptureResult(resultBase64: img,  isFaceFaceDetected: faceDetected, isBarcodeDetected: nil, documentSide: .front, isAutoUpload: isAutoUpload, isMrzDetected: mrzDetected, documentType: .passport)
            documentScanDelegate?.onDocumentScanFinish(captureResult: capture)
        }

        print("result - \(result)")
        NSLog("result - \(result)")
        
    }
    
    func captureError(_ error: DSError) {
        
        print("captureError")
        
        print(error)
        NSLog("Result error is \(error)")
        
        let error = InstntError(errorConstant: .error_DOCUMENT_CAPTURE, message: error.message)
        documentScanDelegate?.onDocumentScanError(error: error)
    }
    
    func scanWasCancelled() {
        print("scanWasCancelled")

        
        let error = InstntError(errorConstant: .error_DOCUMENT_CAPTURE_CANCELLED)
        documentScanDelegate?.onDocumentScanCancelled(error: error)
    }
    
}

extension DocumentScan: CFASelfieScanDelegate {
    func onFinishSelfieScanWithError(_ errorCode: Int32, errorMessage: String!) {
        selfieScandelegate?.onSelfieScanError(error: InstntError(errorConstant: .error_SELFIE_CAPTURE, message: errorMessage, statusCode: Int(errorCode)))
    }
    
    func onFinishSelfieScan(_ selfieScanData: CFASelfieScanData!) {
        let selfieResult = CaptureSelfieResult(selfieData: selfieScanData.selfieData, farSelfieData: selfieScanData.farSelfieData, isAutoUpload: isAutoUpload)
        selfieScandelegate?.onSelfieScanFinish(captureResult: selfieResult)
    }

    func onCancelSelfieScan() {
        selfieScandelegate?.onSelfieScanCancelled()
    }
}
