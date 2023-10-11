//
//  EditVariationsViewModel.swift
//  Comezy
//
//  Created by aakarshit on 07/06/22.
//

import Foundation

class EditVariationsViewModel: NSObject {
    func updateVariation(name:String, price:String, totalPrice: String, summary: String ,file: [String], gst: Bool, variationId: Int, completionHandler: @escaping(_ status: Bool, _ addPlanList: EditVariationModel?, _ errorMsg: String?) -> Void){
      
        var parameters = [String : Any]()
        
        parameters = [
            
            "name": name,

            "file":file,

            "gst": gst,

            "price": price,

            "total_price": totalPrice ,

            "summary": summary

            ]
        print("parameters <!@#$!@#$@#$%^^&$&*%^&*%^#$@%$>", parameters)
        DispatchQueue.main.async{
            
            let url = API.updateVariation + "\(variationId)"
            
            APIManager.shared.request(url: url, method: .put, parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let editVariationResponse = try JSONDecoder().decode(BaseResponse<EditVariationModel>.self, from: jsonData)
                        print(editVariationResponse)
                        print(editVariationResponse.code, "!@#$!@#$@#$%^#    ADD   PLAN   $%$%^$%^##$%")
                        if editVariationResponse.code == 200 {
                            completionHandler(true, editVariationResponse.data , "")
                        } else {
                            
                            completionHandler(false, nil ,editVariationResponse.message ?? "")
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
}
