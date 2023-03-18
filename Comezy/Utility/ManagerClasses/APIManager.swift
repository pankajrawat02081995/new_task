//

import Foundation
import Alamofire
import MBProgressHUD

class APIManager {
    
    static let shared = APIManager()
    private var progressHUD: MBProgressHUD?
    
    private init() {}
    
    //MARK:- MBProgredHUD -
    func showProgressHUD(message:String? = nil) {
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
//
//
//        })

        self.hideProgressHUD()
        self.progressHUD = nil
        if let safeCurrentController = currentController?.view {
            print("CurrentViewController", safeCurrentController.className)
            self.progressHUD = MBProgressHUD.showAdded(to: safeCurrentController, animated: true)
            
        }
    
        if let message = message {
            self.progressHUD?.label.text = message
            self.progressHUD?.label.numberOfLines = 0
        }
        
        if let progressHUD = self.progressHUD {
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = progressHUD.backgroundView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            progressHUD.backgroundView.addSubview(blurEffectView)
        }


    }
    
    func hideProgressHUD() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(210), execute: {
//
//        })
        if let progressHUD = self.progressHUD {
            progressHUD.hide(animated: true)
        }
     
    }
    
    //MARK: Request String
    func requestString(url:String,method:HTTPMethod,parameters:Parameters?=nil,completionCallback:@escaping (AnyObject) -> Void ,success successCallback: @escaping (AnyObject?) -> Void ,failure failureCallback: @escaping (String?) -> Void) {
        
        self.showProgressHUD()
        var headers:HTTPHeaders?
            headers = HTTPHeaders()
        headers!["Authorization"] = "JWT \(kUserData?.jwt_token ?? "")"
//        headers!["Authorization"] = "jwt eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo3LCJ1c2VybmFtZSI6IjE0Mjc4MDliLWUyNGItNDczMy04YTgyLTlhOTY2YmE1ZGYwYSIsImV4cCI6MjUxNjk2ODg4MSwiZW1haWwiOiJ0ZXN0ZGV2ZWxvcGVyQHlvcG1haWwuY29tIn0.dAeRU4OwkQh18fc0K5kEmF42L13fp4r2Ov7C0SWchRI"
        print(headers?[0])
        let head = headers
        URLCache.shared.removeAllCachedResponses()
        
        let urlStr = url.urlQueryEncoding
        let combinedURL = "\(API.productionURL)\(urlStr ?? "")"
        print("URL -> \(combinedURL)")
        print("Parameters -> \(parameters ?? [:])")
        
        var encoding:ParameterEncoding!
        if method == .get {
            encoding = JSONEncoding.default
        } else {
            encoding = JSONEncoding.default
        }
                
        AF.request(combinedURL, method: method, parameters: parameters, encoding: encoding!, headers: headers).responseString { [self] (response) in
            print(response.value as Any)
            completionCallback(response as AnyObject)
            self.hideProgressHUD()
           // if self.isResponseValid(response: response) {
                switch response.result {
                case .success(let responseJSON):
                    print(responseJSON)
//                    if let responseJSON = responseJSON as? [String:Any], let result = responseJSON["Result"] as? [String:Any] {
//                        successCallback(result as AnyObject)
//                    } else {
//                        successCallback(responseJSON as AnyObject)
//                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    failureCallback(error.localizedDescription)
                }
//            } else {
//                let error =  self.getErrorForResponse(response: response)
//                failureCallback(error)
//            }
        }
    }
    
    //MARK: Request
    func request(url:String,method:HTTPMethod,parameters: Parameters?=nil, encoding: ParameterEncoding = JSONEncoding.default ,completionCallback:@escaping (AnyObject) -> Void ,success successCallback: @escaping (AnyObject?) -> Void ,failure failureCallback: @escaping (String?) -> Void) {
        
        DispatchQueue.main.async {
            self.showProgressHUD()
        }
        var headers:HTTPHeaders?
            headers = HTTPHeaders()
        headers!["Authorization"] = "JWT \(kUserData?.jwt_token ?? "")"
        print(headers)
        URLCache.shared.removeAllCachedResponses()
        
        let urlStr = url.urlQueryEncoding
        let combinedURL = "\(API.productionURL)\(urlStr ?? "")"
        print("URL -> \(combinedURL)")
        print("Parameters -> \(parameters ?? [:])")
        
//        var encoding:ParameterEncoding!
//        if method == .get {
//            encoding = JSONEncoding.default //URLEncoding.Destination.methodDependent as? ParameterEncoding
//        } else {
//            encoding = JSONEncoding.default
//        }
        
        AF.request(combinedURL, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { [self] (response) in
            print(response.value as Any, "!@#$@#@#  Printing response  $!@#$")
            completionCallback(response as AnyObject)
            
            DispatchQueue.main.async {
                self.hideProgressHUD()
            }
            if self.isResponseValid(response: response) {
                switch response.result {
                case .success(let responseJSON):
                    
                    if let responseJSON = responseJSON as? [String:Any], let result = responseJSON["Result"] as? [String:Any] {
                        successCallback(result as AnyObject)
                    } else {
                        print(responseJSON as AnyObject)
                        successCallback(responseJSON as AnyObject)
                        print(responseJSON as Any)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    failureCallback(error.localizedDescription)
                }
            } else {
                let error =  self.getErrorForResponse(response: response)
                failureCallback(error)
            }
        }
    }
    

    //MARK: Request Without HUD
    func requestWithoutHUD(url:String,method:HTTPMethod,parameters: Parameters?=nil ,completionCallback:@escaping (AnyObject) -> Void ,success successCallback: @escaping (AnyObject?) -> Void ,failure failureCallback: @escaping (String?) -> Void) {
        var headers:HTTPHeaders?
            headers = HTTPHeaders()
        headers!["Authorization"] = "JWT \(kUserData?.jwt_token ?? "")"
        print(headers)
        URLCache.shared.removeAllCachedResponses()
        
        let urlStr = url.urlQueryEncoding
        let combinedURL = "\(API.productionURL)\(urlStr ?? "")"
        print("URL -> \(combinedURL)")
        print("Parameters -> \(parameters ?? [:])")
        
        var encoding:ParameterEncoding!
        if method == .get {
            encoding = JSONEncoding.default //URLEncoding.Destination.methodDependent as? ParameterEncoding
        } else {
            encoding = JSONEncoding.default
        }
        
        AF.request(combinedURL, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { [self] (response) in
            print(response.value as Any, "!@#$@#@#  Printing response  $!@#$")
            completionCallback(response as AnyObject)
            if self.isResponseValid(response: response) {
                switch response.result {
                case .success(let responseJSON):
                    
                    if let responseJSON = responseJSON as? [String:Any], let result = responseJSON["Result"] as? [String:Any] {
                        successCallback(result as AnyObject)
                    } else {
                        successCallback(responseJSON as AnyObject)
                        print(responseJSON as Any)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    failureCallback(error.localizedDescription)
                }
            } else {
                let error =  self.getErrorForResponse(response: response)
                failureCallback(error)
            }
        }
    }
    
    
    
    //MARK: Request Without Headers
    func requestWithoutHeaders(url:String,method:HTTPMethod,encoding: ParameterEncoding = JSONEncoding.default,parameters:Parameters?=nil,completionCallback:@escaping (AnyObject) -> Void ,success successCallback: @escaping (AnyObject?) -> Void ,failure failureCallback: @escaping (String?) -> Void) {
        
        DispatchQueue.main.async {
            self.showProgressHUD()
        }

        URLCache.shared.removeAllCachedResponses()
        
        let urlStr = url.urlQueryEncoding
        let combinedURL = "\(API.productionURL)\(urlStr ?? "")"
        print("URL -> \(combinedURL)")
        print("Parameters -> \(parameters ?? [:])")
        
//        var encoding:ParameterEncoding!
//        if method == .get {
//            encoding = JSONEncoding.default//URLEncoding.Destination.methodDependent as? ParameterEncoding
//        } else {
//            encoding = JSONEncoding.default
//        }
        
        AF.request(combinedURL, method: method, parameters: parameters, encoding: encoding, headers: nil).responseJSON { [self] (response) in
            print(response.value as Any, "@#$#$%^$#%^#$%@#$%@#$^%^@#$%@#$!@#$")
            completionCallback(response as AnyObject)
            DispatchQueue.main.async {
                self.hideProgressHUD()
            }
            print("Response Data->",response.data)
            print("Response ->",response)
            if self.isResponseValid(response: response) {
                switch response.result {
                case .success(let responseJSON):
                    
                    if let responseJSON = responseJSON as? [String:Any], let result = responseJSON["Result"] as? [String:Any] {
                        successCallback(result as AnyObject)
                    } else {
                        successCallback(responseJSON as AnyObject)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    failureCallback(error.localizedDescription)
                }
                
            } else {
                let error =  self.getErrorForResponse(response: response)
                failureCallback(error)
            }
        }
    }
    
    //MARK: Upload
    func upload(url:String,method:HTTPMethod,parameters:Parameters?=nil,completionCallback:@escaping (AnyObject) -> Void ,success successCallback: @escaping (AnyObject) -> Void ,failure failureCallback: @escaping (String?) -> Void) {
        
        let combinedURL = "\(API.productionURL)\(url)"
        print("URL -> \(combinedURL)")
        print("Parameters -> \(parameters ?? [:])")
        
        var headers:HTTPHeaders?
                 headers = HTTPHeaders()
                 headers!["Authorization"] = "JWT {{\(kUserData?.jwt_token ?? "")}}"
        
        AF.upload(
            multipartFormData: { multipartFormData in
                
                if let parameters = parameters {
                    for (key, value) in parameters {
                        
                        if value is UIImage {
                            let item = value as! UIImage
                            if let imageData = item.jpegData(compressionQuality: 0.6) {
                                multipartFormData.append(imageData, withName: key, fileName: "\(key).jpg", mimeType: "image/jpeg")
                            }
                            
                        } else if let item = value as? URL,  item.absoluteString.contains(".pdf") {
                            
                            do {
                                let data = try Data(contentsOf: item)
                                multipartFormData.append(data, withName: key, fileName: "\(UUID()).pdf", mimeType: "application/pdf")
                            } catch  {
                                print("xcxzczxcxz")
                            }
                            

                        }  else if let item = value as? URL,  item.absoluteString.contains(".rtf") {
                            
                            let data = try! Data.init(contentsOf: item)
                            multipartFormData.append(data, withName: key, fileName: "\(UUID()).txt", mimeType: "application/txt")
                        }
                        
                        if let files = value as? [UIImage] {
                            for item in files {
                                if let imageData = item.jpegData(compressionQuality: 0.6) {
                                    multipartFormData.append(imageData, withName: key, fileName: "\(Date()).jpg", mimeType: "image/jpeg")
                                }
                            }
                        }
                        
                        let stringValue = "\(value)"
                        multipartFormData.append((stringValue.data(using: .utf8))!, withName: key)
                    }
                }
        },
            to: combinedURL,
            method: method,
            headers: headers)
            .responseJSON { (response) in
                
                print(response.value as Any)
                completionCallback(response as AnyObject)
                
                if self.isResponseValid(response: response) {
                    switch response.result {
                    case .success(let responseJSON):
                        successCallback(responseJSON as AnyObject)
                    case .failure(let error):
                        failureCallback(error.localizedDescription)
                    }
                } else {
                    let error =  self.getErrorForResponse(response: response)
                    failureCallback(error)
                }
                
        }
    }
    
    //MARK: isResponseValid
    private func isResponseValid(response: AFDataResponse<Any>) -> Bool {
        if let statusCode = response.response?.statusCode, statusCode == 0 {
            return false
        }
        
        if let response = response.value as? [String: Any] {
            if let status = response["Status"] as? Bool, status == false {
                return false
            }
        }
        return true
    }
    
    //MARK: getErrorsForResponse
    func getErrorForResponse(response: AFDataResponse<Any>) -> String? {
        switch response.result {
        case .success(let responseJSON):
            if let response = responseJSON as? [String: Any] {
        
                if let errorMessage = response["Message"] as? String {
                    return errorMessage
                }
                
                return response.description
            }
            return nil
        case .failure(let errorObj):
            return errorObj.localizedDescription
        }
    }
}


