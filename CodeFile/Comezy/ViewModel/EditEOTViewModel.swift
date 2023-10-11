//
//  EditEOTViewModel.swift
//  Comezy
//
//  Created by aakarshit on 24/06/22.
//

import Foundation

class EditEOTViewModel: NSObject {

    
    func putEditEOT(name:String, reasonForDelay: String , eotId: Int ,numberOfDays: String, extendDateFrom: String, extendDateTo: String, completionHandler: @escaping(_ status: Bool, _ variationModel: EditEOTModel?, _ errorMsg: String?) -> Void){
        
        var parameters = [String : Any]()
        parameters = [
            "name": name,
            "reason_for_delay": reasonForDelay,
            "number_of_days": numberOfDays,
            "extend_date_from": extendDateFrom,
            "extend_date_to": extendDateTo
        ]
        
        var url = API.editEOT
        url = url + "\(eotId)"
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
        
            
            APIManager.shared.request(url: url, method: .put ,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let response = try JSONDecoder().decode(BaseResponse<EditEOTModel>.self, from: jsonData)
                        print(response)
                        if response.code == 200 {
                            completionHandler(true, response.data!, "")
                        } else {
                            completionHandler(false, nil , response.message ?? "")
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
    func updateEOT(name:String, reasonForDelay: String , eotId: Int ,numberOfDays: String, extendDateFrom: String, extendDateTo: String,completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ type: String?) -> Void){
    
        if(name.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddEOTTitleEmpty, "")
        }
        else if (reasonForDelay.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddEOTReasonForDelay,"")
        }
        else if (numberOfDays.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddEOTNumberOfDays,"")
        }
        else if (extendDateFrom.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddEOTExtendedFromDate,"")
        }
        else if (extendDateTo.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddEOTExtendedToDate,"")
        }
        else {
            
            self.putEditEOT(name: name, reasonForDelay: reasonForDelay, eotId: eotId, numberOfDays: numberOfDays, extendDateFrom: extendDateFrom, extendDateTo: extendDateTo) { success, model, message in
                if success {
                    completionHandler(true, nil, "")
                } else {
                    completionHandler(false,nil, "An error occured!")
                }
            }
        }
    }
}
