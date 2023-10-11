//
//  AddPlansViewModel.swift
//  Comezy
//
//  Created by shiphul on 07/12/21.
//

import UIKit

class AddPlansViewModel: NSObject {
    var objPlanResult:AddPlanModel?
    
    
    class var shared:AddPlansViewModel{
            struct Singlton{
                static let instance = AddPlansViewModel()
            }
            return Singlton.instance
        }
    
    func getAddPlans(controller: UIViewController,name:String, description:String,file: [String], project: Int, completionHandler: @escaping(_ status: Bool, _ addPlanList: AddPlanModel?, _ errorMsg: String?) -> Void){
      
        var parameters = [String : Any]()
        parameters = ["name": name, "description": description,  "file": file, "project": project]
      
        print("parameters <!@#$!@#$@#$%^^&$&*%^&*%^#$@%$>", parameters)
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.addPlan, method: .post,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let addPlanData = try JSONDecoder().decode(BaseResponse<AddPlanModel>.self, from: jsonData)
                        print(addPlanData)
                        print(addPlanData.code, "!@#$!@#$@#$%^#    ADD   PLAN   $%$%^$%^##$%")
                        if addPlanData.code == 200 {
                            completionHandler(true, addPlanData.data!, "")
                        } else {
                            
                            completionHandler(false, nil ,addPlanData.message ?? "")
                        }
                        
                    }
                    
                    catch let err{
                        
                        print("!@#$!@#$@#$%^#    FAILED  $%$%^$%^##$%", err)
                        completionHandler(false,nil,err.localizedDescription ?? "")
                        
                    }
                }
            }) { (error) in
                print("json error", error)
                completionHandler(false,nil,error)
            }
            
        }
        
    }
    
    func
    addPlan(controller:UIViewController, name: String, description: String, file: [String], project: Int, completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ type: String?) -> Void){
        if(name.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kPlanNameEmpty, "")
        }else if (description.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kDescriptionEmpty, "")
        } else {
            self.getAddPlans(controller: controller, name: name, description: description , file: file, project: project) { (success, planModel, message) in
                if success {
                    completionHandler(true, nil, "")
                } else {
                    completionHandler(false,nil, "Couldn't add plan, please try again later")
                }
            }
        }
    }
}

