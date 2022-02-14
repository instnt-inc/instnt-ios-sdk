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
}

public protocol SelfieScanDelegate: NSObjectProtocol {
    func onSelfieScanCancelled()
    func onSelfieScanFinish(captureResult: CFASelfieScanData)
    func onSelfieScanError(error: InstntError)
}

class DocumentScan: NSObject {
    static let shared = DocumentScan()
    private let locationManager = CLLocationManager()
    private lazy var scanHandler = DSHandler(delegate: self)
    weak var documentScanDelegate: DocumentScanDelegate? = nil
    weak var selfieScandelegate: SelfieScanDelegate? = nil
    
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
    
    func scanDocument(licenseKey: String, from vc: UIViewController, documentSettings: DocumentSettings, delegate:DocumentScanDelegate) {
        
        //DSCapture.setLicense(key: "AwG5mCdqXkmCj9oNEpGV8UauciP8s4cqFT848FfjUjwAZQJfa8ZvrEpmYsPME0RTo/Q0kRowDCGz7HPhfSdyeE7rOLtB3JAhuABdQ2R7dGhVy2EUdt5ENQBBIoveIZdf1pwVY2EUgDoGm8REDU+rr2C2")
        
        DSCapture.setLicense(key: licenseKey)
        self.documentScanDelegate = delegate
        if documentSettings.documentType == .license {
            
            let options = DSID1Options()
            options.side = documentSettings.documentSide == .back ? .Back: .Front
            options.detectFace = documentSettings.documentSide == .front ? true: false
            options.captureMode = documentSettings.captureMode == .automatic ? .Auto: .Manual
            options.detectBarcodeOrMRZ = documentSettings.documentSide == .back ? true: false
            options.showReviewScreen = true
            scanHandler.options = options
            vc.present(scanHandler.scanController, animated: true)
            scanHandler.start()
        }
//        if documentSettings.documentType == .passport {
//            let options = DSPassportOptions()
//            options.captureMode = .Auto
//            
//            scanHandler.options = options
//            vc.present(scanHandler.scanController, animated: true)
//            scanHandler.start()
//
//        }
    }
    
    func scanSelfie(from vc: UIViewController, delegate: SelfieScanDelegate) {
        let settings = CFASelfieSettings()
        settings?.showConfirmationScreen = true
        settings?.captureMode = .ManualCapture
        settings?.enableFarSelfie = true
        self.selfieScandelegate = delegate
        if let selfieScan = CFASelfieController.sharedInstance() as? CFASelfieController {
            selfieScan.scanSelfie(vc, selfieSettings: settings, selfieScanDelegate: self)
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
        guard let result = result as? DSID1Result else {
            return
        }
        let documentSide: DocumentSide = result.side == .Front ? .front: .back
        let img = result.image
        let strBase64 = img!.base64EncodedData()
        let barCodeDetected = result.barcodeDetected
        let faceDetected = result.captureAnalysis.faceDetected
        
        var focus : Bool!
        if result.captureAnalysis.focus > 0.6 {
            focus = true
        } else {
            focus = false
        }
        let capture = CaptureResult(resultBase64: strBase64, frontfocus: focus, frontGlare: false, backfocus: focus, backGlare: false, isFaceFaceDetected: faceDetected, isBarcodeDetected: barCodeDetected, documentSide: documentSide)
        documentScanDelegate?.onDocumentScanFinish(captureResult: capture)
    }
    
    func captureError(_ error: DSError) {
        let error = InstntError(errorConstant: .error_DOCUMENT_CAPTURE, message: error.message)
        documentScanDelegate?.onDocumentScanCancelled(error: error)
    }
}

extension DocumentScan: CFASelfieScanDelegate {
    func onFinishSelfieScanWithError(_ errorCode: Int32, errorMessage: String!) {
        selfieScandelegate?.onSelfieScanError(error: InstntError(errorConstant: .error_SELFIE_CAPTURE, message: errorMessage, statusCode: Int(errorCode)))
    }
    
    func onFinishSelfieScan(_ selfieScanData: CFASelfieScanData!) {
        //let selfieResult = CaptureSelfieResult(resultBase64: selfieScanData.selfieData)
        selfieScandelegate?.onSelfieScanFinish(captureResult: selfieScanData)
    }

    func onCancelSelfieScan() {
        selfieScandelegate?.onSelfieScanCancelled()
    }
}
