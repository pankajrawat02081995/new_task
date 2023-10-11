//
//  EditToolBoxViewModel.swift
//  Comezy
//
//  Created by aakarshit on 25/06/22.
//

import Foundation

class EditToolBoxViewModel: NSObject {
    func putToolBox( name:String, topicOfDiscussion: String, remedies: String, file: [String], eotId: Int, completionHandler: @escaping(_ status: Bool, _ variationModel: AddToolBoxModel?, _ errorMsg: String?) -> Void){
        
        
        var parameters = [String : Any]()
        parameters = [    "name": name,
                          "file": file,
                          "topic_of_discussion": topicOfDiscussion,
                          "remedies": remedies
                    ]
    //        parameters = ["name": name, "summary": summary, "sender": sender, "price": price, "total_price": totalPrice, "receiver": receiver,  "file": file, "project":project, "gst": gst]
        var url = API.editToolBox
        url = url + "\(eotId)"
        
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
            APIManager.shared.request(url: url, method: .put,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let decodedData = try JSONDecoder().decode(BaseResponse<AddToolBoxModel>.self, from: jsonData)
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
    func updateToolBox(name:String, topicOfDiscussion: String, remedies: String, file: [String], eotId: Int, completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ type: String?) -> Void){
        
        if(name.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddEOTTitleEmpty, "")
        }

        else if (topicOfDiscussion.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddTopicOfDiscussion,"")
        }
        else if (remedies.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddRemedies, "")
        }
        else {
            
            putToolBox(name: name , topicOfDiscussion: topicOfDiscussion, remedies: remedies, file: file, eotId: eotId) { success, response, message in
                if success {
                    completionHandler(true, nil, "")
                } else {
                    completionHandler(false,nil, "An error occured!")
                }
            }
        }
    }
}
