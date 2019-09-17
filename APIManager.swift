
import Foundation
import UIKit
import SystemConfiguration
import Alamofire

typealias JSONResponse = [String : Any]
typealias APIParameters = [String : Any]

extension Constant{
    
    struct API {
        
        //        static let serverUrl = ""
        
        static let serverUrl = ""
        static let imageUrl = ""
        
        static let loginheaders: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded" //"X-Auth" : "633uq4t0qdmdlfdgkerlope_uilna4334"
        ]
        
        static let headers: HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization" : "bearer \(Session.accessToken)"
            
        ]
        
        enum Name: String {
            
            case login = "/account/Login"
            case forgotPassword = "/account/forgotpassword"
            case preferences = "/GetPreferences"
            case register = "/account/Register"

            
            var url: String{
                return "\(serverUrl)\(rawValue)"
            }
        }
    }
    
}

struct Constant {
    
    static func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    //
    // Convert a base64 representation to a UIImage
    //
    static func convertBase64ToImage(imageString: String) -> UIImage {
        let imageData = Data(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        return UIImage(data: imageData)!
    }
    
}

extension UIViewController {
    
    func removeNSNull(from dict: [String: Any]) -> [String: Any] {
        var mutableDict = dict
        let keysWithEmptString = dict.filter { $0.1 is NSNull }.map { $0.0 }
        for key in keysWithEmptString {
            mutableDict[key] = ""
        }
        return mutableDict
    }
    
}

struct CustomPostEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try URLEncoding().encode(urlRequest, with: parameters)
        let httpBody = NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue)!
        request.httpBody = httpBody.replacingOccurrences(of: "%5B%5D=", with: "=").data(using: .utf8)
        return request
    }
}


class APIManager: NSObject{
    
    //    static let shared = APIManager()
    private override init() { }
    
    class func postRequest(apiName: Constant.API.Name,parameter: APIParameters,headers: HTTPHeaders, success: @escaping(_ response: Data)-> Void) {
        UIApplication.topViewController()?.showActivity()
        if Reachable.isConnectedToNetwork(){
            print(apiName.url)
            
            Alamofire.request(apiName.url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: headers).responseData { (dataResponse) in
                
                UIApplication.topViewController()?.hideActivity()
                
                if let data = dataResponse.data {
                    if let jsonDict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                        print(jsonDict)
                    }
                    success(data)
                } else {
                    UIApplication.topViewController()?.alert(title: Localize.APPNAME, message: Localize.SWR)
                }
            }
        } else {
            UIApplication.topViewController()?.hideActivity()
            UIApplication.topViewController()?.alert(title: Localize.APPNAME, message: Localize.NOINTERNET)
        }
        
    }
    
    class func putRequest(apiName: Constant.API.Name,parameter: APIParameters,headers: HTTPHeaders, success: @escaping(_ response: Data)-> Void) {
        UIApplication.topViewController()?.showActivity()
        if Reachable.isConnectedToNetwork(){
            print(apiName.url)
            
            Alamofire.request(apiName.url, method: .put, parameters: parameter, encoding: URLEncoding.default, headers: headers).responseData { (dataResponse) in
                
                UIApplication.topViewController()?.hideActivity()
                
                if let data = dataResponse.data {
                    if let jsonDict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                        print(jsonDict)
                    }
                    success(data)
                } else {
                    UIApplication.topViewController()?.alert(title: Localize.APPNAME, message: Localize.SWR)
                }
            }
        } else {
            UIApplication.topViewController()?.hideActivity()
            UIApplication.topViewController()?.alert(title: Localize.APPNAME, message: Localize.NOINTERNET)
        }
        
    }
    
    class func deleteRequest(apiName: Constant.API.Name,parameter: APIParameters,header: HTTPHeaders, success: @escaping(_ response: Data)-> Void) {
        
        UIApplication.topViewController()?.showActivity()
        if Reachable.isConnectedToNetwork(){
            print(apiName.url)
            
            Alamofire.request(apiName.url, method: .delete, parameters: parameter, encoding: URLEncoding.default, headers: header).responseData { (dataResponse) in
                
                UIApplication.topViewController()?.hideActivity()
                
                if let data = dataResponse.data {
                    if let jsonDict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                        print(jsonDict)
                    }
                    success(data)
                } else {
                    UIApplication.topViewController()?.alert(title: Localize.APPNAME, message: Localize.SWR)
                }
            }
        } else {
            UIApplication.topViewController()?.hideActivity()
            UIApplication.topViewController()?.alert(title: Localize.APPNAME, message: Localize.NOINTERNET)
        }
        
    }
    
    class func removeNSNull(from dict: [String: Any]) -> [String: Any] {
        var mutableDict = dict
        let keysWithEmptString = dict.filter { $0.1 is NSNull }.map { $0.0 }
        for key in keysWithEmptString {
            mutableDict[key] = ""
        }
        return mutableDict
    }
    
    class func getRequestData(apiName: Constant.API.Name,parameter: APIParameters, success: @escaping(_ response: Data)-> Void  ) {
        UIApplication.topViewController()?.showActivity()
        if Reachable.isConnectedToNetwork(){
            
            let headers: HTTPHeaders = [
                "Content-Type":"application/x-www-form-urlencoded",
                "Authorization" : "bearer \(Session.accessToken)"
                
            ]
            
            Alamofire.request(apiName.url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseData { (dataResponse) in
                print("=========URL======\n" + apiName.url)
                print("=========Parameter======\n \(parameter))")
                
                UIApplication.topViewController()?.hideActivity()
                
                if let data = dataResponse.data {
                    if let jsonDict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                        print(jsonDict)
                    }
                    success(data)
                } else {
                    UIApplication.topViewController()?.alert(title: Localize.APPNAME, message: Localize.SWR)
                }
            }
            
        } else {
            
            UIApplication.topViewController()?.hideActivity()
            UIApplication.topViewController()?.alert(title: Localize.APPNAME, message: Localize.NOINTERNET)
            
        }
        
    }
    
    class func getRequestDataWithParameter(apiName: Constant.API.Name,parameter: APIParameters, success: @escaping(_ response: Data)-> Void  ) {
        UIApplication.topViewController()?.showActivity()
        if Reachable.isConnectedToNetwork(){
            
            print(Constant.API.headers)
            let headers: HTTPHeaders = [
                "Content-Type":"application/x-www-form-urlencoded",
                "Authorization" : "bearer \(Session.accessToken)"
            ]
            print(headers)
            Alamofire.request(apiName.url, method: .get, parameters: parameter, headers: headers).responseData { (dataResponse) in
                print("=========URL======\n" + apiName.url)
                print("=========Parameter======\n \(parameter))")
                
                UIApplication.topViewController()?.hideActivity()
                
                if let data = dataResponse.data {
                    if let jsonDict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                        print(jsonDict)
                    }
                    success(data)
                } else {
                    UIApplication.topViewController()?.alert(title: Localize.APPNAME, message: Localize.SWR)
                }
            }
            
        } else {
            
            UIApplication.topViewController()?.hideActivity()
            UIApplication.topViewController()?.alert(title: Localize.APPNAME, message: Localize.NOINTERNET)
            
        }
        
    }
    
    class func postRequestMultipart(apiName: Constant.API.Name,header:HTTPHeaders,parameter: APIParameters,imageData: Data, success: @escaping(_ response: Data)-> Void) {
        
        print(parameter)
        UIApplication.topViewController()?.showActivity()
        if Reachable.isConnectedToNetwork(){
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameter {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key )
                }
                multipartFormData.append(imageData, withName: "ProfilImage", fileName: "profileimage\(Date().ticks).png", mimeType: "image/png")
                
            }, usingThreshold: UInt64(), to: apiName.url, method: .post, headers: header) { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    //                upload.responseJSON { response in
                    //                    print(response.result.value!)
                    //                    if let dataObject = response.result.value as? [String:Any]{
                    //                        print(dataObject)
                    //                    }
                    //                }
                    
                    upload.responseData { (dataResponse) in
                        if let data = dataResponse.data {
                            if let jsonDict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                                print(jsonDict)
                            }
                            success(data)
                        } else {
                            UIApplication.topViewController()?.alert(title: Localize.APPNAME, message: Localize.SWR)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        } else {
            UIApplication.topViewController()?.hideActivity()
            UIApplication.topViewController()?.alert(title: Localize.APPNAME, message: Localize.NOINTERNET)
            
        }
    }
    
    class func postRequestUploadImages(apiName: Constant.API.Name,imagesArray: [UIImage],count: UInt64,parameter: APIParameters, success: @escaping(_ response: Data)-> Void) {
        let headers: HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization" : "bearer \(Session.accessToken)"
        ]
        print(parameter)
        UIApplication.topViewController()?.showActivity()
        if Reachable.isConnectedToNetwork(){
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameter {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key )
                }
                for i in 0..<imagesArray.count{
                    multipartFormData.append(imagesArray[i].jpegData(compressionQuality: 0.4)!, withName: "Image\(i+1)", fileName: "image\(count).png", mimeType: "image/png")
                }
                
                
            }, usingThreshold: UInt64(), to: apiName.url, method: .post, headers: headers) { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    //                upload.responseJSON { response in
                    //                    print(response.result.value!)
                    //                    if let dataObject = response.result.value as? [String:Any]{
                    //                        print(dataObject)
                    //                    }
                    //                }
                    
                    upload.responseData { (dataResponse) in
                        if let data = dataResponse.data {
                            if let jsonDict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                                print(jsonDict)
                            }
                            success(data)
                        } else {
                            UIApplication.topViewController()?.alert(title: Localize.APPNAME, message: Localize.SWR)
                        }
                        
                    }
                    
                    
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        } else {
            UIApplication.topViewController()?.hideActivity()
            UIApplication.topViewController()?.alert(title: Localize.APPNAME, message: Localize.NOINTERNET)
            
        }
    }
    
    class func postReqestWithRawData(apiName: Constant.API.Name,parameter: APIParameters, success: @escaping(_ response: Data)-> Void  ) {
        UIApplication.topViewController()?.showActivity()
        if Reachable.isConnectedToNetwork(){
            Alamofire.request(apiName.url, method: .post, parameters: parameter, encoding: PropertyListEncoding.default, headers: Constant.API.headers).responseData { (dataResponse) in
                print("=========URL======\n" + apiName.url)
                print("=========Parameter======\n \(parameter))")
                
                UIApplication.topViewController()?.hideActivity()
                
                if let data = dataResponse.data {
                    if let jsonDict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                        print(jsonDict)
                    }
                    success(data)
                } else {
                    UIApplication.topViewController()?.alert(title: Localize.APPNAME, message: Localize.SWR)
                }
            }
            
        } else {
            
            UIApplication.topViewController()?.hideActivity()
            UIApplication.topViewController()?.alert(title: Localize.APPNAME, message: Localize.NOINTERNET)
            
        }
        
    }
    
    
    class func sendNotification(title: String, message: String,senderID: String,senderToken: String) {
        
        let headers = ["Authorization" :
            "key=\(FIREBASESERVERKEY)",
            "Content-Type":"application/json"]
        
        let parameters: [String : Any] = [
            "to" : senderToken,
            "priority" : "high",
            "notification" : [
                "body" : message,
                "title" : title,
                "sound" : "default",
                "type" : "chat",
                "senderId" : senderID,
                
            ],
            "data" : [
                "type" : "chat",
                "senderId" : senderID
            ]
        ]
        if Reachable.isConnectedToNetwork(){
            
            Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { (dataResponse) in
                
                if let data = dataResponse.data {
                    if let jsonDict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                        print(jsonDict)
                    }
                } else {
                    UIApplication.topViewController()?.alert(title: Localize.APPNAME, message: Localize.SWR)
                }
            }
            
        } else {
            UIApplication.topViewController()?.alert(title: Localize.APPNAME, message: Localize.NOINTERNET)
        }
    }
    
    
}

struct JSONStringArrayEncoding: ParameterEncoding {
    private let jsonArray: [[String: String]]
    
    init(jsonArray: [[String: String]]) {
        self.jsonArray = jsonArray
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest.httpBody = data
        
        return urlRequest
    }
}
