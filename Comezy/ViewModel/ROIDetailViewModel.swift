//
//  ROIDetailViewModel.swift
//  Comezy
//
//  Created by aakarshit on 09/06/22.
//

import Foundation

class ROIDetailViewModel: NSObject {
    func getROIDetail(roi_id: Int, completionHandler: @escaping(_ status: Bool, _ variationDetailResp: ROIDetailModel?, _ errorMsg: String?) -> Void){
        

        DispatchQueue.main.async {

            var url = API.getROIDetail
            url = url + "\(roi_id)"
            print(url)

            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in

            }, success: { (json) in

                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let response = try JSONDecoder().decode(BaseResponse<ROIDetailModel>.self, from: jsonData)
                        print("ProjectList  :", response)
                        if response.code == 200 {
                            completionHandler(true, response.data as! ROIDetailModel, "")

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
    
    func deleteROI(roi_id: Int, completionHandler: @escaping(_ status: Bool, _ variationDetailResp: VariationResponseModel?, _ errorMsg: String?) -> Void){
        
        DispatchQueue.main.async {

            var url = API.deleteROI
            url = url + "\(roi_id)"

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
