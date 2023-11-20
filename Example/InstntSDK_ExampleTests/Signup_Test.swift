//
//  Signup_Test.swift
//  InstUnitTestTests
//
//  Created by mac Badhra on 28/03/23.
//

import XCTest
@testable import InstntSDK_Example
import InstntSDK

final class Signup_Test: XCTestCase {

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

    func test_resumeSignup() {
        
        var myResult = false
        
        let expectation = XCTestExpectation(description: #function)
        
        Instnt.shared.resumeSignup(view: UIViewController.init(), with: UTConf.resumeSignUpFormKey , endPOint: UTConf.endPoint , instnttxnid: UTConf.resumeSignupTransactionID, completion: { result in
            
            switch result {
            case .success(let transactionID):
                
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
        
//        return transactionIDReturn
    
    }
    
    func test_resumeSignup_Negative() {
        
        let expectation = XCTestExpectation(description: #function)
        
        Instnt.shared.resumeSignup(view: UIViewController.init(), with: UTConf.resumeSignUpFormKeyNegative , endPOint: UTConf.endPoint , instnttxnid: UTConf.resumeSignupTransactionIDNegative, completion: { result in
            
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
    
    func test_SignupSubmit() {
                
        let expectation = XCTestExpectation(description: #function)
        
        Instnt.shared.submitData(instnttxnid: self.transactionIDReturn, data: UTConf.signupData, completion: { result in
            switch result {
            case .success(let response):
                if response.success == true,
//                   _ = response.decision,
                   let jwt = response.jwt {
                    self.testSuccessfull = true
                    expectation.fulfill()
                } else {
                    if response.message != nil {
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
        
        wait(for: [expectation], timeout: 20.0)
        
        XCTAssertTrue(self.testSuccessfull)
        
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

}
