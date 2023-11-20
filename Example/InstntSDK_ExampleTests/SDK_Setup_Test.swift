//
//  SDK_Setup_Test.swift
//  InstUnitTestTests
//
//  Created by mac Badhra on 28/03/23.
//

import XCTest
@testable import InstntSDK_Example
import InstntSDK

final class SDK_Setup_Test: XCTestCase {
    
    var testSuccessfull = false
    var transactionIDReturn = ""
    var UTConf = UTConfig()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_SDKSetup() {
        
        var myResult = false
        
        let expectation = XCTestExpectation(description: #function)
        
        Instnt.shared.setup(with: UTConf.SDKSetupFormKey, endPOint: UTConf.endPoint, completion: { result in
            
            switch result {
            case .success(let transactionID):
                print("transactionID : \(transactionID)")
//                ExampleShared.shared.transactionID = transactionID
                
                myResult = true
                
                self.transactionIDReturn = transactionID
                
                expectation.fulfill()
                
                //self.lblView?.lblText.text = "Set up is succeded with transaction Id \(transactionID)"
            case .failure(let error):
                
                print(error)
                
                myResult = false
                
                expectation.fulfill()
                
                //self.addResponse()
                //self.lblView?.lblText.text = "Set up is failed with \(error.message ?? ""), please try again later"

            }
        })
        
        wait(for: [expectation], timeout: 10.0)
        
        XCTAssertTrue(myResult)
        
//        return transactionIDReturn
    
    }
    
    func test_SDKSetup_Negative() {
        
        let expectation = XCTestExpectation(description: #function)
        
        Instnt.shared.setup(with: UTConf.SDKSetupFormKeyNegative, endPOint: UTConf.endPoint, completion: { result in
            
            switch result {
            case .success(_):
                XCTFail("Expected error on wrong workflow id but got succeed")
                
                expectation.fulfill()
                
                //self.lblView?.lblText.text = "Set up is succeded with transaction Id \(transactionID)"
            case .failure(let error):
                
                print(error)
                
                XCTAssert(true,"found Error Successfully when wrong workflow id")
                
                expectation.fulfill()
                
                //self.addResponse()
                //self.lblView?.lblText.text = "Set up is failed with \(error.message ?? ""), please try again later"

            }
        })
        
        wait(for: [expectation], timeout: 10.0)
        
//        XCTAssertTrue(myResult)
        
//        return transactionIDReturn
    
    }
}
