//
//  SafetyViewModel.swift
//  Comezy
//
//  Created by aakarshit on 27/06/22.
//

import Foundation

class SafetyListViewModel: NSObject {
    
    static let shared = SafetyListViewModel()
    
    func getList(size: String, page: Int, project_id: Int, type: String, completionHandler: @escaping(_ success: Bool, _ resp: SafetyListModel?, _ errorMsg: String?) -> Void){
      
        DispatchQueue.main.async{
            var url = API.getSafetyList
            url = url + "size=" + size + "&page=" + "\(page)" + "&project_id=" + "\(project_id)" + "&type=" + "\(type)"
            print(url)
            

            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let result = try JSONDecoder().decode(BaseResponse<SafetyListModel>.self, from: jsonData)
                        print("ProjectList  :", result)
                        if result.code == 200 {
                            completionHandler(true, result.data, "")
                            
                        }else {
                            completionHandler(false, nil, result.message ?? "Error occured while Decoding")
                        }
                        
                    }
                    catch let err{
                        print("ProjectList  err.localizedDescription:", err.localizedDescription)
                        completionHandler(false,nil,err.localizedDescription)
                    }
                }
            }) { (error) in
                print("ProjectList  error:", error)
                completionHandler(false,nil,error)
                
            }
        }
    }
    
    func deleteSafety(safetyId: Int, completionHandler: @escaping(_ success: Bool, _ response: PunchDetailModel?, _ errorMsg: String?) -> Void){
        
        DispatchQueue.main.async {

            var url = API.deleteSafety
            url = url + "\(safetyId)"

            APIManager.shared.request(url: url, method: .delete, parameters:nil ,completionCallback: { (_ ) in
 
            }, success: { (json) in

                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let resp = try JSONDecoder().decode(VariationResponseModel.self, from: jsonData)
                        print("ProjectList  :", resp)
                        if resp.code == 200 {
                            completionHandler(true, nil , "")

                        } else {
                            completionHandler(false, nil, resp.message ?? "Error occured while Decoding")
                        }

                    }
                    catch let err {
                        print("ProjectList  err.localizedDescription:", err.localizedDescription)
                        completionHandler(false,nil,err.localizedDescription)
                    }
                }
            }) { (error) in
                print("ProjectList  error:", error)
                completionHandler(false,nil,error)

            }
        }
    }
    
    func createSafety(name:String, description: String, file: [String], project: Int, type: String ,completionHandler: @escaping(_ status: Bool, _ variationModel: AddSafetyModel?, _ errorMsg: String?) -> Void){
        
        
        var parameters = [String : Any]()
        parameters = [    "name": name,
                          "type": type,
                          "project": project,
                          "description": description,
                          "file": file,
                    ]
//        parameters = ["name": name, "summary": summary, "sender": sender, "price": price, "total_price": totalPrice, "receiver": receiver,  "file": file, "project":project, "gst": gst]
        
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.addSafety, method: .post,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let decodedData = try JSONDecoder().decode(BaseResponse<AddSafetyModel>.self, from: jsonData)
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
    
    func addSafety(name:String, description: String, file: [String], project: Int, type: String ,completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ type: String?) -> Void){
        if(name.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kVariationTitleEmpty, "")
        }
        else if (description.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kSafetyDesctipn,"")
        }
        else {
            
            self.createSafety(name: name, description: description, file: file, project: project, type: type ) { success, response, message in
                if success {
                    completionHandler(true, nil, "")
                } else {
                    completionHandler(false,nil, "An error occured!")
                }
            }
        }
    }
    
    
    func putSafety(name:String, description: String ,file: [String], safetyId: Int ,completionHandler: @escaping(_ status: Bool, _ variationModel: AddSafetyModel?, _ errorMsg: String?) -> Void){
        
        var parameters = [String : Any]()
        parameters = [    "name": name,
                          "description": description ,
                          "file": file
        ]
        
        print(safetyId, "23498723462348972358712304987623098560234985720398470219834702983470982356082376498127340987234590827349087231478")
        var url = API.editSafety
        url = url + "\(safetyId)"
//        parameters = ["name": name, "summary": summary, "sender": sender, "price": price, "total_price": totalPrice, "receiver": receiver,  "file": file, "project":project, "gst": gst]
        
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
        
            
            APIManager.shared.request(url: url, method: .put ,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let response = try JSONDecoder().decode(BaseResponse<AddSafetyModel>.self, from: jsonData)
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
    func updateSafety(name:String, description: String ,file: [String], safetyId: Int,completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ response: AddSafetyModel?) -> Void){
        print(safetyId)
    
        if(name.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kROITitleEmpty, nil)
        }
        else if (description.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kROIInfoNeededEmpty,nil)
        } else {
            
            self.putSafety(name:name, description: description ,file: file, safetyId: safetyId) { success, response, message in
                if success {
                    completionHandler(true, nil, response)
                } else {
                    completionHandler(false,nil, response)
                }
            }
        }
    }
    
    
    
}
