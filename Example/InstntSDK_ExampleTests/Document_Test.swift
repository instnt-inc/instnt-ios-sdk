//
//  Document_Test.swift
//  InstUnitTestTests
//
//  Created by mac Badhra on 28/03/23.
//

import XCTest
@testable import InstntSDK_Example
import InstntSDK

final class Document_Test: XCTestCase {
    
    let endPoint = "https://dev2-api.instnt.org/public"
    var testSuccessfull = false
    var transactionIDReturn = ""
    var SDK_Setup = SDK_Setup_Test()

    override func setUpWithError() throws {
        SDK_Setup.test_SDKSetup()
        self.transactionIDReturn = SDK_Setup.transactionIDReturn
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_DocumentUpload() {
        // Load the test file from the project
        guard let image = UIImage(named: "license_v2"),
              let imageData = image.pngData()
        else {
            XCTFail("Failed to load test file")
            return
        }
        
        let expectation = self.expectation(description: "image upload successfully")
        
        Instnt.shared.uploadAttachment(instnttxnid: self.transactionIDReturn, data: imageData, isSelfie: false, isFront: true, documentType: .license) { result in
            switch result {
            case .success(_):
                print("success")
                XCTAssert(true,"Document Uploaded Successfully")
                expectation.fulfill()
                
            case .failure(let error):
                print("uploadAttachment error \(error)")
                XCTAssert(false,"Document Upload Failed")
                expectation.fulfill()
            }
        }
        
        // Wait for the expectation to be fulfilled within 5 seconds
        self.waitForExpectations(timeout: 15.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error)")
            }
        }
    }


    func test_verifyDocuments() {
        Instnt.shared.verifyDocuments(instnttxnid: self.transactionIDReturn, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    XCTAssert(true,"Document Verification Successfully")
                case .failure(let error):
                    XCTAssert(false,"Document Verification Failed With \(error)")
                }
            }
        })
    }
    
    func test_verifyDocuments_Negative() {
        Instnt.shared.verifyDocuments(instnttxnid: "", completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    XCTFail("Expected error on nill transection id but got succeed - \(result)")
                case .failure(let error):
                    XCTAssert(true,"Document Verification Failed With \(error)")
                }
            }
        })
    }

}
