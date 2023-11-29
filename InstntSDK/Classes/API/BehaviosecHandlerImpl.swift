//
//  BehaviosecHandlerImpl.swift
//  InstntSDK_Example
//
//  Created by Vipul Dungranee on 30/03/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public class BehaviosecHandlerImpl {
    public static let shared = BehaviosecHandlerImpl()
    
    // This is our custom array which will be used to keep multiple screens bdata when user navigater between screens.
    private static var allScreensBdata: [String] = []
    
    private var isSDKSetupDone = false
    
    private init() {
        
    }
    lazy var mJourneyId: String = {
        return UUID().uuidString
    }()
    
    func sendData (data: String) -> Void

        {

            print ("----------> SendData")

           // print (data)
            
            BehaviosecHandlerImpl.allScreensBdata.append(data)
            
            // add data in global array

        }
    
    func configure(application: UIApplication, view: UIViewController?) {
        
        /*
        let connector: BehavioSecConnector = BehavioSenseConnector.withBuilder { [weak self] builder in
            builder.url = Instnt.shared.behaviosecAPiUrl
            builder.tenantId = Instnt.shared.behaviosecTenantId
            builder.journeyId = self?.mJourneyId ?? UUID().uuidString
            builder.compressData = true
        }*/
        
        if(isSDKSetupDone) {
            BehaviosecHandlerImpl.allScreensBdata = []
            return
        }
        
        isSDKSetupDone = true
        
        let connectorNew: BehavioCallbackConnector = BehavioCallbackConnector.withBuilder { (builder) in
                            builder.callback = self.sendData(data:)

                        }
        
        let collector: BehavioSecCollector = BehavioSecCollector.withBuilder {  builder in
            
            //builder.connector = connector
            
            builder.connector = connectorNew
            
            builder.useAccessibilityLabelOrIdAsTrackingId = true
            
            builder.allowLogging = true
                                    
            //builder.includedViews = ["InstntSDK_Example.AddressVC, InstntSDK_Example.EmailPhoneVC, InstntSDK_Example.FirstLastNameVC, InstntSDK_Example.VerifyDataVC, InstntSDK_Example.VerifyData"]
            
            //builder.noSendingViews = ["InstntSDK_Example.AddressVC, InstntSDK_Example.EmailPhoneVC, InstntSDK_Example.FirstLastNameVC"]
            
            print("Behaviosec configure done")
            
        }
        
        // clear all screens data which we put in array to merge later
        BehaviosecHandlerImpl.allScreensBdata = []
        
        BehavioSecClient.startCollection(application, with: collector, with: view ?? UIViewController.init())
        
        //BehavioSecClient.startCollection(application, with: collector)
        
        BehavioSecClient.setNewJourneyId(mJourneyId)
        
    }
    
    func getData() -> String {
        
        //return BehavioSecIOSSDK.shared().getSummary()
        
        //merge function here
        // use global array
        
        BehaviosecHandlerImpl.allScreensBdata.append(BehavioSecClient.getData() ?? "")
        
        //print("last screen data - \(BehavioSecClient.getData())")
                
        //let mergedData = BehavioSecClient.merge(BehaviosecHandlerImpl.allScreensBdata, replaceWithPageId: "FormSubmission")
        
        //let mergedData = BehavioSecClient.getData() ?? ""
        
        let mergedData = BehavioUtils.merge(BehaviosecHandlerImpl.allScreensBdata, replaceWithPageId: "FormSubmission") ?? ""
        
        //BehaviosecHandlerImpl.allScreensBdata = []
        
        return mergedData
                        
        //return BehavioSecClient.getData()
        
    }
}
