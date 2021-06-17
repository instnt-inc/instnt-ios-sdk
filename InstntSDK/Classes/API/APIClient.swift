//
//  APIClient.swift
//  InstntSDK
//
//  Created by Nate Eckerson on 5/25/21.
//

import UIKit
import Alamofire
import DeviceKit

class APIClient: NSObject {
    static let shared = APIClient()
    
    private let sandboxBaseEndpoint         = "https://sandbox-api.instnt.org/public"
    private let productionBaseEndpoint      = "https://api.instnt.org/public"
    private var baseEndpoint: String {
        return isSandbox ? sandboxBaseEndpoint : productionBaseEndpoint
    }
    
    var isSandbox: Bool = false
    
    private override init() {
        super.init()
    }
    
    // MARK: - Get FormCodes
    func getFormCodes(with key: String, completion: @escaping ((FormCodes?, [String: Any]?, String?) -> Void)) {
        let endpoint = "\(baseEndpoint)/getformcodes/\(key)?format=json"
        
        AF.request(endpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                guard let responseJSON = data as? [String: Any] else {
                    completion(nil, nil, "Unknown Response")
                    return
                }
                
                let messsage = responseJSON["errorMessage"] as? String
                let formCodes = FormCodes(JSON: responseJSON)
                
                completion(formCodes, responseJSON, messsage)
            case .failure(let error):
                print("getFormCodes Error: \(error.localizedDescription)")
                completion(nil, nil, error.localizedDescription)
            }
        }
    }
    
    // MARK: - Submit
    func submitForm(to endpoint: String, formData: [String: Any], completion: @escaping ((FormSubmitResponse?, [String: Any]?, String?) -> Void)) {
        var paramters: [String: Any] = formData
//        paramters["device_attributes"] = getDeviceAttributes()
        
        AF.request(endpoint, method: .post, parameters: paramters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                guard let responseJSON = data as? [String: Any] else {
                    completion(nil, nil, "Unknown Response")
                    return
                }
                let message = responseJSON["errorMessage"] as? String
                let response = FormSubmitResponse(JSON: responseJSON)
                
                completion(response, responseJSON, message)
            case .failure(let error):
                completion(nil, nil, error.localizedDescription)
            }
        }
    }
}

private extension APIClient {
    func getDeviceAttributes() -> [String: Any] {
        var attributes: [String: Any] = [:]
        
        let device = Device.current
        attributes["model"] = device.description
        attributes["system"] = ("\(device.systemName!) \(device.systemVersion!)")

        return attributes
    }
}
