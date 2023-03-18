//
//  EOTDetailViewModel.swift
//  Comezy
//
//  Created by aakarshit on 22/06/22.
//

import Foundation

class EOTDetailViewModel: NSObject {
    func getDetail(eotId: Int, completionHandler: @escaping(_ status: Bool, _ variationDetailResp: EOTDetailModel?, _ errorMsg: String?) -> Void){
        

        DispatchQueue.main.async {

            var url = API.getEOTDetail
            url = url + "\(eotId)"
            print(url)

            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in

            }, success: { (json) in

                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let response = try JSONDecoder().decode(BaseResponse<EOTDetailModel>.self, from: jsonData)
                        print("ProjectList  :", response)
                        if response.code == 200 {
                            completionHandler(true, response.data as! EOTDetailModel, "")

                        } else {
                            completionHandler(false, nil, response.message ?? "Error occured while Decoding")
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
    func deleteEot(eotId: Int, completionHandler: @escaping(_ status: Bool, _ response: EOTDetailModel?, _ errorMsg: String?) -> Void){
        
        DispatchQueue.main.async {

            var url = API.deleteEOT
            url = url + "\(eotId)"

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
    
    func submitEOTResponse(eotId: Int, imageURL: String, completionHandler: @escaping(_ status: Bool, _ variationDetailResp: EOTSubmitResponseModel?, _ errorMsg: String?) -> Void){
        
        DispatchQueue.main.async {

            var url = API.submitEOT
            url = url + "\(eotId)"
            print(url)
            
            let parameters = [
                       "signature": imageURL
                ]

            APIManager.shared.request(url: url, method: .put, parameters: parameters ,completionCallback: { (_ ) in
 
            }, success: { (json) in

                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let response = try JSONDecoder().decode(BaseResponse<EOTSubmitResponseModel>.self, from: jsonData)
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
