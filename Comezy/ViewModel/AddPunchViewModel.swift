//
//  AddPunchViewModel.swift
//  Comezy
//
//  Created by aakarshit on 21/06/22.
//

import Foundation

class AddPunchViewModel: NSObject {

    
    func createPunch( name:String,sender: Int, infoNeeded: String, file: [String],project: Int, receiver: [Int], checklist: [String], completionHandler: @escaping(_ status: Bool, _ variationModel: AddPunchModel?, _ errorMsg: String?) -> Void){
        
        
        var parameters = [String : Any]()
        parameters = [    "name": name,
                          "sender": sender,
                          "project": project,
                          "description": infoNeeded,
                          "file": file,
                          "receiver": receiver,
                          "checklist": checklist
                    ]
//        parameters = ["name": name, "summary": summary, "sender": sender, "price": price, "total_price": totalPrice, "receiver": receiver,  "file": file, "project":project, "gst": gst]
        
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.addPunch, method: .post,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let decodedData = try JSONDecoder().decode(BaseResponse<AddPunchModel>.self, from: jsonData)
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
    func addPunch(name: String,sender: Int?, infoNeeded: String, file: [String], project: Int, receiver: [Int], checklist: [String] ,completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ type: String?) -> Void){
        var isACheckEmpty = false
        for i in checklist {
            if i == "" {
                isACheckEmpty = true
            }
                
        }
        
        if(name.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddPunchTitleEmpty, "")
        }
        else if (sender == nil){
            completionHandler(false,FieldValidation.kVariationFromEmpty, "")
        }
        else if (receiver.isEmpty) {
            completionHandler(false,FieldValidation.kVariationToEmpty, "")
        }
        else if (infoNeeded.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddPunchDescriptionEmpty,"")
        }
        else if isACheckEmpty {
            completionHandler(false,FieldValidation.kAddPunchChecklistEmpty, "")
        }
        else if checklist.count == 0 {
            completionHandler(false,FieldValidation.kAddPunchChecklistCountZero, "")
        }
        else {
            
            self.createPunch(name: name, sender: sender!, infoNeeded: infoNeeded, file: file, project: project, receiver: receiver, checklist: checklist) { success, response, message in
                if success {
                    completionHandler(true, nil, "")
                } else {
                    completionHandler(false,nil, "An error occured!")
                }
            }
        }
    }
}
