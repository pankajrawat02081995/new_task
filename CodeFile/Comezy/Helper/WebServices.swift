//
//  WebServices.swift
//  Picker
//
//  Created by Developer IOS on 29/05/23.
//

import UIKit
import MBProgressHUD
import Alamofire

class WebServices {
    
    
    
    
    private var progressHUD: MBProgressHUD?
    
    
    
    static var shared: WebServices {
        return WebServices()
    }
    fileprivate init(){}
    
    //MARK: - App Header
    func headers() -> [String:String] {
        var headersVal = [
            Param.contentType:Param.appJson,
            Param.deviceId:AppInfo.DeviceId,
            Param.deviceType:Param.ios,
            Param.appVersion:AppInfo.appVersion
            
        ]
        if accessTokenSaved != "" {
            headersVal[Param.auth] = "JWT \(accessTokenSaved)"
        }
        return headersVal
    }
    
    //MARK: - App Header
    func headersWithToken(_ token:String) -> [String:String] {
        let headersVal = [
            Param.contentType:Param.appJson,
            Param.deviceId:AppInfo.DeviceId,
            Param.deviceType:Param.ios,
            Param.appVersion:AppInfo.appVersion,
            Param.auth:"\(token)"
        ]
        return headersVal
    }
    
    
    
    
    
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

    
    
    
    //MARK: - Post With Header Data API Interaction
    func postDataWithHeader(_ urlStr: String, params: [String:Any],headers: [String:String],showIndicator: Bool,methodType: HTTPMethod,completion: @escaping (_ response: ResponseHandle) -> Void) {
        if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                CommonMethod.shared.showActivityIndicator()
                self.showProgressHUD()
            }
            debugPrint("URL:- ",urlStr)
            debugPrint("Params:- ", params)
            debugPrint("Headers:- ",headers)
            AF.request(urlStr, method: methodType, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers)).responseJSON { response in
                DispatchQueue.main.async {
                    if showIndicator {
                        CommonMethod.shared.hideActivityIndicator()
                        self.hideProgressHUD()
                    }
                    if response.data != nil && response.error == nil {
                        if let JSON = response.value as? NSDictionary {
                            debugPrint("JSON:- ", JSON)
                            if response.response?.statusCode == 200 {
                                completion(ResponseHandle(data: response.data!, JSON: JSON, message: self.getErrorMsg(JSON),isSuccess: true))
                            } else if response.response?.statusCode == 401 {
                                self.statusHandler(response)
                            } else {
                                CommonMethod.shared.hideActivityIndicator()
                                self.hideProgressHUD()
                                completion(ResponseHandle(data: response.data!, JSON: JSON, message: self.getErrorMsg(JSON), isSuccess: false, statusCode: response.response?.statusCode ?? 204))
                            }
                        } else {
                            CommonMethod.shared.hideActivityIndicator()
                            self.hideProgressHUD()
                            self.statusHandler(response)
                        }
                    } else {
                        CommonMethod.shared.hideActivityIndicator()
                        self.hideProgressHUD()
                        self.statusHandler(response)
                    }
                }
            }
        } else {
            CommonMethod.shared.hideActivityIndicator()
            self.hideProgressHUD()
            Alerts.shared.openSettingApp()
        }
    }
    
    //MARK: - Post Data API Interaction
    func postData(_ urlStr: String, params: [String:Any], showIndicator: Bool,methodType: HTTPMethod,completion: @escaping (_ response: ResponseHandle) -> Void) {
        if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                CommonMethod.shared.showActivityIndicator()
                self.showProgressHUD()
            }
            debugPrint("URL:- ",urlStr)
            debugPrint("Params:- ", params)
            debugPrint("Headers:- ",headers())
            AF.request(urlStr, method: methodType, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers())).responseJSON { response in
                DispatchQueue.main.async {
                    if showIndicator {
                        self.hideProgressHUD()
                        CommonMethod.shared.hideActivityIndicator()
                    }
                    if response.data != nil && response.error == nil {
                        if let JSON = response.value as? NSDictionary {
                            debugPrint("JSON:- ", JSON)
                            //debugPrint("JSON String:- ", NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) ?? "")
                            if response.response?.statusCode == 200 {
                                completion(ResponseHandle(data: response.data!, JSON: JSON, message: self.getErrorMsg(JSON),isSuccess: true))
                            } else if response.response?.statusCode == 401 {
                                self.statusHandler(response)
                            } else {
                                CommonMethod.shared.hideActivityIndicator()
                                self.hideProgressHUD()
                                completion(ResponseHandle(data: response.data!, JSON: JSON, message: self.getErrorMsg(JSON), isSuccess: false, statusCode: response.response?.statusCode ?? 204))
                            }
                        } else {
                            CommonMethod.shared.hideActivityIndicator()
                            self.hideProgressHUD()
                            self.statusHandler(response)
                        }
                    } else {
                        CommonMethod.shared.hideActivityIndicator()
                        self.hideProgressHUD()
                        self.statusHandler(response)
                    }
                }
            }
        } else {
            CommonMethod.shared.hideActivityIndicator()
            self.hideProgressHUD()
            Alerts.shared.openSettingApp()
        }
    }
    
    //MARK: - Get Data With Header API Interaction
    func getDataWithHeaderNFTList(_ urlStr: String, headers: [String:String], showIndicator: Bool, completion: @escaping(_ response: ResponseHandle) -> Void) {
        if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                CommonMethod.shared.showActivityIndicator()
                self.showProgressHUD()
            }
            debugPrint("URL:- ",urlStr)
            debugPrint("Headers:- ",headers)
            AF.request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HTTPHeaders(headers)).responseJSON { response in
                DispatchQueue.main.async {
                    if showIndicator {
                        CommonMethod.shared.hideActivityIndicator()
                        self.hideProgressHUD()
                    }
                    if response.data != nil && response.error == nil {
                        if let JSON = response.value as? NSDictionary {
                            debugPrint("JSON:- ", JSON)
                            if response.response?.statusCode == 200 {
                                completion(ResponseHandle(data: response.data!, JSON: JSON, message: self.getErrorMsg(JSON),isSuccess: true))
                            } else {
                                completion(ResponseHandle(data: response.data!, JSON: JSON, message: self.getErrorMsg(JSON),isSuccess: false))
                            }
                        } else {
                            self.statusHandler(response)
                        }
                    } else {
                        debugPrint("Response.error:- ",response.error?.localizedDescription ?? "")
                        if (response.error?.localizedDescription ?? "").contains(Constantss.AlertMessages.connectionWasLost) {
                            completion(ResponseHandle(data: Data(), JSON: [:], message: Constantss.AlertMessages.connectionWasLost,isSuccess: false))
                        } else {
                            self.statusHandler(response)
                        }
                    }
                }
            }
        } else {
            CommonMethod.shared.hideActivityIndicator()
            self.hideProgressHUD()
           Alerts.shared.openSettingApp()
        }
    }
    
    //MARK: - Get Data API Interaction
    func getData(_ urlStr: String, showIndicator: Bool, completion: @escaping(_ response: ResponseHandle) -> Void) {
        if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                CommonMethod.shared.showActivityIndicator()
                self.showProgressHUD()
                
            }
            debugPrint("URL:- ",urlStr)
            debugPrint("Headers:- ",headers())
            AF.request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HTTPHeaders(headers())).responseJSON { response in
                DispatchQueue.main.async {
                    if showIndicator {
                        CommonMethod.shared.hideActivityIndicator()
                        self.hideProgressHUD()
                    }
                    if response.data != nil && response.error == nil {
                        if let JSON = response.value as? NSDictionary {
                            debugPrint("JSON:- ", JSON)
                            if response.response?.statusCode == 200 {
                                completion(ResponseHandle(data: response.data!, JSON: JSON, message: self.getErrorMsg(JSON),isSuccess: true))
                            } else if response.response?.statusCode == 401 {
                                self.statusHandler(response)
                            } else {
                                completion(ResponseHandle(data: response.data!, JSON: JSON, message: self.getErrorMsg(JSON),isSuccess: false))
                            }
                        } else {
                            self.statusHandler(response)
                        }
                    } else {
                        debugPrint("Response.error:- ",response.error?.localizedDescription ?? "")
                        if (response.error?.localizedDescription ?? "").contains(Constantss.AlertMessages.connectionWasLost) {
                            completion(ResponseHandle(data: Data(), JSON: [:], message: Constantss.AlertMessages.connectionWasLost,isSuccess: false))
                        } else {
                            self.statusHandler(response)
                        }
                    }
                }
            }
        } else {
            CommonMethod.shared.hideActivityIndicator()
            self.hideProgressHUD()
            Alerts.shared.openSettingApp()
        }
    }
    
    //MARK: - Upload Image API Interaction
    func uploadImage(_ parameters:[String:AnyObject],parametersImage:[String:AnyObject],videoUrl:URL?,videoParam: String,addImageUrl:String, showIndicator: Bool,methodType: HTTPMethod,documentParam:[String:Data],completion:@escaping(_ response: ResponseHandle) -> Void) {
        if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                CommonMethod.shared.showActivityIndicator()
                self.showProgressHUD()
            }
            debugPrint("URL:- ",addImageUrl)
            debugPrint("Params:- ", parameters)
            debugPrint("Params Image:- ", parametersImage)
            debugPrint("Params Document:- ", documentParam)
            debugPrint("Header:- ", headers())
            AF.upload(multipartFormData: { multipartFormData in
                for (key, val) in parameters {
                    multipartFormData.append(val.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                for (key, val) in parametersImage {
                    let timeStamp = Date().timeIntervalSince1970 * 1000
                    let fileName = "image\(timeStamp).png"
                    if let getImage = val as? UIImage {
                        guard let imageData = getImage.jpegData(compressionQuality: 0.2) else {
                            return
                        }
                        multipartFormData.append(imageData, withName: key, fileName: fileName , mimeType: "image/png")
                    }
                }
                if videoUrl != nil {
                    let videoFileName = "video\(Date().timeIntervalSince1970 * 1000).mp4"
                    multipartFormData.append(videoUrl!, withName: videoParam, fileName: videoFileName, mimeType: "video/mp4")
                }
                for (key, value) in documentParam {
                    let timeStamp = Date().timeIntervalSince1970 * 1000
                    let fileName = "pdfFile\(timeStamp).pdf"
                    multipartFormData.append(value, withName: key, fileName: fileName, mimeType:"application/pdf")
                }
            },to: addImageUrl,method: methodType, headers: HTTPHeaders(headers())).responseJSON { response in
                CommonMethod.shared.hideActivityIndicator()
                self.hideProgressHUD()
                if response.data != nil && response.error == nil {
                    if let JSON = response.value as? NSDictionary {
                        debugPrint("JSON:- ", JSON)
                       // debugPrint("JSON String:- ", NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) ?? "")
                        if response.response?.statusCode == 200 {
                            completion(ResponseHandle(data: response.data!, JSON: JSON, message: self.getErrorMsg(JSON),isSuccess: true))
                        } else if response.response?.statusCode == 401 {
                            self.statusHandler(response)
                        } else {
                            completion(ResponseHandle(data: response.data!, JSON: JSON, message: self.getErrorMsg(JSON),isSuccess: false))
                        }
                    } else {
                        self.statusHandler(response)
                    }
                } else {
                    self.statusHandler(response)
                }
            }
        } else {
            CommonMethod.shared.hideActivityIndicator()
            self.hideProgressHUD()
            Alerts.shared.openSettingApp()
        }
    }
    
    func isInternetWorking() -> Bool {
        if NetworkReachabilityManager()!.isReachable {
            return true
        } else {
            return false
        }
    }
    
    //MARK: - Error Handling Methos
    func statusHandler(_ response:AFDataResponse<Any>) {
        CommonMethod.shared.hideActivityIndicator()
        self.hideProgressHUD()
        var messageStr = String()
        if let code = response.response?.statusCode {
            if let JSON = response.value as? NSDictionary {
                messageStr = getErrorMsg(JSON)
                debugPrint("Error :- ",messageStr)
                switch code {
                case 400:
                    Alerts.shared.showAlert(title: AppInfo.alert, message: messageStr)
                  
                case 401:
                    Alerts.shared.alertMessageWithActionOk(title: AppInfo.alert, message: Constantss.AlertMessages.sessionExpire) {
                        accessTokenSaved = ""
                        UINavigationController().viewControllers = []
                        RootControllerProxy.shared.rootWithoutDrawer(ViewControllers.loginVC, storyboard: .loginSignUpFlow)
                    }
                default:
                    Alerts.shared.showAlert(title: AppInfo.alert, message: messageStr)
                }
            } else {
                if response.data != nil {
                    messageStr = (NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) ?? "") as String
                    messageStr = messageStr == "" ? Constantss.AlertMessages.serverNotResponding : messageStr
                } else {
                    if response.error != nil {
                        messageStr = response.error?.localizedDescription ?? Constantss.AlertMessages.serverNotResponding
                    } else {
                        messageStr = Constantss.AlertMessages.serverNotResponding
                    }
                }
                debugPrint("Error :- ",messageStr)
                if let code = response.response?.statusCode {
                    switch code {
                    case 400:
                        Alerts.shared.showAlert(title: AppInfo.alert, message: messageStr)
                    case 401:
                        Alerts.shared.alertMessageWithActionOk(title: AppInfo.alert, message: Constantss.AlertMessages.sessionExpire) {
                            accessTokenSaved = ""
                            UINavigationController().viewControllers = []
                            RootControllerProxy.shared.rootWithoutDrawer(ViewControllers.loginVC, storyboard: .main)
                        }
                    default:
                        Alerts.shared.showAlert(title: AppInfo.alert, message: messageStr)
                    }
                } else {
                    Alerts.shared.showAlert(title: AppInfo.alert, message: messageStr)
                }
            }
        } else {
            if response.data != nil {
                messageStr = (NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) ?? "") as String
                messageStr = messageStr == "" ? Constantss.AlertMessages.serverNotResponding : messageStr
            } else {
                if response.error != nil {
                    messageStr = response.error?.localizedDescription ?? Constantss.AlertMessages.serverNotResponding
                } else {
                    messageStr = Constantss.AlertMessages.serverNotResponding
                }
            }
            debugPrint("Error :- ",messageStr)
            Alerts.shared.showAlert(title: AppInfo.alert, message: messageStr)
        }
    }
    
    //MARK: - Get Error Message
    func getErrorMsg(_ json: NSDictionary) -> String {
        var msgStr = String()
        if let errorMsg = json["error"] as? String {
            msgStr = errorMsg
        } else if let errorMessage = json["message"] as? String {
            msgStr = errorMessage
        } else if let errorMessage = json["detail"] as? String {
            msgStr = errorMessage
        } else {
            msgStr = Constantss.AlertMessages.serverNotResponding
        }
        return msgStr
    }
}
