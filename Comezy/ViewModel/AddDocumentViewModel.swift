//
//  AddDocumentViewModel.swift
//  Comezy
//
//  Created by shiphul on 10/12/21.
//

import UIKit

class AddDocumentViewModel: NSObject {
    var objDocumentResult:CreateDocumentModel?
    
    class var shared:AddDocumentViewModel{
            struct Singlton{
                static let instance = AddDocumentViewModel()
            }
            return Singlton.instance
        }
    
    func CreateDocument(controller: UIViewController, specificationRequest:AddSpecificationRequest ,completionHandler: @escaping(_ status: Bool, _ addPlanList: CreateDocumentModel?, _ errorMsg: String?) -> Void){
        
        var parameters = [String : Any]()
        parameters = ["name": specificationRequest.name, "description": specificationRequest.welcomeDescription, "files_list": specificationRequest.filesList, "type": specificationRequest.type,"supplier_details":specificationRequest.supplierDetail , "project":specificationRequest.project]
        
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.addDocs, method: .post,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let addDocsData = try JSONDecoder().decode(BaseResponse<CreateDocumentModel>.self, from: jsonData)
                        print(addDocsData)
                        if addDocsData.code == 200 {
                            completionHandler(true, addDocsData.data!, "")
                        } else {
                            completionHandler(false, nil ,addDocsData.message ?? "")
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
    func addDocs(controller:UIViewController, name: String, supplierDetail:String,description: String, file_list: Array<[String:String]>, type: String, project: Int ,completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ type: String?) -> Void){
        if(name.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kDocNameEmpty, "")
        } else if (description.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kDocDescriptionEmpty, "")

        }else if (supplierDetail.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kDocSupplierEmpty, "")
        }
        else {
            self.CreateDocument(controller: controller, specificationRequest: AddSpecificationRequest(project: project, welcomeDescription: description, name: name, filesList: file_list, type: type, supplierDetail: supplierDetail)) { (success, docsModel, message) in
                if success {
                    completionHandler(true, nil, "")
                } else {
                    completionHandler(false,nil, "An error occured!")
                }
            }
        }
    }
    }



