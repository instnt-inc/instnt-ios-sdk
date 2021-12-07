//
//  DocumentScanViewController.swift
//  ActionSheetPicker-3.0
//
//  Created by Jagruti Patel CW on 12/6/21.
//

import UIKit
import CFDocumentScanSDK
import AVFoundation
import CoreLocation

class DocumentScanViewController: UIViewController {
    let locationManager = CLLocationManager()
    private lazy var scanHandler = DSHandler(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDocumentScan()
        setUpLocationUpdate()
    }
    
    func scanDocument() {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setUpDocumentScan() {
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
}

// MARK: - CLLocationManagerDelegate
extension DocumentScanViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager)
    {
        let status = CLLocationManager.authorizationStatus()
        handle(authorizationStatus: status)
    }
       
}

extension DocumentScanViewController: DSHandlerDelegate {
    func handleScan(result: DSResult) {
      print("Scan Result: \(result)")
    }
    
    func captureError(_ error: DSError) {
        print("Scan Error: \(error)")
    }
}
