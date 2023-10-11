//
//  AddVariationsViewModel.swift
//  Comezy
//
//  Created by aakarshit on 20/05/22.
//

import UIKit

class AddVariationsViewModel: NSObject {
    var objVariationsResult: AddVariationsModel?
    
    class var shared: AddVariationsViewModel{
            struct Singlton {
                static let instance = AddVariationsViewModel()
            }
            return Singlton.instance
        }
    
    func CreateVariation(controller: UIViewController,name:String,sender: Int, summary: String, gst: String, price: String, totalPrice: String ,file: [String],project: Int, receiver: [Int],completionHandler: @escaping(_ status: Bool, _ variationModel: AddVariationsModel?, _ errorMsg: String?) -> Void){
        
        var parameters = [String : Any]()
        parameters = ["name": name,
        "sender": sender,
        "project": project,
        "summary": summary,
        "gst": gst,
        "price": price,
        "total_price": totalPrice,
        "file": file,
        "receiver": receiver]
        
//        parameters = ["name": name, "summary": summary, "sender": sender, "price": price, "total_price": totalPrice, "receiver": receiver,  "file": file, "project":project, "gst": gst]
        
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.addVariations, method: .post,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let addVariationsData = try JSONDecoder().decode(BaseResponse<AddVariationsModel>.self, from: jsonData)
                        print(addVariationsData)
                        if addVariationsData.code == 200 {
                            completionHandler(true, addVariationsData.data!, "")
                        } else {
                            completionHandler(false, nil ,addVariationsData.message ?? "")
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
    func addVariation(controller:UIViewController, name: String,sender: Int?, summary: String, gst: String, price: String, totalPrice: String, file: [String], project: Int, receiver: [Int]  ,completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ type: String?) -> Void){
        
    
        if(name.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kVariationTitleEmpty, "")
        }
        else if (sender == nil){
            completionHandler(false,FieldValidation.kVariationFromEmpty, "")
        }
        else if (receiver.isEmpty) {
            completionHandler(false,FieldValidation.kVariationToEmpty, "")
        }
        else if (summary.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kVariationSummaryEmpty,"")
        }
        else if (price.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kVariationPriceEmpty, "")
        }
       
      
        else {
            
            self.CreateVariation(controller: controller, name: name, sender: sender!, summary: summary, gst: gst, price: price, totalPrice: totalPrice, file: file, project: project, receiver: receiver) { success, variationModel, message in
                if success {
                    
                    completionHandler(true, nil, "")
                } else {
                    completionHandler(false,nil, "An error occured!")
                }
            }
        }
    }
}
