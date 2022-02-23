//
//  APIClient.swift
//  InstntSDK
//
//  Created by Nate Eckerson on 5/25/21.
//

import UIKit
import DeviceKit

class APIClient: NSObject {
    static let shared = APIClient()
    var baseEndpoint: String = ""
    var isSandbox: Bool = false
    var formKey = ""
    
    private override init() {
        super.init()
    }
    
    // MARK: - Submit
    func submitForm(to endpoint: String, formData: [String: Any], completion: @escaping(Result<FormSubmitResponse, InstntError>) -> Void) {
        let request = ConnectionRequest(urlString: endpoint, method: .PUT)
        if let jsonData = try? JSONSerialization.data(withJSONObject:formData) {
            request.postData = jsonData
            ConnectionManager().sendRequest(request, success: { response in
                let responseData = response.data
                guard let responseJSON = BaseEntity.parseJSON(responseData) as? [String : Any] else {
                    completion(.failure(InstntError(errorConstant:.error_FORM_SUBMIT)))
                    return
                }
                if let responseData = FormSubmitResponse(JSON: responseJSON) {
                    completion(.success(responseData))
                } else {
                    completion(.failure(InstntError(errorConstant: .error_PARSER)))
                }
                
            }, failure: { error in
                guard let responseData = error.connectionResponse?.data,
                        let responseJSON = BaseEntity.parseJSON(responseData) as? [String : Any] else {
                    completion(.failure(InstntError(errorConstant:.error_FORM_SUBMIT)))
                    return
                }
                if let message = responseJSON["message"] as? String {
                    completion(.failure(InstntError(errorConstant: .error_FORM_SUBMIT, message: message)))
                } else if let message = responseJSON["errorMessage"] as? String {
                    completion(.failure(InstntError(errorConstant: .error_FORM_SUBMIT, message: message)))
                } else {
                    completion(.failure(InstntError(errorConstant: .error_FORM_SUBMIT)))
                }                
            })
        } else {
            completion(.failure(InstntError(errorConstant: .error_FORM_SUBMIT)))
        }
    }
    
    func createTransaction(data: CreateTransaction, completion: @escaping(Result<ResultCreateTransaction, InstntError>) -> Void) {
        let endpoint = "\(baseEndpoint)/transactions/"
        let request = ConnectionRequest(urlString: endpoint, method: .POST)
        guard let data = BaseEntity.getJSONData(object: data) else {
            completion(.failure(InstntError(errorConstant: .error_SETUP)))
            return
        }
        request.postData = data
        ConnectionManager().sendRequest(request, success: { response in
            if let createTransaction: ResultCreateTransaction = BaseEntity.parse(data: response.data) {
                completion(.success(createTransaction))
            } else {
                completion(.failure(InstntError(errorConstant: .error_SETUP)))
            }
            
        }, failure: { error in
            completion(.failure(InstntError(errorConstant: .error_SETUP)))
        })
    }
    
    func getUploadUrl(transactionId: String, data: RequestGetUploadUrl, completion: @escaping(Result<String, InstntError>) -> Void) {
        let endpoint = "\(baseEndpoint)/transactions/\(transactionId)/attachments/"
        
        guard let data = BaseEntity.getJSONData(object: data) else {
            completion(.failure(InstntError(errorConstant: .error_UPLOAD)))
            return
        }
        let request = ConnectionRequest(urlString: endpoint, method: .POST)
        request.postData = data
        ConnectionManager().sendRequest(request, success: { response in
            let responseData = response.data
            guard let responseJSON = BaseEntity.parseJSON(responseData) as? [String : Any] else {
                completion(.failure(InstntError(errorConstant:.error_UPLOAD)))
                return
            }
            if let s3Key = responseJSON["s3_key"] as? String {
                completion(.success(s3Key))
            } else {
                completion(.failure(InstntError(errorConstant: .error_UPLOAD)))
            }
        }, failure: { error in
            completion(.failure(InstntError(errorConstant: .error_UPLOAD)))
        })
    }
    
    
    func upload(url: String, data: Data, completion: @escaping(Result<Void, InstntError>) -> Void) {
        guard let uploadUrl = URL(string: url) else {
            return
        }
        var postRequest = URLRequest.init(url: uploadUrl)
        postRequest.httpMethod = "PUT"
        postRequest.allHTTPHeaderFields = ["Content-Type": "image/jpeg"];
        postRequest.httpBody = data
        let uploadSession = URLSession.shared
        let executePostRequest = uploadSession.dataTask(with: postRequest as URLRequest) { (data, response, error) -> Void in
            debugPrint(response ?? "")
            if error != nil {
                completion(.failure(InstntError(errorConstant: .error_EXTERNAL, message: error?.localizedDescription)))
            }
            if let urlresponse = response as? HTTPURLResponse
            {
                print(urlresponse)
                if let data = data
                {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Response data: \(String(describing: json))")
                }
                if urlresponse.statusCode == 200 {
                    completion(.success((())))
                } else {
                    completion(.failure(InstntError(errorConstant: .error_EXTERNAL)))
                }
            }
        }
        executePostRequest.resume()
    }
    
    func verifyDocuments(requestData: VerifyDocument, transactionId: String, completion: @escaping(Result<Void, InstntError>) -> Void) {
        let endpoint = "\(baseEndpoint)/transactions/\(transactionId)/attachments/verify/"
        guard let data = BaseEntity.getJSONData(object: requestData) else {
            completion(.failure(InstntError(errorConstant: .error_UPLOAD)))
            return
        }
        let request = ConnectionRequest(urlString: endpoint, method: .POST)
        request.postData = data
        ConnectionManager().sendRequest(request, success: { _ in
            completion(.success(()))
        }, failure: { error in
            completion(.failure(InstntError(errorConstant: .error_UPLOAD)))
        })
    }
    
    func sendOTP(requestData: RequestSendOTP, transactionId: String, completion: @escaping(Result<Void, InstntError>) -> Void) {
        let endpoint = "\(baseEndpoint)/transactions/\(transactionId)/otp"
        guard let data = BaseEntity.getJSONData(object: requestData) else {
            completion(.failure(InstntError(errorConstant: .error_UPLOAD)))
            return
        }
        let request = ConnectionRequest(urlString: endpoint, method: .POST)
        request.postData = data
        ConnectionManager().sendRequest(request, success: { response in
            if let resultSendOTP: ResultSendOTP = BaseEntity.parse(data: response.data) {
                if resultSendOTP.response.valid == true {
                    completion(.success(()))
                } else if resultSendOTP.response.errors.count > 0 {
                    completion(.failure(InstntError.init(errorConstant: .error_INVALID_PHONE, message: resultSendOTP.response.errors.first)))
                } else {
                    completion(.failure(InstntError.init(errorConstant: .error_INVALID_PHONE)))
                }
            } else {
                completion(.failure(InstntError(errorConstant: .error_EXTERNAL)))
            }
            
        }, failure: { error in
            if let data = error.connectionResponse?.data,
                let resultSendOTP: ResultSendOTP = BaseEntity.parse(data: data)  {
                if resultSendOTP.response.valid == true {
                    completion(.success(()))
                } else if resultSendOTP.response.errors.count > 0 {
                    completion(.failure(InstntError.init(errorConstant: .error_INVALID_PHONE, message: resultSendOTP.response.errors.first)))
                } else {
                    completion(.failure(InstntError.init(errorConstant: .error_INVALID_PHONE)))
                }
            } else {
                completion(.failure(InstntError(errorConstant: .error_INVALID_PHONE)))
            }
           
        })
    }
    
    
    func verifyOTP(requestData: RequestVerifyOTP, transactionId: String, completion: @escaping(Result<Void, InstntError>) -> Void) {
        let endpoint = "\(baseEndpoint)/transactions/\(transactionId)/otp"
        guard let data = BaseEntity.getJSONData(object: requestData) else {
            completion(.failure(InstntError(errorConstant: .error_UPLOAD)))
            return
        }
        let request = ConnectionRequest(urlString: endpoint, method: .POST)
        request.postData = data
            
        ConnectionManager().sendRequest(request, success: { response in
            if let resultVerifyOTP: ResultVerifyOTP = BaseEntity.parse(data: response.data) {
                if resultVerifyOTP.response.valid == true {
                    completion(.success(()))
                } else if resultVerifyOTP.response.errors.count > 0 {
                    completion(.failure(InstntError.init(errorConstant: .error_INVALID_OTP, message: resultVerifyOTP.response.errors.first)))
                } else {
                    completion(.failure(InstntError.init(errorConstant: .error_INVALID_OTP)))
                }
            } else {
                completion(.failure(InstntError(errorConstant: .error_EXTERNAL)))
            }
            
        }, failure: { error in
            if let data = error.connectionResponse?.data,
               let resultVerifyOTP: ResultVerifyOTP = BaseEntity.parse(data: data) {
                if resultVerifyOTP.response.valid == true {
                    completion(.success(()))
                } else if resultVerifyOTP.response.errors.count > 0 {
                    completion(.failure(InstntError.init(errorConstant: .error_INVALID_OTP, message: resultVerifyOTP.response.errors.first)))
                } else {
                    completion(.failure(InstntError.init(errorConstant: .error_INVALID_OTP)))
                }
            } else {
                completion(.failure(InstntError(errorConstant: .error_EXTERNAL)))
            }
        })
    }
    
}
