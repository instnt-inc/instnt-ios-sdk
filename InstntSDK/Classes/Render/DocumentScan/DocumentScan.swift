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



class DocumentScan: NSObject {
    static let shared = DocumentScan()
    private let locationManager = CLLocationManager()
    private lazy var scanHandler = DSHandler(delegate: self)
    
    private override init() {
        super.init()
        setUpDocumentScan()
        setUpLocationUpdate()
    }
    
    private func setUpDocumentScan() {
        
        DSCapture.setLicense(key: "AwFuEf5j3YXwEACwj9eE4w6RGWQ0zgPbjGmu+Xw684ryGP3GicSEE7ZYB0FAhoikRH3imeR02U7kuT4OjVL5B1s3JhBrPY9KWU9sgCVmTIW0r7ehq9CvTjTBfaR7NTCV179MlNeDbEzwh5FSD8ROc3Zq")
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
    
    public func scanDocument(options: DSOptions) {
        // rear facing camera
        // original defination: capture.scanDocument(documentSettings, captureResult);
        // pass those settings to scanHandler
        
        //       let options = DSID1Options()
        //options.side = .Back
        //options.detectFace = true
        //options.captureMode = .Auto
        
        scanHandler.options = options
        //present(scanHandler.scanController, animated: true)
        scanHandler.start()
    }
    
    func scanSelfie() {
        // front facing camera facing camera
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
      print("Scan Result: \(result)")
        
        
       /* A DSResult also contains a detailed capture analysis. Combined with the image data, these fields allow you to decide which images, if any, are valid for processing.

        Property
        Description
        isImageCropped
        Indicates if the SDK was able to crop the non flash image or not
        isFlashImageCropped
        Indicates if the SDK was able to crop the flash image or not
        confidence
        Indicates SDK’s confidence level on the image quality. Value ranges between 0 and 1. Recommended 0.60 +
        captureAnalysis.distanceConfidence
        Indicates SDK’s confidence level on the distance between the camera and Document. Value ranges between 0 and 1. Recommended 0.60 +
        captureAnalysis.faceDetected
        Indicates if the SDK could see a human face in the document image. */
        
        // More
        
        //file:///Users/ac31tzz/Learn/CFDocumentScanSDK-Documentation-5.5.3/guides/parsing-responses.html
    }
    
    func captureError(_ error: DSError) {
        
        print("Scan Error: \(error)")
        
    }
}
