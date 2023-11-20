//
//  UTConfig.swift
//  InstUnitTestTests
//
//  Created by mac on 30/03/23.
//

import Foundation

class UTConfig {
    
    let endPoint = "https://dev2-api.instnt.org/public"
    let SDKSetupFormKey = "v1679308618983151"
    let SDKSetupFormKeyNegative = "v167930861877463778"
    
    let validPhone = "+12064512559"
    let inValidPhone = "1111111111"
    let verifyOtp = "111111"
    let verifyOtpPhone = "+12012121212"
    
    let verifyTransactionData: [String: String] = ["phone":"+12067564535", "amount":"10", "firstName":"John", "surName":"Doe", "notes":"Test Notes", "user_action":"MONEY_TRANSFER"]

    let resumeSignUpFormKey = "v1639687041590101"
    let resumeSignupTransactionID = "2b58f07e-d34c-49c8-ae39-ec98c06ab5ce"
    
    let resumeSignUpFormKeyNegative = "v167930861898315167"
    let resumeSignupTransactionIDNegative = "2b58f07e-d34c-49c8-ae39-ec98c06ab5ceeerrr"
    
    let signupData: [String: Any] = ["physicalAddress":"NY St", "city":"NYC", "state":"NY", "zip":"10011", "country":"US", "email":"abc@test.com", "mobileNumber":"+12098383845", "firstName":"John", "surName":"Doe" ]
}
