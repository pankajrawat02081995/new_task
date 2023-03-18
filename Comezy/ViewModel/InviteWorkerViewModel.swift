//
//  InviteWorkerViewModel.swift
//  Comezy
//
//  Created by aakarshit on 28/07/22.
//

import Foundation

class InviteWorkerViewModel: NSObject {
    func addWorker(firstName:String, lastName: String, email: String, type: String, projectId: Int, inductionURL: String ,phone:String ,completionHandler: @escaping(_ status: Bool, _ variationModel: InviteWorkerModel?, _ errorMsg: String?) -> Void){
        
        
        var parameters = [String : Any]()
        
        parameters = [                          "user_type": type,
                                                "first_name": firstName,
                                                "last_name": lastName,
                                                "email": email,
                                                "project": projectId,
                                                "phone": phone,
                                                "induction_url": inductionURL
        ]
        //        parameters = ["name": name, "summary": summary, "sender": sender, "price": price, "total_price": totalPrice, "receiver": receiver,  "file": file, "project":project, "gst": gst]
        
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
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
    
    func inviteWorker(firstName:String, lastName: String, email: String, type: String, projectId: Int, inductionURL: String, phone:String ,completionHandler:@escaping (_ sucess:Bool,_ response: InviteWorkerModel?, _ eror:String?) -> Void){
        if(firstName.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,nil,FieldValidation.kInvitePersonFirstName)
        }
        else if (lastName.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,nil,FieldValidation.kInvitePersonLastName)
        }
        else if (phone.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,nil,FieldValidation.kInvitePersonPhoneName)
        }
        else if (email.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,nil,FieldValidation.kInvitePersonEmail)
        }
        else {
            self.addWorker(firstName: firstName, lastName: lastName, email: email, type: type,  projectId: projectId, inductionURL: inductionURL,phone: phone ) { success, response, message in
                if success {
                    completionHandler(true, response, "")
                } else {
                    completionHandler(false,nil, message)
                }
            }
        }
    }
}
