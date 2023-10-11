//
//  PlansListViewModel.swift
//  Comezy
//
//  Created by shiphul on 03/12/21.
//

import UIKit

class PlansListViewModel: NSObject {
    var planListDataDetail : PlansResult?
    
    func getPlansList(size: Int, page: Int, project_id: Int, completionHandler: @escaping(_ status: Bool, _ planList: [PlansResult]?, _ errorMsg: String?) -> Void){
        
        DispatchQueue.main.async{

            var url = API.getPlansList
            url = url + "?size=" + "\(size)" + "&page=" + "\(page)" + "&project_id=" + "\(project_id)"
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let PlansList = try JSONDecoder().decode(BaseResponse<PlansListModel>.self, from: jsonData)
                        print("ProjectList  :", PlansList)
                        if PlansList.code == 200 {
                          
                            completionHandler(true, PlansList.data?.results, "")
                            
                        }else {
                            completionHandler(false,nil,PlansList.message ?? "")
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
    
    func putPlan(name:String, description: String ,file: [String], planId: Int ,completionHandler: @escaping(_ status: Bool, _ variationModel: AddPlanModel?, _ errorMsg: String?) -> Void){
        
        var parameters = [String : Any]()
        parameters = [    "name": name,
                          "description": description ,
                          "file": file
        ]
        
        print(planId, "23498723462348972358712304987623098560234985720398470219834702983470982356082376498127340987234590827349087231478")
        var url = API.editPlan
        url = url + "\(planId)"
//        parameters = ["name": name, "summary": summary, "sender": sender, "price": price, "total_price": totalPrice, "receiver": receiver,  "file": file, "project":project, "gst": gst]
        
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
        
            
            APIManager.shared.request(url: url, method: .put ,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let response = try JSONDecoder().decode(BaseResponse<AddPlanModel>.self, from: jsonData)
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
    func updatePlan(name:String, description: String ,file: [String], planId: Int,completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ response: AddPlanModel?) -> Void){
        print(planId)
    
        if(name.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kROITitleEmpty, nil)
        }
        else if (description.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kROIInfoNeededEmpty,nil)
        } else {
            
            self.putPlan(name:name, description: description ,file: file, planId: planId) { success, response, message in
                if success {
                    completionHandler(true, nil, response)
                } else {
                    completionHandler(false,nil, response)
                }
            }
        }
    }
    func deletePlan(planId: Int, completionHandler: @escaping(_ success: Bool, _ response: PunchDetailModel?, _ errorMsg: String?) -> Void){
        
        DispatchQueue.main.async {

            var url = API.deletePlan
            url = url + "\(planId)"

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
    
}
