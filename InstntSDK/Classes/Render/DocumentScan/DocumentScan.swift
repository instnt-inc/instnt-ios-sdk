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
    func onSelfieScanCancelled(error: InstntError)
    func onSelfieScanFinish(captureResult: CaptureSelfieResult)
}

class DocumentScan: NSObject {
    static let shared = DocumentScan()
    private let locationManager = CLLocationManager()
    private lazy var scanHandler = DSHandler(delegate: self)
    weak var documentScanDelegate: DocumentScanDelegate? = nil
    weak var selfieScandelegate: SelfieScanDelegate? = nil
    
    private override init() {
        super.init()
        setUpDocumentScan()
        setUpLocationUpdate()
    }
    
    private func setUpDocumentScan() {
        
        //DSCapture.setLicense(key: "AwFuEf5j3YXwEACwj9eE4w6RGWQ0zgPbjGmu+Xw684ryGP3GicSEE7ZYB0FAhoikRH3imeR02U7kuT4OjVL5B1s3JhBrPY9KWU9sgCVmTIW0r7ehq9CvTjTBfaR7NTCV179MlNeDbEzwh5FSD8ROc3Zq")
        
        DSCapture.setLicense(key: "AwG5mCdqXkmCj9oNEpGV8UauciP8s4cqFT848FfjUjwAZQJfa8ZvrEpmYsPME0RTo/Q0kRowDCGz7HPhfSdyeE7rOLtB3JAhuABdQ2R7dGhVy2EUdt5ENQBBIoveIZdf1pwVY2EUgDoGm8REDU+rr2C2")
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            // Already Authorized
        }
        else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted == true {
                    // User granted access. Let the app continue.
                }
                else {
                    // User denied access. The SDK may not continue.
                }
            }
        }
    }
    
    func setUpLocationUpdate() {
        // Handle authorization changes
        locationManager.delegate = self
        
        // Get the current permission
        let status = CLLocationManager.authorizationStatus()
        handle(authorizationStatus: status)
    }
    
    private func handle(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            // We have not yet requested permission
            locationManager.requestWhenInUseAuthorization()
            return
        case .authorizedAlways, .authorizedWhenInUse:
            // We already have permission and can proceed
            break
        default: break
            // User has denied permission, or parental / MDM settings
            // disallow it. The SDK will still function.
        }
    }
    
    func scanDocument(from vc: UIViewController, documentSettings: DocumentSettings, delegate:DocumentScanDelegate) {
        self.documentScanDelegate = delegate
        if documentSettings.documentType == .passport {
            let options = DSPassportOptions()
            options.captureMode = .Auto
            
            scanHandler.options = options
            vc.present(scanHandler.scanController, animated: true)
            scanHandler.start()

        } else if documentSettings.documentType == .licence {
            
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
        // passthose results back to the delegate as CaptureResult
        let img = result.image
        let strBase64 = img!.base64EncodedData()
        
        var focus : Bool!
        if result.captureAnalysis.focus > 0.6 {
            focus = true
        } else {
            focus = false
        }
        
        let capture = CaptureResult(resultBase64: strBase64, frontfocus: focus, frontGlare: false, backfocus: focus, backGlare: false, isFaceFaceDetected: result.captureAnalysis.faceDetected, isBarcodeDetected: false)
        documentScanDelegate?.onDocumentScanFinish(captureResult: capture)
    }
    
    func captureError(_ error: DSError) {
        let error = InstntError(errorConstant: .error_CAPTURE)
        documentScanDelegate?.onDocumentScanCancelled(error: error)
    }
}

extension DocumentScan: CFASelfieScanDelegate {
    func onFinishSelfieScan(_ selfieScanData: CFASelfieScanData!) {
        let selfieResult = CaptureSelfieResult(resultBase64: selfieScanData.selfieData)
        selfieScandelegate?.onSelfieScanFinish(captureResult: selfieResult)
    }

    func onCancelSelfieScan() {
        
    }

    func onFinishSelfieScanWithError(_ errorCode: Int32, errorMessage: String!) {

    }

}
