//
//  Verify_And_OTP_Test.swift
//  InstUnitTestTests
//
//  Created by mac Badhra on 28/03/23.
//

import XCTest
@testable import InstntSDK_Example
import InstntSDK

final class Verify_And_OTP_Test: XCTestCase {

    var testSuccessfull = false
    var transactionIDReturn = ""
    var SDK_Setup = SDK_Setup_Test()
    var UTConf = UTConfig()

    override func setUpWithError() throws {
        SDK_Setup.test_SDKSetup()
        self.transactionIDReturn = SDK_Setup.transactionIDReturn
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_SendOTP_Valid () {
        
        // test case for send OTP function
        
        let expectation = XCTestExpectation(description: #function)
        
        Instnt.shared.sendOTP(instnttxnid: self.transactionIDReturn, phoneNumber: UTConf.validPhone , completion: { result in
                        
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
    
    func test_SendOTP_Invalid () {
        
        // test case for send OTP function
        
        
        let expectation = XCTestExpectation(description: #function)
        
        Instnt.shared.sendOTP(instnttxnid: self.transactionIDReturn, phoneNumber: UTConf.inValidPhone, completion: { result in
                        
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
        
        XCTAssertFalse(self.testSuccessfull)
        
    }
    
    func test_verifyOTP() {
        
        let expectation = XCTestExpectation(description: #function)
                
        Instnt.shared.verifyOTP(instnttxnid: self.transactionIDReturn, phoneNumber: UTConf.verifyOtpPhone, otp: UTConf.verifyOtp, completion: { result in
            
            switch result {
                
            case .success:
                
                print("step 5")
                
                expectation.fulfill()
                
                self.testSuccessfull = true
                
                
            case .failure(let error):
                
                print(error)
                
                print("step 3")
                
                expectation.fulfill()
                
                self.testSuccessfull = false
                
            }
            
            // This is a sample for negative testing
            
            // result should be false or error
            
            print("step 4 - \(self.testSuccessfull)")
            
            //XCTAssertFalse(OTPsentSuccessfully)
            
        })
        
        wait(for: [expectation], timeout: 10.0)

        XCTAssertFalse(self.testSuccessfull)
        
    }
    
    func test_VerifyTransaction() {
        
        let expectation = XCTestExpectation(description: #function)
        
        Instnt.shared.submitVerifyData(instnttxnid: self.transactionIDReturn, data: UTConf.verifyTransactionData, completion: { result in
            
            switch result {
                
            case .success(let response):
                
                var myResponse: [String: Any]?
                
                myResponse = response.rawJSON
                
                if (myResponse?["decision"]) != nil {
                    
                    self.testSuccessfull = true
                    expectation.fulfill()
                    
                } else {
                    print("response - \(response)")
                    if response.decision != nil {
                        self.testSuccessfull = true
                        expectation.fulfill()
                    } else {
                        self.testSuccessfull = true
                        expectation.fulfill()
                    }
                    
                }
            case .failure(_):
                self.testSuccessfull = false
                expectation.fulfill()
            }
           
        })
        
        wait(for: [expectation], timeout: 15.0)
        
        XCTAssertTrue(self.testSuccessfull)
        
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
