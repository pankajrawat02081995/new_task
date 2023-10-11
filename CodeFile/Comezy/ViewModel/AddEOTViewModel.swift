//
//  AddEOTViewModel.swift
//  Comezy
//
//  Created by aakarshit on 23/06/22.
//

import Foundation


class AddEOTViewModel: NSObject {

    
    func createEOT( name:String,sender: Int, reasonForDelay: String, project: Int, receiver: [Int], numberOfDays: String, extendDateFrom: String, extendDateTo: String,   completionHandler: @escaping(_ status: Bool, _ variationModel: AddEOTModel?, _ errorMsg: String?) -> Void){
        
        
        var parameters = [String : Any]()
        parameters = [    "name": name,
                          "sender": sender,
                          "project": project,
                          "receiver": receiver,
                          "reason_for_delay": reasonForDelay,
                          "number_of_days": numberOfDays,
                          "extend_date_from": extendDateFrom,
                          "extend_date_to": extendDateTo,
                    ]
//        parameters = ["name": name, "summary": summary, "sender": sender, "price": price, "total_price": totalPrice, "receiver": receiver,  "file": file, "project":project, "gst": gst]
        
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.addEOT, method: .post,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let decodedData = try JSONDecoder().decode(BaseResponse<AddEOTModel>.self, from: jsonData)
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
    func addEOT(name:String,sender: Int, reasonForDelay: String, project: Int, receiver: [Int], numberOfDays: String, extendDateFrom: String, extendDateTo: String ,completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ type: String?) -> Void){
        
        if(name.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddEOTTitleEmpty, "")
        }
        else if (sender == nil){
            completionHandler(false,FieldValidation.kVariationFromEmpty, "")
        }
        else if (receiver.isEmpty) {
            completionHandler(false,FieldValidation.kVariationToEmpty, "")
        }
        else if (reasonForDelay.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddEOTReasonForDelay,"")
        }
        else if (numberOfDays.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddEOTNumberOfDays, "")
        }
        else if (extendDateFrom.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddEOTExtendedFromDate, "")
        }
        else if (extendDateTo.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddEOTExtendedToDate, "")
        }
        else {
            
            self.createEOT(name: name,sender: sender, reasonForDelay: reasonForDelay, project: project, receiver: receiver, numberOfDays: numberOfDays, extendDateFrom: extendDateFrom, extendDateTo: extendDateTo) { success, response, message in
                if success {
                    completionHandler(true, nil, "")
                } else {
                    completionHandler(false,nil, "An error occured!")
                }
            }
        }
    }
}
