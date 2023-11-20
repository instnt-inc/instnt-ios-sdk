//
//  SignUpManager.swift
//  InstntSDK_Example
//
//  Created by Vipul Dungranee on 15/03/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
// this SignUpManager is access signup type on first screen and to store it in userDefault

import Foundation

class SignUpManager {
    static let shared = SignUpManager()
    

    var type: SignUPType {
        SignUPType(rawValue: self.signUpType)!
    }
    
    private init() {} //to avoid making
    
    ///with this way we can store and fetch value from user default just as normal variable
    //storing and fetching value from userdefault
    var signUpType: Int {
        get { UserDefaults.standard.integer(forKey: #function) }
        set { UserDefaults.standard.set(newValue, forKey: #function)}
    }
}
