//
//  APIClient.swift
//  SwiftyInstntDemo
//
//  Created by Admin on 5/25/21.
//

import UIKit
import Alamofire

class APIClient: NSObject {
    static let shared = APIClient()
    
    private let sandboxBaseEndpoint         = "https://stage-api.instnt.org/public"
    private let productionBaseEndpoint      = "https://api.instnt.org/public"
    private var baseEndpoint: String {
        return isSandbox ? sandboxBaseEndpoint : productionBaseEndpoint
    }
    
    var isSandbox: Bool = false
    
    private override init() {
        super.init()
    }
    
    // MARK: - Get FormCodes
    func getFormCodes(with key: String, completion: @escaping ((FormCodes?, String?) -> Void)) {
        let endpoint = "\(baseEndpoint)/getformcodes/\(key)?format=json"
        
        AF.request(endpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                guard let responseJSON = data as? [String: Any] else {
                    completion(nil, nil)
                    return
                }
                
                let messsage = responseJSON["errorMessage"] as? String
                let formCodes = FormCodes(JSON: responseJSON)
                
                completion(formCodes, messsage)
            case .failure(let error):
                print("getFormCodes Error: \(error.localizedDescription)")
                completion(nil, nil)
            }
        }
    }
    
    // MARK: - Submit
    func submitForm(to endpoint: String, formData: [String: Any], completion: @escaping ((FormSubmitResponse?, String?) -> Void)) {
        AF.request(endpoint, method: .post, parameters: formData, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                guard let responseJSON = data as? [String: Any] else {
                    completion(nil, "Unknown Response")
                    return
                }
                let message = responseJSON["errorMessage"] as? String
                let response = FormSubmitResponse(JSON: responseJSON)
                
                completion(response, message)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
