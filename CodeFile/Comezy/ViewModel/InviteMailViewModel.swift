//
//  InviteMailViewModel.swift
//  Comezy
//
//  Created by amandeepsingh on 04/08/22.
//

import Foundation

class InviteMailViewModel: NSObject {
    func sendInviteMail(inviteId:String, inviteLink: String ,completionHandler: @escaping(_ status: Bool, _ variationModel: EmptyData?, _ errorMsg: String?) -> Void){
        
        
        var parameters = [String : Any]()
        
        parameters = [
                                                "invite_id": inviteId,
                                                "invite_link": inviteLink
        ]
        //        parameters = ["name": name, "summary": summary, "sender": sender, "price": price, "total_price": totalPrice, "receiver": receiver,  "file": file, "project":project, "gst": gst]
        
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.sendInviteMail, method: .post,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let decodedData = try JSONDecoder().decode(BaseResponse<EmptyData>.self, from: jsonData)
                        print(decodedData)
                        if decodedData.code == 200 {
                            completionHandler(true, decodedData.data!, "")
                        } else {
                            completionHandler(false, nil ,decodedData.message ?? "")
                        }
                        
                    }
                    catch let err {
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
