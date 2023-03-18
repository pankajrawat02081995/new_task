//
//  CancelSubscriptionViewModel.swift
//  Comezy
//
//  Created by amandeepsingh on 08/08/22.
//

import Foundation
class CancelSubscriptionViewModel: NSObject {

func cancelSubscription(subscriptionId:String, completionHandler: @escaping(_ status: Bool, _ createSubscriptionModel: CancelSubscriptionModel?, _ errorMsg: String?) -> Void){
    
//    var parameters = [String : Any]()
//    parameters = ["reason": "Reactivating with the service",
//                    "application_context":["return_url": "https://example.com/returnUrl","cancel_url": "https://example.com/cancelUrl"]]
//
//        print("parameters @#$%@#$^%#^%#$%@", parameters)
    var url = API.cancelSubscription
    url = url + "?subscription_id=" + "\(subscriptionId)"
    DispatchQueue.main.async{
        APIManager.shared.request(url: url, method: .post,parameters:nil ,completionCallback: { (_ ) in
            
        }, success: {  (json) in
            print("json", json)
            if let json = json {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject:json)
                    let decodedData = try JSONDecoder().decode(CancelSubscriptionModel.self, from: jsonData)
                    print(decodedData)
                    if decodedData.code == 200 {
                        completionHandler(true, nil , "")
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
    func getSubscriptionId(completionHandler: @escaping(_ status: Bool, _ getSubscriptionId: [GetSubscriptionIdModel]?, _ errorMsg: String?) -> Void){
        
        
    //        var parameters = [String : Any]()
    //
    //        parameters = ["subscription_id": subscriptionId]
    //        //        parameters = ["name": name, "summary": summary, "sender": sender, "price": price, "total_price": totalPrice, "receiver": receiver,  "file": file, "project":project, "gst": gst]
    //
    //        print("parameters @#$%@#$^%#^%#$%@", parameters)
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
}
