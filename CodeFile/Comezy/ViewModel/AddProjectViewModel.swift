//
//  AddProjectViewModel.swift
//  Comezy
//
//  Created by shiphul on 19/11/21.
//

import UIKit

class AddProjectViewModel: NSObject {
    
    var clientName:String? = ""
    var objCResult:CResult?
    
    var clientDataDetail:ClientData?
    var clientResultList:[CResult] = []
    var addProjectDataDetail:AddProjectModel?

    
    
    class var shared:AddProjectViewModel{
            struct Singlton{
                static let instance = AddProjectViewModel()
            }
            return Singlton.instance
        }
    
    
    
    //Api For ClientList
    func getClientList(size: Int, page:Int,searchParam:String, completionHandler: @escaping(_ status: Bool) -> Void){
       
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.clientListApi + "&size=" + "\(size)" + "&page=" + "\(page)" + "\(searchParam)", method: .get, parameters: nil ,completionCallback: { (_ ) in
            }, success: { [self] (json) in
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let ClientList = try JSONDecoder().decode(BaseResponse<ClientData?>.self, from: jsonData)
                        if ClientList.code == 200 {
                            clientDataDetail = (ClientList.data!!)
                            clientResultList = clientDataDetail?.results ?? []
                            print(clientDataDetail?.results ?? [])
                            completionHandler(true)
                        }else {
                            completionHandler(false)
                        }
                    }
                    catch let err{
                        completionHandler(false)
                    }
                }
            }) { (error) in
                completionHandler(false)
            }
        }
    }
    
    //Api for Add Project
    func getAddProject(controller: UIViewController,name:String,address:String,longitude:Double,latitude:Double, clientId: Int ,add_project_detail: String, quotation_presentation_pdf: [String], scope_of_work: [String], completionHandler: @escaping(_ status: Bool, _ addProjectList: AddProjectModel?, _ errorMsg: String?) -> Void){
        
        var parameters = [String : Any]()
        var location = [String : Any]()
        location = ["name" : address, "longitude" : longitude, "latitude" : latitude]
        parameters = ["name": name, "address": location,"client": clientId, "description": add_project_detail, "quotations" : quotation_presentation_pdf, "scope_of_work": scope_of_work]
      
        print("parameters", parameters)
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.addProjectApi, method: .post,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let addProjectData = try JSONDecoder().decode(BaseResponse<AddProjectModel>.self, from: jsonData)
                        print(addProjectData)
                        if addProjectData.code == 200 {
                            completionHandler(true, addProjectData.data!, "")
                        } else {
                            completionHandler(false, nil ,addProjectData.message ?? "")
                        }
                        
                    }
                    catch let err{
                        completionHandler(false,nil,err.localizedDescription ?? "")
                    }
                }
            }) { (error) in
                print("json error", error)
                completionHandler(false,nil,error)
            }
            
        }
        
    }
   

    
    
    func addProject(controller:UIViewController, name: String, address: String,longitude:Double,latitude:Double ,client: Int, add_project_detail: String, quotation_presentation_pdf: [String], scope_of_work: [String], completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ type: String?, _ project:AddProjectModel?) -> Void){
        if(name.trimmingCharacters(in: .whitespaces).isEmpty){
            
            completionHandler(false,FieldValidation.kNameEmpty, "", nil)
        }else if (address.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kAddressEmpty, "", nil)
        }else if (client == nil){
            completionHandler(false,FieldValidation.kClient, "", nil)
        }else if (add_project_detail.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kProjectDetailEmpty, "", nil)
        }else if (address.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kLastNameEmpty, "", nil)
        }else{
            self.getAddProject(controller: controller, name: name, address: address, longitude: longitude, latitude:latitude ,clientId: client, add_project_detail: add_project_detail, quotation_presentation_pdf: quotation_presentation_pdf, scope_of_work: scope_of_work) { (success, addProjectList, message) in
                if success {
                    completionHandler(true, nil, "", addProjectList)
                }else {
                    completionHandler(false,nil, "", nil)
                }
            }
        }
    }
}


extension AddProjectViewModel{
    var clientListCount:Int{
        return clientResultList.count
    }
    subscript (atClientList index:Int)->CResult{
            self.clientResultList[index]
        }
}
