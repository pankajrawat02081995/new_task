//
//  TooboxTalkDetailViewModel.swift
//  Comezy
//
//  Created by aakarshit on 24/06/22.
//

import Foundation

class ToolBoxTalkDetailViewModel: NSObject {
    
    func getToolBoxDetail(tbId: Int, completionHandler: @escaping(_ status: Bool, _ variationDetailResp: ToolBoxTalkDetailModel?, _ errorMsg: String?) -> Void){
        

        DispatchQueue.main.async {

            var url = API.getToolBoxDetail
            url = url + "\(tbId)"
            print(url)

            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in

            }, success: { (json) in

                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let variationDetailResponse = try JSONDecoder().decode(BaseResponse<ToolBoxTalkDetailModel>.self, from: jsonData)
                        print("ProjectList  :", variationDetailResponse)
                        if variationDetailResponse.code == 200 {
                            completionHandler(true, variationDetailResponse.data as! ToolBoxTalkDetailModel, "")

                        } else {
                            completionHandler(false, nil, variationDetailResponse.message ?? "Error occured while Decoding")
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
    func deleteToolbox(toolbox_id: Int, completionHandler: @escaping(_ status: Bool, _ response: EOTDetailModel?, _ errorMsg: String?) -> Void){
        
        DispatchQueue.main.async {

            var url = API.deleteEOT
            url = url + "\(toolbox_id)"

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
    func getResponse(tbId: Int, accepted: String , completionHandler: @escaping(_ status: Bool, _ response: VariationResponseModel?, _ errorMsg: String?) -> Void){
        
        DispatchQueue.main.async {

            var url = API.getToolBoxResponse
            url = url + "\(accepted)/?" + "toolbox_id=" + "\(tbId)"
            print(url)

            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
 
            }, success: { (json) in

                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let response = try JSONDecoder().decode(VariationResponseModel.self, from: jsonData)
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

