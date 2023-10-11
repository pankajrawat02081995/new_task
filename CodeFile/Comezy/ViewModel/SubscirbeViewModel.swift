//
//  InviteMailViewModel.swift
//  Comezy
//
//  Created by amandeepsingh on 04/08/22.
//

import Foundation

class SubscribeViewModel: NSObject {
    func createSubscription(planId:String, startTime: String ,applicationContext: [String:Any],completionHandler: @escaping(_ status: Bool, _ createSubscriptionModel: CreateSubscriptionModel?, _ errorMsg: String?) -> Void){
        
        
        var parameters = [String : Any]()
        
        parameters = [
                                                "plan_id": planId,
                                                "start_time": startTime,
                                                "application_context":  [
                                                    "return_url" : "https://example.com/returnUrl",
                                                    "cancel_url": "https://example.com/cancelUrl"
                                                ]
        ]
        //        parameters = ["name": name, "summary": summary, "sender": sender, "price": price, "total_price": totalPrice, "receiver": receiver,  "file": file, "project":project, "gst": gst]
        
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.createSubscription, method: .post,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let decodedData = try JSONDecoder().decode(BaseResponse<CreateSubscriptionModel>.self, from: jsonData)
                        print(decodedData)
                        if decodedData.code == 200 {
                            completionHandler(true, decodedData.data!, "")
                        } else {
                            completionHandler(false, nil ,decodedData.message ?? "")
                        }
                        
                    }
                    catch let err {
                        print("!@#$!@#$@#$%^#    FAILED  $%$%^$%^##$%", err)
                        completionHandler(false,nil,err.localizedDescription ?? "")
                    }
                }
            }) { (error) in
                print("json error", error)
                completionHandler(false,nil,error)
            }
            
        }
        
    }
    //Reactivate Subscription Id
    func reActivateSubscription(subscriptionId:String,completionHandler: @escaping(_ status: Bool, _ createSubscriptionModel: ReactivateSubscriptionModelDataClass?, _ errorMsg: String?) -> Void){
        
        
        var url:String = API.reactivateSubscription+"\(subscriptionId)"
        
        print("parameters @#$%@#$^%#^%#$%@", url)
        DispatchQueue.main.async{
            APIManager.shared.request(url: url, method: .post,parameters:nil ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let decodedData = try JSONDecoder().decode(ReactivateSubscriptionModel.self, from: jsonData)
                        print(decodedData)
                        if decodedData.code == 200 {
                            completionHandler(true, decodedData.data, "")
                        } else {
                            completionHandler(false, nil ,decodedData.message ?? "")
                        }
                        
                    }
                    catch let err {
                        print("!@#$!@#$@#$%^#    FAILED  $%$%^$%^##$%", err)
                        completionHandler(false,nil,err.localizedDescription ?? "")
                    }
                }
            }) { (error) in
                print("json error", error)
                completionHandler(false,nil,error)
            }
            
        }
        
    }
    //Method Get Subscription Id
    func getSubscriptionId(completionHandler: @escaping(_ status: Bool, _ getSubscriptionId: [GetSubscriptionIdModel]?, _ errorMsg: String?) -> Void){
        
        var url = API.getSubscriptionId
        DispatchQueue.main.async{
            APIManager.shared.request(url: url, method: .get,parameters:nil ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let decodedData = try JSONDecoder().decode(BaseResponse<[GetSubscriptionIdModel]>.self, from: jsonData)
                        print(decodedData)
                        if decodedData.code == 200 {
                            completionHandler(true, decodedData.data , "")
                        } else {
                            completionHandler(false, nil, decodedData.message ?? "Error occured while Decoding")
                        }
                        
                    }
                    catch let err {
                        print("!@#$!@#$@#$%^#    FAILED  $%$%^$%^##$%", err)
                        completionHandler(false,nil,err.localizedDescription ?? "")
                    }
                }
            }) { (error) in
                print("json error", error)
                completionHandler(false,nil,error)
            }
            
        }
        
    }


    func sendSubscribedUser(subscriptionId:String, completionHandler: @escaping(_ status: Bool, _ createSubscriptionModel: SendSubscribedUserModel?, _ errorMsg: String?) -> Void){
        var url = API.sendSubscribedUser
        url = url + "?subscription_id=" + "\(subscriptionId)"
        DispatchQueue.main.async{
            APIManager.shared.request(url: url, method: .post,parameters:nil ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let decodedData = try JSONDecoder().decode(BaseResponse<SendSubscribedUserModel>.self, from: jsonData)
                        print(decodedData)
                        if decodedData.code == 200 {
                            completionHandler(true, decodedData.data!, "")
                        } else {
                            completionHandler(false, nil ,decodedData.message ?? "")
                        }
                        
                    }
                    catch let err {
                        print("!@#$!@#$@#$%^#    FAILED  $%$%^$%^##$%", err)
                        completionHandler(false,nil,err.localizedDescription ?? "")
                    }
                }
            }) { (error) in
                print("json error", error)
                completionHandler(false,nil,error)
            }
        }
    }
    
    
    
    
    func createStripeSubscription(email:String, name: String ,applicationContext: [String:Any],completionHandler: @escaping(_ status: Bool, _ createSubscriptionModel: CreateSubscriptionModel?, _ errorMsg: String?) -> Void){
        
        
        var parameters = [String : Any]()
        
        parameters = [
                                                "customer_email": email,
                                                "customer_name": name,
                                                "application_context":  [
                                                    "return_url" : AppConstant.STRIPE_RETURN_URL,
                                                    "cancel_url": AppConstant.STRIPE_CANCEL_URL
                                                ]
        ]
        //        parameters = ["name": name, "summary": summary, "sender": sender, "price": price, "total_price": totalPrice, "receiver": receiver,  "file": file, "project":project, "gst": gst]
        
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.createSubscription, method: .post,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let decodedData = try JSONDecoder().decode(BaseResponse<CreateSubscriptionModel>.self, from: jsonData)
                        print(decodedData)
                        if decodedData.code == 200 {
                            completionHandler(true, decodedData.data!, "")
                        } else {
                            completionHandler(false, nil ,decodedData.message ?? "")
                        }
                        
                    }
                    catch let err {
                        print("!@#$!@#$@#$%^#    FAILED  $%$%^$%^##$%", err)
                        completionHandler(false,nil,err.localizedDescription ?? "")
                    }
                }
            }) { (error) in
                print("json error", error)
                completionHandler(false,nil,error)
            }
            
        }
        
    }
    
}
