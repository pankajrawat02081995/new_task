//
//  DeleteVariationViewModel.swift
//  Comezy
//
//  Created by aakarshit on 08/06/22.
//

import Foundation

class DeleteVariationViewModel: NSObject {
    func deleteVariation(variation_id: Int, completionHandler: @escaping(_ status: Bool, _ variationDetailResp: VariationResponseModel?, _ errorMsg: String?) -> Void){
        
        DispatchQueue.main.async {

            var url = API.deleteVariation
            url = url + "\(variation_id)"

            APIManager.shared.request(url: url, method: .delete, parameters:nil ,completionCallback: { (_ ) in
 
            }, success: { (json) in

                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let variationResponseData = try JSONDecoder().decode(VariationResponseModel.self, from: jsonData)
                        print("ProjectList  :", variationResponseData)
                        if variationResponseData.code == 200 {
                            completionHandler(true, nil , "")

                        } else {
                            completionHandler(false, nil, variationResponseData.message ?? "Error occured while Decoding")
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
