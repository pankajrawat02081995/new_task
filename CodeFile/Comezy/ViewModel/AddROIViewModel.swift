//
//  AddROIViewModel.swift
//  Comezy
//
//  Created by aakarshit on 10/06/22.
//

import Foundation
//
//  AddVariationsViewModel.swift
//  Comezy
//
//  Created by aakarshit on 20/05/22.
//

import UIKit

class AddROIViewModel: NSObject {
    var objVariationsResult: AddROIViewModel?
    
    class var shared: AddROIViewModel{
            struct Singlton {
                static let instance = AddROIViewModel()
            }
            return Singlton.instance
        }
    
    func createROI( controller: UIViewController,name:String,sender: Int, infoNeeded: String, file: [String],project: Int, receiver: [Int],completionHandler: @escaping(_ status: Bool, _ variationModel: AddROIModel?, _ errorMsg: String?) -> Void){
        
        
        var parameters = [String : Any]()
        parameters = [    "name": name,
                          "sender": sender,
                          "project": project,
                          "info_needed": infoNeeded,
                          "file": file,
                          "receiver": receiver
                    ]
//        parameters = ["name": name, "summary": summary, "sender": sender, "price": price, "total_price": totalPrice, "receiver": receiver,  "file": file, "project":project, "gst": gst]
        
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.addROI, method: .post,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let decodedData = try JSONDecoder().decode(BaseResponse<AddROIModel>.self, from: jsonData)
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
    func addROI(controller:UIViewController, name: String,sender: Int?, infoNeeded: String, file: [String], project: Int, receiver: [Int] ,completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ type: String?) -> Void){
        if(name.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kVariationTitleEmpty, "")
        }
        else if (sender == nil){
            completionHandler(false,FieldValidation.kVariationFromEmpty, "")
        }
        else if (receiver.isEmpty) {
            completionHandler(false,FieldValidation.kVariationToEmpty, "")
        }
        else if (infoNeeded.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kVariationSummaryEmpty,"")
        }
        else {
            
            self.createROI(controller: controller, name: name, sender: sender!, infoNeeded: infoNeeded, file: file, project: project, receiver: receiver) { success, response, message in
                if success {
                    completionHandler(true, nil, "")
                } else {
                    completionHandler(false,nil, "An error occured!")
                }
            }
        }
    }
}
