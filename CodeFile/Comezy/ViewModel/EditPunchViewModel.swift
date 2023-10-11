//
//  EditPunchViewModel.swift
//  Comezy
//
//  Created by aakarshit on 22/06/22.
//

import Foundation

class EditPunchViewModel: NSObject {
    var ObjEditPunchModel: EditROIModel?
    
    class var shared: EditROIViewModel{
            struct Singlton {
                static let instance = EditROIViewModel()
            }
            return Singlton.instance
        }
    
    func putEditPunch(name:String, description: String ,file: [String], punchId: Int, checklist: [String] ,completionHandler: @escaping(_ status: Bool, _ variationModel: AddPunchModel?, _ errorMsg: String?) -> Void){
        
        var parameters = [String : Any]()
        parameters = [        "name": name,
                              "description": description,
                              "checklist":checklist,
                              "file":file
        ]
        
        var url = API.editPunch
        url = url + "\(punchId)"
//        parameters = ["name": name, "summary": summary, "sender": sender, "price": price, "total_price": totalPrice, "receiver": receiver,  "file": file, "project":project, "gst": gst]
        
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
        
            
            APIManager.shared.request(url: url, method: .put ,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let response = try JSONDecoder().decode(BaseResponse<AddPunchModel>.self, from: jsonData)
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
    func updatePunch(name: String, infoNeeded: String, file: [String], punchId: Int, checklist: [String] ,completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ type: String?) -> Void){
        var isACheckEmpty = false
        for i in checklist {
            if i == "" {
                isACheckEmpty = true
            }
                
        }
        
        if(name.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddPunchTitleEmpty, "")
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
            
            self.putEditPunch(name: name, description: infoNeeded, file: file, punchId: punchId, checklist: checklist) { success, variationModel, message in
                if success {
                    completionHandler(true, nil, "")
                } else {
                    completionHandler(false,nil, "An error occured!")
                }
            }
        }
    }
}
