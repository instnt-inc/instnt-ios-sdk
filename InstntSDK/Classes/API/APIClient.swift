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
    var baseEndpoint: String = ""
    var isSandbox: Bool = false
    var formKey = ""
    
    private override init() {
        super.init()
    }
    
    // MARK: - Submit
    func submitForm(to endpoint: String, formData: [String: Any], completion: @escaping(Result<FormSubmitResponse, InstntError>) -> Void) {
        
        let paramters: [String: Any] = formData
       
        AF.request(endpoint, method: .post, parameters: paramters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                guard let responseJSON = data as? [String: Any] else {
                    completion(.failure(InstntError(errorConstant:.error_FORM_SUBMIT)))
                    return
                }
                if let responseData = FormSubmitResponse(JSON: responseJSON) {
                    completion(.success(responseData))
                } else {
                    completion(.failure(InstntError(errorConstant: .error_PARSER)))
                }
            case .failure(let error):
                completion(.failure(InstntError(errorConstant: .error_FORM_SUBMIT, message: error.localizedDescription, statusCode: error.responseCode ?? 0)))
            }
        }
    }
    
    func createTransaction(data: CreateTransaction, completion: @escaping(Result<ResultCreateTransaction, InstntError>) -> Void) {
        let endpoint = "\(baseEndpoint)/transactions/"
        var parameters: [String: Any] = [:]
        do {
            try parameters = data.asDictionary()
        } catch let errror { print("Error converting dic %@", errror.localizedDescription)}
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { response in
            debugPrint(response)
            switch response.result {
            case .success(_):
                guard let data = response.data else { return }
                do {
                    let de = JSONDecoder()
                    let res = try de.decode(ResultCreateTransaction.self, from: data)
                    completion(.success(res))
                    print(res)
                }
                catch {
                    completion(.failure(InstntError(errorConstant: .error_EXTERNAL)))
                    print(error)
                }
            case .failure(let error):
                completion(.failure(InstntError.init(errorConstant: .error_EXTERNAL, message: error.localizedDescription, statusCode: error.responseCode ?? 0)))
            }
        }
    }
    
    func getUploadUrl(transactionId: String, data: RequestGetUploadUrl, completion: @escaping(Result<String, InstntError>) -> Void) {
        let endpoint = "\(baseEndpoint)/transactions/\(transactionId)/attachments/"
        var parameters: [String: Any] = [:]
        do {
            try parameters = data.asDictionary()
        } catch let errror { print("Error converting dic %@", errror.localizedDescription)}
        debugPrint(endpoint)
        debugPrint(parameters)
        AF.request(endpoint, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                guard let responseJSON = data as? [String: Any] else {
                    completion(.failure(InstntError(errorConstant: .error_INVALID_DATA)))
                   return
                }
                if let s3Key = responseJSON["s3_key"] as? String {
                    completion(.success(s3Key))
                } else {
                    completion(.failure(InstntError(errorConstant: .error_PARSER)))
                }
            case .failure(let error):
                completion(.failure(InstntError(errorConstant: .error_EXTERNAL, message: error.localizedDescription, statusCode: error.responseCode ?? 00)))
                print("getUploadUrl Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    func upload(url: String, data: Data, completion: @escaping(Result<Void, InstntError>) -> Void) {
        guard let uploadUrl = URL(string: url) else {
            return
        }
        var postRequest = URLRequest.init(url: uploadUrl)
        postRequest.httpMethod = "PUT"
        postRequest.headers = ["Content-Type": "image/jpeg"];
        postRequest.httpBody = data
        let uploadSession = URLSession.shared
        let executePostRequest = uploadSession.dataTask(with: postRequest as URLRequest) { (data, response, error) -> Void in
            debugPrint(response ?? "")
            if error != nil {
                completion(.failure(InstntError(errorConstant: .error_EXTERNAL, message: error?.localizedDescription, statusCode: error?.asAFError?.responseCode ?? 00)))
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
        var parameters: [String: Any] = [:]
        do {
            try parameters = requestData.asDictionary()
        } catch let errror { print("Error converting dic %@", errror.localizedDescription)}
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { response in
            debugPrint(response)
            switch response.result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(InstntError.init(errorConstant: .error_EXTERNAL, message: error.localizedDescription, statusCode: error.responseCode ?? 0)))
            }
        }
    }
    
    func sendOTP(requestData: RequestSendOTP, transactionId: String, completion: @escaping(Result<Void, InstntError>) -> Void) {
        let endpoint = "\(baseEndpoint)/transactions/\(transactionId)/otp"
        var parameters: [String: Any] = [:]
        do {
            try parameters = requestData.asDictionary()
        } catch let errror { print("Error converting dic %@", errror.localizedDescription)}
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                if let error = response.error  {
                    completion(.failure(InstntError(errorConstant: .error_EXTERNAL, message: error.localizedDescription, statusCode: response.response?.statusCode ?? 0)))
                    return
                }
                do {
                    let de = JSONDecoder()
                    let res = try de.decode(ResultSendOTP.self, from: data)
                    if res.response.valid == true {
                        completion(.success(()))
                    } else if res.response.errors.count > 0 {
                        completion(.failure(InstntError.init(errorConstant: .error_INVALID_PHONE, message: res.response.errors.first)))
                    } else {
                        completion(.failure(InstntError.init(errorConstant: .error_INVALID_PHONE)))
                    }
                }
                catch {
                    completion(.failure(InstntError.init(errorConstant: .error_PARSER)))
                }
            case .failure(let error):
                completion(.failure(InstntError.init(errorConstant: .error_EXTERNAL, message: error.localizedDescription, statusCode: error.responseCode ?? 0)))
            }
        }
    }
    
    func verifyOTP(requestData: RequestVerifyOTP, transactionId: String, completion: @escaping(Result<Void, InstntError>) -> Void) {
        let endpoint = "\(baseEndpoint)/transactions/\(transactionId)/otp"
        var parameters: [String: Any] = [:]
        do {
            try parameters = requestData.asDictionary()
        } catch let errror { print("Error converting dic %@", errror.localizedDescription)}
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { response in
            debugPrint(response)
            
            guard let data = response.data else {
                completion(.failure(InstntError.init(errorConstant: .error_INVALID_DATA)))
                return
            }
            if let error = response.error  {
                completion(.failure(InstntError(errorConstant: .error_EXTERNAL, message: error.localizedDescription, statusCode: response.response?.statusCode ?? 0)))
                return
            }
            do {
                let de = JSONDecoder()
                let res = try de.decode(ResultVerifyOTP.self, from: data)
                if res.response.valid == true {
                    completion(.success(()))
                } else if res.response.errors.count > 0 {
                    completion(.failure(InstntError.init(errorConstant: .error_INVALID_OTP, message: res.response.errors.first)))
                } else {
                    completion(.failure(InstntError.init(errorConstant: .error_INVALID_OTP)))
                }
            }
            catch {
                completion(.failure(InstntError.init(errorConstant: .error_PARSER)))
            }
        }
    }
    
}
