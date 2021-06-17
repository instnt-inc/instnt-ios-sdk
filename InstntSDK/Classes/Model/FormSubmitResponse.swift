//
//  FormSubmitResponse.swift
//  InstntSDK
//
//  Created by Nate Eckerson on 6/3/21.
//

import Foundation

struct FormSubmitResponse {
    private (set) var status: String
    private (set) var url: String
    private (set) var success: Bool
    private (set) var jwt: String
    private (set) var decision: String
    
    init?(JSON: [String: Any]) {
        guard let dataJSON = JSON["data"] as? [String: Any],
              let status = dataJSON["status"] as? String,
              let url = dataJSON["url"] as? String,
              let success = dataJSON["success"] as? Bool,
              let jwt = dataJSON["instntjwt"] as? String,
              let decision = dataJSON["decision"] as? String else {
            return nil
        }
        
        self.status = status
        self.url = url
        self.success = success
        self.jwt = jwt
        self.decision = decision
    }
}
