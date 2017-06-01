//
//  API.swift
//  Clone
//
//  Created by FARHAN IT SOLUTION on 31/05/17.
//
//

import Foundation
import SwiftHTTP

enum APIResponseStatus: Int {
    case failure = 0
    case success = 1
}

typealias HTTPHeaders = [String : String]
typealias JSONResponse = [String : Any]
typealias APIParameters = [String : Any]

typealias APIResponse = (_ status: APIResponseStatus, _ message: String, _ data: [String : Any] ) -> Void
typealias APIFailure = (_ error: Error) -> ()

extension Constant{
    
    static let deviceType = 1
    
    struct API {
        
        static let serverUrl = "http://addonwebsolutions.net/campus_mate/restapi/"
        static let headers: HTTPHeaders = [
            "X-Auth" : "633uq4t0qdmdlfdgkerlope_uilna4334"
        ]
        
        enum Name: String {
            case universityList = "Universitylist"
            case login = "Logincustomer"
            
            var url: String{
                return "\(serverUrl)\(rawValue)"
            }
            
        }
        
    }
    
}

class API{
    
    private let httpOperation: HTTP
    private var onResponse: APIResponse?
    private var onFailure: APIFailure?
    
    private init(httpOperation: HTTP) {
        self.httpOperation = httpOperation
        
        httpOperation.onFinish = { (response) in
            self.handleResponse(response)
        }
        
    }
    
    private func handleResponse(_ response: Response){
        
        if response.error == nil{
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: response.data, options: .mutableLeaves)
                
                if let json = json as? [String:Any] {
                    print("JSON output :: \(json)")
                    
                    var status: APIResponseStatus = .failure
                    var message: String = ""
                    var data: JSONResponse = [:]
                    
                    if let responseStatus = json["status"] as? String {
                        status = APIResponseStatus(rawValue: Int(responseStatus)!)!
                    }
                    
                    if let responseMessage = json["message"] as? String {
                        message = responseMessage
                    }
                    
                    if let responseData = json["data"] as? JSONResponse{
                        data = responseData
                    }
                    
                    if let onResponse = onResponse{
                        onResponse(status, message, data)
                    }
                    
                }
                
            } catch let error {
                handleFailure(error: error)
            }
            
        }else{
            handleFailure(error: response.error)
        }
        
    }
    
    private func handleFailure(error: Error?){
        
        if let onFailure = onFailure, let error = error{
            onFailure(error)
        }
        
    }
    
    public func onResponseJson(_ handler: APIResponse?){
        onResponse = handler
    }
    
    public func onFailure(_ handler: APIFailure?){
        onFailure = handler
    }
    
    public func cancel(){
        httpOperation.cancel()
    }
    
    private static func generateParameters(_ param: APIParameters? ) -> APIParameters? {
        
        guard param != nil else {
            return nil
        }
        
        var parameters: APIParameters = [:]
        
        for (key,value) in param! {
            
            if let image = value as? UIImage {
                
                if let data =  UIImagePNGRepresentation(image){
                    parameters[key] = Upload(data: data, fileName: key, mimeType: "image/png")
                }
                
            }else if let images = value as? [UIImage] {
                
                var uploads: [Upload] = []
                
                for i in 0..<images.count {
                    if let data =  UIImagePNGRepresentation(images[i]){
                        uploads.append(Upload(data: data, fileName: String(format:"%@-%zd.png",key,i), mimeType: "image/png"))
                    }
                }
                
                parameters[key] = uploads
            }else{
                parameters[key] = value
            }
            
        }
        
        return parameters
    }
    
    @discardableResult
    static func get(_ apiName: Constant.API.Name, parameters: APIParameters? = nil, additionalHeaders: HTTPHeaders? = nil, onSuccess: APIResponse? = nil, onFailure: APIFailure? = nil) -> API?{
        
        do {
            
            var headers = Constant.API.headers
            
            if let additionalHeaders = additionalHeaders {
                for (key,value) in additionalHeaders {
                    headers[key] = value
                }
            }
            
            let opt = try HTTP.GET(apiName.url, parameters: parameters, headers: headers, requestSerializer: HTTPParameterSerializer())
            
            let apiRequest = API(httpOperation: opt)
            apiRequest.onResponseJson(onSuccess)
            apiRequest.onFailure(onFailure)
            
            opt.start()
            
            return apiRequest
            
        } catch let error {
            print("got an error creating the request: \(error)")
            return nil
        }
        
    }
    
    @discardableResult
    static func post(_ apiName: Constant.API.Name, parameters: APIParameters? = nil, additionalHeaders: HTTPHeaders? = nil, onSuccess: APIResponse? = nil, onFailure: APIFailure? = nil) -> API?{
        
        do {
            
            var headers = Constant.API.headers
            
            if let additionalHeaders = additionalHeaders {
                for (key,value) in additionalHeaders {
                    headers[key] = value
                }
            }
            
            let opt = try HTTP.POST(apiName.url, parameters: generateParameters(parameters), headers: headers, requestSerializer: HTTPParameterSerializer())
            
            let apiRequest = API(httpOperation: opt)
            apiRequest.onResponseJson(onSuccess)
            apiRequest.onFailure(onFailure)
            
            opt.start()
            
            return apiRequest
            
        } catch let error {
            print("got an error creating the request: \(error)")
            return nil
        }
        
    }
    
}
