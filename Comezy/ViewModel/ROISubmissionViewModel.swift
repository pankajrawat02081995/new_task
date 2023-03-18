//
//  ROISubmissionViewModel.swift
//  Comezy
//
//  Created by aakarshit on 16/06/22.
//

import Foundation

class ROISubmissionViewModel: NSObject {
    func submitROIResponse(variation_id: Int, comment: String, completionHandler: @escaping(_ status: Bool, _ variationDetailResp: VariationResponseModel?, _ errorMsg: String?) -> Void){
        
        DispatchQueue.main.async {

            var url = API.submitROI
            url = url + "\(variation_id)"
            print(url)
            
            let parameters = [
                       "info_response": comment
                ]

            APIManager.shared.request(url: url, method: .put, parameters: parameters ,completionCallback: { (_ ) in
 
            }, success: { (json) in

                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let response = try JSONDecoder().decode(SubmitROIModel.self, from: jsonData)
                        print("ProjectList  :", response)
                        if response.code == 200 {
                            completionHandler(true, nil , "")

                        } else {
                            completionHandler(false, nil, response.message ?? "Error occured while Decoding")
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
