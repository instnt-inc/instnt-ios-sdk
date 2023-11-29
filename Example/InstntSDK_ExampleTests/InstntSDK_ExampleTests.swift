//
//  InstntSDK_ExampleTests.swift
//  InstntSDK_ExampleTests
//
//  Created by Abhishek on 17/11/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
@testable import InstntSDK_Example
import InstntSDK

final class InstntSDK_ExampleTests: XCTestCase {
    
    let endPoint = "https://dev2-api.instnt.org/public"
    var testSuccessfull = false
    var transactionIDReturn = ""
    
    override func setUpWithError() throws {
        
        test_SDKSetup()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
    }
    
    // Just a test method to check we are able to access Insnt Libray methods
    func testSDKMethod() {
        
        let myResult =  Instnt.shared.testMethodToCheck() // true or false
        
        XCTAssertTrue(myResult)
        
    }
    
    // Test case to check Instnt SDK setup using form key and endpoint
    func test_SDKSetup() -> String {
        
        // Mock data
        let formKey = "v1679308618983151"
        let endPoint = "https://dev2-api.instnt.org/public"
        
        var myResult = false
        
        let expectation = XCTestExpectation(description: #function)
        
        Instnt.shared.setup(with: formKey, endPOint: endPoint, completion: { result in
            
            switch result {
            case .success(let transactionID):
                print("transactionID : \(transactionID)")
                ExampleShared.shared.transactionID = transactionID
                
                myResult = true
                
                self.transactionIDReturn = transactionID
                
                expectation.fulfill()
                
            case .failure(let error):
                
                print(error)
                
                myResult = false
                
                expectation.fulfill()
                
            }
        })
        
        wait(for: [expectation], timeout: 10.0)
        
        XCTAssertTrue(myResult)
        
        return transactionIDReturn
        
    }
    
    // Test case to check Instnt SDK setup using form key and endpoint
    func test_resumeSignup() -> String {
        
        // Mock data
        let formKey = "v1679308618983151"
        let transactionID = "2b58f07e-d34c-49c8-ae39-ec98c06ab5ce"
        
        var myResult = false
        
        let expectation = XCTestExpectation(description: #function)
        
        Instnt.shared.resumeSignup(view: UIViewController.init(), with: formKey , endPOint: self.endPoint , instnttxnid: transactionID, completion: { result in
            
            switch result {
            case .success(let transactionID):
                ExampleShared.shared.transactionID = transactionID
                myResult = true
                
                print("transactionID - \(transactionID)")
                
                self.transactionIDReturn = transactionID
                
                expectation.fulfill()
                
            case .failure(let error):
                
                print(error)
                
                myResult = false
                
                expectation.fulfill()
                
            }
        })
        
        
        wait(for: [expectation], timeout: 10.0)
        
        XCTAssertTrue(myResult)
        
        return transactionIDReturn
        
    }
    
    // Test case for send OTP method
    // Negative testing with incorrect phone number
    func test_SendOTP_Invalid () {
        
        // test case for send OTP function
        
        let transactionID = self.test_SDKSetup()
        
        let phone = "1111111111"
        
        let expectation = XCTestExpectation(description: #function)
        
        Instnt.shared.sendOTP(instnttxnid: transactionID, phoneNumber: phone, completion: { result in
            
            switch result {
                
            case .success:
                
                expectation.fulfill()
                
                self.testSuccessfull = true
                
            case .failure( let error):
                
                print(error)
                
                expectation.fulfill()
                
                self.testSuccessfull = false
                
            }
            
            // test run will fail if the result is not success or true
            
        })
        
        wait(for: [expectation], timeout: 10.0)
        
        XCTAssertFalse(self.testSuccessfull)
        
    }
    
    // Send OTP testing with valid phone number
    func test_SendOTP_Valid () {
        
        // test case for send OTP function
        
        let transactionID = self.test_SDKSetup()
        
        let phone = "+12064512559"
        
        let expectation = XCTestExpectation(description: #function)
        
        Instnt.shared.sendOTP(instnttxnid: transactionID, phoneNumber: phone, completion: { result in
            
            switch result {
                
            case .success:
                
                expectation.fulfill()
                
                self.testSuccessfull = true
                
            case .failure( let error):
                
                print(error)
                
                expectation.fulfill()
                
                self.testSuccessfull = false
                
            }
            
            // check resuls
            
            // test run will fail if the result is not success or true
            
        })
        
        wait(for: [expectation], timeout: 10.0)
        
        XCTAssertTrue(self.testSuccessfull)
        
    }
    
    // negative testing of verify OPT
    // Test case for verify OTP
    func test_verifyOTP() {
        
        let transactionID = self.test_SDKSetup()
        
        let otp = "111111"
        let phone = "+12012121212"
        
        let expectation = XCTestExpectation(description: #function)
        
        Instnt.shared.verifyOTP(instnttxnid: transactionID, phoneNumber: phone, otp: otp, completion: { result in
            
            switch result {
                
            case .success:
                
                expectation.fulfill()
                
                self.testSuccessfull = true
                
                
            case .failure(let error):
                
                print(error)
                
                expectation.fulfill()
                
                self.testSuccessfull = false
                
            }
            
            // This is a sample for negative testing
            
            // result should be false or error
            
            print("check - \(self.testSuccessfull)")
            
            //XCTAssertFalse(OTPsentSuccessfully)
            
        })
        
        wait(for: [expectation], timeout: 10.0)
        
        XCTAssertFalse(self.testSuccessfull)
        
    }
    
    func test_SignupSubmit() {
        
        let transactionID =  self.transactionIDReturn //self.test_SDKSetup()
        
        ExampleShared.shared.formData["physicalAddress"] = "NY St"
        ExampleShared.shared.formData["city"] = "NYC"
        ExampleShared.shared.formData["state"] = "NY"
        ExampleShared.shared.formData["zip"] = "10011"
        ExampleShared.shared.formData["country"] = "US"
        
        ExampleShared.shared.formData["email"] = "abc@test.com"
        ExampleShared.shared.formData["mobileNumber"] = "+12098383845"
        
        ExampleShared.shared.formData["firstName"] = "John"
        ExampleShared.shared.formData["surName"] = "Doe"
        
        let expectation = XCTestExpectation(description: #function)
        
        Instnt.shared.submitData(instnttxnid: transactionID, data: ExampleShared.shared.formData, completion: { result in
            switch result {
            case .success(let response):
                if response.success == true,
                   let decision = response.decision,
                   let jwt = response.jwt {
                    self.testSuccessfull = true
                    expectation.fulfill()
                } else {
                    if let msg = response.message {
                        self.testSuccessfull = true
                        expectation.fulfill()
                    } else {
                        self.testSuccessfull = true
                        expectation.fulfill()
                    }
                    
                }
            case .failure(let error):
                self.testSuccessfull = false
                expectation.fulfill()
            }
            
        })
        
        wait(for: [expectation], timeout: 15.0)
        
        XCTAssertTrue(self.testSuccessfull)
        
    }
    
    func test_VerifyTransaction() {
        
        let transactionID = self.test_SDKSetup()
        
        var formFieldsDic: [String: String] = [:]
        
        formFieldsDic["phone"] = "+12067564535"
        formFieldsDic["amount"] = "10"
        formFieldsDic["firstName"] = "John"
        formFieldsDic["surName"] = "Doe"
        formFieldsDic["notes"] = "Test Notes"
        
        ExampleShared.shared.formData["form_fields"] = formFieldsDic
        
        ExampleShared.shared.formData["user_action"] = "MONEY_TRANSFER"
        
        let expectation = XCTestExpectation(description: #function)
        
        Instnt.shared.submitVerifyData(instnttxnid: transactionID, data: ExampleShared.shared.formData, completion: { result in
            
            switch result {
                
            case .success(let response):
                
                var myResponse: [String: Any]?
                
                myResponse = response.rawJSON
                
                if let decision = myResponse?["decision"] {
                    
                    self.testSuccessfull = true
                    expectation.fulfill()
                    
                } else {
                    print("response - \(response)")
                    if let msg = response.decision {
                        self.testSuccessfull = true
                        expectation.fulfill()
                    } else {
                        self.testSuccessfull = true
                        expectation.fulfill()
                    }
                    
                }
            case .failure(let error):
                self.testSuccessfull = false
                expectation.fulfill()
            }
            
        })
        
        wait(for: [expectation], timeout: 15.0)
        
        XCTAssertTrue(self.testSuccessfull)
        
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
        
        test_DocumentUpload()
        
        let expectation = self.expectation(description: "image verify successfully")
        
        Instnt.shared.verifyDocuments(instnttxnid: self.transactionIDReturn, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    XCTAssert(true,"Document Verification Successfully")
                    expectation.fulfill()
                case .failure(let error):
                    print("error --- \(error)")
                    XCTAssert(false,"Document Verification Failed With \(error)")
                    expectation.fulfill()
                }
            }
        })
        
        self.waitForExpectations(timeout: 15.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error)")
            }
        }
        
        test_SignupSubmit()
    }
    
    //TODO: Selfie, document upload, behavsec testing
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_SDKSetup_Negative() {
        
        // Mock data
        let formKey = "v167930861877463778"
        let endPoint = "https://dev2-api.instnt.org/public"
        
        
        let expectation = XCTestExpectation(description: #function)
        
        Instnt.shared.setup(with: formKey, endPOint: endPoint, completion: { result in
            
            switch result {
            case .success(_):
                XCTFail("Expected error on wrong workflow id but got succeed")
                
                expectation.fulfill()
                
            case .failure(let error):
                
                print(error)
                
                XCTAssert(true,"found Error Successfully when wrong workflow id")
                
                expectation.fulfill()
                
                
            }
        })
        
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    func test_verifyDocuments_Negative() {
        Instnt.shared.verifyDocuments(instnttxnid: "", completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    XCTFail("Expected error on nill transection id but got succeed")
                case .failure(let error):
                    XCTAssert(true,"Document Verification Failed With \(error)")
                }
            }
        })
    }
    
    func test_resumeSignup_Negative() {
        
        // Mock data
        let formKey = "v167930861898315167"
        let transactionID = "2b58f07e-d34c-49c8-ae39-ec98c06ab5ceeerrr"
        
        
        let expectation = XCTestExpectation(description: #function)
        
        Instnt.shared.resumeSignup(view: UIViewController.init(), with: formKey , endPOint: self.endPoint , instnttxnid: transactionID, completion: { result in
            
            switch result {
            case .success(_):
                XCTFail("Expected error on incorrect FormKey & transactionID but got succeed")
                
            case .failure(_):
                
                XCTAssert(true, "Successfully found an Error")
                expectation.fulfill()
                
            }
        })
        
        
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    func test_SignupSubmit_Negative() {
        
        let expectation = XCTestExpectation(description: #function)
        
        Instnt.shared.submitData(instnttxnid: self.transactionIDReturn, data: ["":""], completion: { result in
            switch result {
            case .success(_):
                XCTFail("Expected error on empty data but got succeed")
            case .failure(_):
                XCTAssert(true, "Successfully found an Error when empty Data")
                expectation.fulfill()
            }
            
        })
        
        wait(for: [expectation], timeout: 15.0)
        
    }
    
    func test_VerifyTransaction_Negative() {
        
        let expectation = XCTestExpectation(description: #function)
        
        Instnt.shared.submitVerifyData(instnttxnid: "", data: ["":""], completion: { result in
            
            switch result {
                
            case .success(_):
                XCTFail("Expected error on wrong data & empty ID but got succeed")
                
            case .failure(_):
                XCTAssert(true, "Successfully found an Error when wrong Data")
                expectation.fulfill()
            }
            
        })
        
        wait(for: [expectation], timeout: 20.0)
        
        
    }
    
}
