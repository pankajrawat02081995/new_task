//
//  NotificationsViewModel.swift
//  Comezy
//
//  Created by aakarshit on 13/07/22.
//

import Foundation

class NotificationsViewModel: NSObject {
    static let shared = NotificationsViewModel()
    var objBadgeCount: NotificationBadgeCountModel?
    func getAllNotificationsCount(completionHandler: @escaping(_ success: Bool, _ resp: AllNotificationsCountModel?, _ errorMsg: String?) -> Void){
        
        DispatchQueue.main.async {
            let url = API.getAllNotificationsCount
            print(url)
            
            
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let result = try JSONDecoder().decode(BaseResponse<AllNotificationsCountModel>.self, from: jsonData)
                        print("ProjectList  :", result)
                        if result.code == 200 {
                            completionHandler(true, result.data, "")
                        } else {
                            completionHandler(false, nil, result.message ?? "Error occured while Decoding")
                        }
                        
                    }
                    catch let err{
                        print("ProjectList  err.localizedDescription:", err.localizedDescription)
                        completionHandler(false,nil,err.localizedDescription)
                    }
                }
            }) { (error) in
                print("ProjectList  error:", error as Any)
                completionHandler(false,nil,error)
                
            }
        }
    }
    func getAllNotifList(completionHandler: @escaping(_ success: Bool, _ resp: AllNotifcationListModel?, _ errorMsg: String?) -> Void){
      
        DispatchQueue.main.async{
            let url = API.getAllNotificationList + "page=1&size=1000"
            print(url)
            
            
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let result = try JSONDecoder().decode(BaseResponse<AllNotifcationListModel>.self, from: jsonData)
                        print("ProjectList  :", result)
                        if result.code == 200 {
                            completionHandler(true, result.data, "")
                            
                        } else {
                            completionHandler(false, nil, result.message ?? "Error occured while Decoding")
                        }
                        
                    }
                    catch let err{
                        print("ProjectList  err.localizedDescription:", err.localizedDescription)
                        completionHandler(false,nil,err.localizedDescription)
                    }
                }
            }) { (error) in
                print("ProjectList  error:", error as Any)
                completionHandler(false,nil,error)
                
            }
        }
    }
    func clearAllNotifCount(completionHandler: @escaping(_ success: Bool, _ resp: NotificationCountClearModel?, _ errorMsg: String?) -> Void){
      
        DispatchQueue.main.async{
            let url = API.clearAllNotificationCount
            print(url)
            
            
            APIManager.shared.requestWithoutHUD(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let result = try JSONDecoder().decode(BaseResponse<NotificationCountClearModel>.self, from: jsonData)
                        print("ProjectList  :", result)
                        if result.code == 200 {
                            completionHandler(true, result.data, "")
                            
                        } else {
                            completionHandler(false, nil, result.message ?? "Error occured while Decoding")
                        }
                        
                    }
                    catch let err{
                        print("ProjectList  err.localizedDescription:", err.localizedDescription)
                        completionHandler(false,nil,err.localizedDescription)
                    }
                }
            }) { (error) in
                print("ProjectList  error:", error as Any)
                completionHandler(false,nil,error)
                
            }
        }
    }
    func getBadgeCount(projectId: Int, completionHandler: @escaping(_ success: Bool, _ resp: NotificationBadgeCountModel?, _ errorMsg: String?) -> Void){
      
        DispatchQueue.main.async{
            var url = API.getBadgeCount
            url = url + "\(projectId)"
            print(url)
        
            
            APIManager.shared.requestWithoutHUD(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let result = try JSONDecoder().decode(BaseResponse<NotificationBadgeCountModel>.self, from: jsonData)
                        print("ProjectList  :", result)
                            if result.code == 200 {
                            completionHandler(true, result.data, "")
                                self.objBadgeCount = result.data
                        } else {
                            completionHandler(false, nil, result.message ?? "Error occured while Decoding")
                        }
                        
                    }
                    catch let err{
                        print("ProjectList  err.localizedDescription:", err.localizedDescription)
                        completionHandler(false,nil,err.localizedDescription)
                    }
                }
            }) { (error) in
                print("ProjectList  error:", error as Any)
                completionHandler(false,nil,error)
                
            }
        }
    }
    
    func clearBadgeCount(projectId: Int, module: String, completionHandler: @escaping(_ success: Bool, _ resp: NotificationBadgeCountModel?, _ errorMsg: String?) -> Void){
     //   if(kUserData?.user_type != UserType.kOwner){
        DispatchQueue.main.async{
            var url = API.clearBadgeCount
            url = url + "\(projectId)&type=\(module)"
            print(url)
        
            
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let result = try JSONDecoder().decode(BaseResponse<NotificationBadgeCountModel>.self, from: jsonData)
                        print("ProjectList  :", result)
                            if result.code == 200 {
                            completionHandler(true, result.data, "")
                                self.objBadgeCount = result.data

                            
                        } else {
                            completionHandler(false, nil, result.message ?? "Error occured while Decoding")
                        }
                        
                    }
                    catch let err{
                        print("ProjectList  err.localizedDescription:", err.localizedDescription)
                        completionHandler(false,nil,err.localizedDescription)
                    }
                }
            }) { (error) in
                print("ProjectList  error:", error as Any)
                completionHandler(false,nil,error)
                
            }
        }
    }
 //   }

}
