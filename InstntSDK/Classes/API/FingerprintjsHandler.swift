//
//  FingerprintjsHandler.swift
//  InstntSDK
//
//  Created by Vipul Dungranee on 20/04/22.
//

import Foundation
import FingerprintPro

public class FingerprintjsHandler {
    
    static let shared = FingerprintjsHandler()
    private var broswer_token = "uC2jNKwTbd1PbA22aLDr"
    private var visitorId: String?
    private var requestId: String?
    
    private init() {
        print("FingerprintjsHandler's private init called")
    }
    
    
    /// its better to call this method little bit before as this can take time to give visitor id
    /// in our case we can call this method inside getTransactionID
    func configure(fingerPrintToken token: String, completion: @escaping (Result<(String?, String?), Error>) -> Void) {
        if !token.isEmpty { self.broswer_token = token }

        do {
            let configuration = Configuration(apiKey: broswer_token, extendedResponseFormat: true)

            let client = FingerprintProFactory.getInstance(configuration)

            client.getVisitorIdResponse { result in
                switch result {
                case .success(let extendedResult):
                    self.visitorId = extendedResult.visitorId
                    self.requestId = extendedResult.requestId
                    completion(.success((self.visitorId, self.requestId)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
}
