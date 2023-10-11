//
//  DocsListViewModel.swift
//  Comezy
//
//  Created by shiphul on 07/12/21.
//

import UIKit

class DocsListViewModel: NSObject {
    func getDocsList(type: String, size: String, page: Int, project_id: Int, completionHandler: @escaping(_ status: Bool, _ planList: [DocsListModelResult]?, _ errorMsg: String?) -> Void){
      
        DispatchQueue.main.async{
            var url = API.getDocsList
            url = url + "?size=" + "\(1000)" + "&page=" + "\(page)" + "&project_id=" + "\(project_id)" + "&type=" + "\(type)"

            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let DocsList = try JSONDecoder().decode(BaseResponse<DocsListModel>.self, from: jsonData)
                        print("ProjectList  :", DocsList)
                        if DocsList.code == 200 {
                            completionHandler(true, DocsList.data?.results, "")
                                
                        }else {
                            completionHandler(false,nil,DocsList.message ?? "")
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

func deleteDocs(document_id: Int, completionHandler: @escaping(_ success: Bool, _ response: DeleteDocsResponseModel?, _ errorMsg: String?) -> Void){
    
    DispatchQueue.main.async {

        var url = API.deleteDocument
        url = url + "\(document_id)"

        APIManager.shared.request(url: url, method: .delete, parameters:nil ,completionCallback: { (_ ) in

        }, success: { (json) in

            if let json = json {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject:json)
                    print("jsonData  :", jsonData)
                    let resp = try JSONDecoder().decode(DeleteDocsResponseModel.self, from: jsonData)
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
    func putDocs(name:String, description: String ,file: Array<[String:String]>,supplierDetails: String, safetyId: Int ,completionHandler: @escaping(_ status: Bool, _ variationModel: EditSpecificationAndProdModel?, _ errorMsg: String?) -> Void){
        
        var parameters = [String : Any]()
        parameters = [    "name": name,
                          "description": description ,
                          "supplier_details":supplierDetails,
                          "files_list": file
        ]
        
        print(safetyId, "23498723462348972358712304987623098560234985720398470219834702983470982356082376498127340987234590827349087231478")
        var url = API.editDocs
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
                        let response = try JSONDecoder().decode(BaseResponse<EditSpecificationAndProdModel>.self, from: jsonData)
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
    func updateDocs(name:String, description: String ,file: Array<[String:String]>,supplierDetails: String, safetyId: Int,completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ response: EditSpecificationAndProdModel?) -> Void){
        print(safetyId)
    
        if(name.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kROITitleEmpty, nil)
        }
        else if (description.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kROIInfoNeededEmpty,nil)
        } else {
            
            self.putDocs(name:name, description: description ,file: file,supplierDetails: supplierDetails, safetyId: safetyId) { success, response, message in
                if success {
                    completionHandler(true, nil, response)
                } else {
                    completionHandler(false,nil, response)
                }
            }
        }
    }
    

    
}
