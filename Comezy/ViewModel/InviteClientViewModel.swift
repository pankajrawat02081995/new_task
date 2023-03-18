//
//  InviteClientViewModel.swift
//  Comezy
//
//  Created by aakarshit on 28/07/22.
//

import Foundation

class InviteClientViewModel: NSObject {
    func addPerson(firstName:String, lastName: String, email: String, type: String, phone:String ,completionHandler: @escaping(_ status: Bool, _ variationModel: InviteWorkerModel?, _ errorMsg: String?) -> Void){
        
        
        var parameters = [String : Any]()
        parameters = [    "first_name": firstName,
                          "last_name": lastName,
                          "user_type": type,
                          "phone":phone,
                          "email": email,
                    ]
//        parameters = ["name": name, "summary": summary, "sender": sender, "price": price, "total_price": totalPrice, "receiver": receiver,  "file": file, "project":project, "gst": gst]
        
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async {
            APIManager.shared.request(url: API.invitePerson, method: .post,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let decodedData = try JSONDecoder().decode(BaseResponse<InviteWorkerModel>.self, from: jsonData)
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
    
    func invitePerson(firstName:String, lastName: String, email: String, type: String,phone:String ,completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ response: InviteWorkerModel?) -> Void){
        if(firstName.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kInvitePersonFirstName, nil)
        }
        else if (lastName.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kInvitePersonLastName, nil)
        }else if (phone.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kInvitePersonPhoneName, nil)
        }
        else if (email.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kInvitePersonEmail, nil)
        }
        else {
            self.addPerson(firstName: firstName, lastName: lastName, email: email, type: type, phone:phone) { success, response, message in
                if success {
                    completionHandler(true, message, response)
                } else {
                    completionHandler(false,message, nil)
                }
            }
        }
    }
}
