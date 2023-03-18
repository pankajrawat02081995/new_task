//
//  AddToolBoxViewModel.swift
//  Comezy
//
//  Created by aakarshit on 25/06/22.
//

import Foundation

class AddToolBoxViewModel: NSObject {
    func createToolBox( name:String,sender: Int, topicOfDiscussion: String, remedies: String, file: [String], project: Int, receiver: [Int],  completionHandler: @escaping(_ status: Bool, _ variationModel: AddToolBoxModel?, _ errorMsg: String?) -> Void){
        
        
        var parameters = [String : Any]()
        parameters = [    "name": name,
                          "sender": sender,
                          "project": project,
                          "receiver": receiver,
                          "file": file,
                          "topic_of_discussion": topicOfDiscussion,
                          "remedies": remedies
                    ]
    //        parameters = ["name": name, "summary": summary, "sender": sender, "price": price, "total_price": totalPrice, "receiver": receiver,  "file": file, "project":project, "gst": gst]
        
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.addToolBox, method: .post,parameters:parameters ,completionCallback: { (_ ) in
                
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
    func addToolBox(name:String,sender: Int, topicOfDiscussion: String, remedies: String, file: [String], project: Int, receiver: [Int],completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ type: String?) -> Void){
        
        if(name.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddEOTTitleEmpty, "")
        }
        else if (sender == nil){
            completionHandler(false,FieldValidation.kVariationFromEmpty, "")
        }
        else if (receiver.isEmpty) {
            completionHandler(false,FieldValidation.kVariationToEmpty, "")
        }
        else if (topicOfDiscussion.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddTopicOfDiscussion,"")
        }
        else if (remedies.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddRemedies, "")
        }
        else {
            
            createToolBox(name: name ,sender: sender, topicOfDiscussion: topicOfDiscussion, remedies: remedies, file: file, project: project, receiver: receiver) { success, response, message in
                if success {
                    completionHandler(true, nil, "")
                } else {
                    completionHandler(false,nil, "An error occured!")
                }
            }
        }
    }

}

