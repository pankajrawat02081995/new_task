//
//  EditROIViewModel.swift
//  Comezy
//
//  Created by aakarshit on 10/06/22.
//

import Foundation

class EditROIViewModel: NSObject {
    var objVariationsResult: EditROIModel?
    
    class var shared: EditROIViewModel{
            struct Singlton {
                static let instance = EditROIViewModel()
            }
            return Singlton.instance
        }
    
    func putEditROI(name:String, infoNeeded: String ,file: [String], roiID: Int ,completionHandler: @escaping(_ status: Bool, _ variationModel: EditROIModel?, _ errorMsg: String?) -> Void){
        
        var parameters = [String : Any]()
        parameters = [    "name": name,
                          "info_needed": infoNeeded ,
                          "file": file
        ]
        
        print(roiID, "23498723462348972358712304987623098560234985720398470219834702983470982356082376498127340987234590827349087231478")
        var url = API.editROI
        url = url + "\(roiID)"
//        parameters = ["name": name, "summary": summary, "sender": sender, "price": price, "total_price": totalPrice, "receiver": receiver,  "file": file, "project":project, "gst": gst]
        
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
        
            
            APIManager.shared.request(url: url, method: .put ,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let response = try JSONDecoder().decode(BaseResponse<EditROIModel>.self, from: jsonData)
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
    func updateROI(name: String, infoNeeded: String, file: [String], roiId: Int ,completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ type: String?) -> Void){
        print(roiId)
    
        if(name.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kROITitleEmpty, "")
        }
        else if (infoNeeded.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kROIInfoNeededEmpty,"")
        } else {
            
            self.putEditROI(name: name, infoNeeded: infoNeeded, file: file, roiID: roiId) { success, variationModel, message in
                if success {
                    completionHandler(true, nil, "")
                } else {
                    completionHandler(false,nil, "An error occured!")
                }
            }
        }
    }
}
