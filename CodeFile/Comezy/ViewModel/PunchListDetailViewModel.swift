//
//  PunchListDetailViewModel.swift
//  Comezy
//
//  Created by aakarshit on 17/06/22.
//

import Foundation

class PunchListDetailViewModel: NSObject {
    
    func getPunchDetail(punch_id: Int, completionHandler: @escaping(_ status: Bool, _ detailResp: PunchDetailModel?, _ errorMsg: String?) -> Void){
        

        DispatchQueue.main.async {

            var url = API.getPunchDetail
            url = url + "\(punch_id)"
            print(url)

            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in

            }, success: { (json) in

                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let response = try JSONDecoder().decode(BaseResponse<PunchDetailModel>.self, from: jsonData)
                        print("ProjectList  :", response)
                        if response.code == 200 {
                            completionHandler(true, response.data as! PunchDetailModel, "")
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
    
    func markCompletion(punch_id: Int, completion: String, completionHandler: @escaping(_ status: Bool, _ detailResp: EmptyData?, _ errorMsg: String?) -> Void) {
        DispatchQueue.main.async {

            var url = API.markCompletion
            url = url + "\(completion)/?checklist_id=\(punch_id)"
            print(url)

            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in

            }, success: { (json) in

                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let response = try JSONDecoder().decode(BaseResponse<EmptyData>.self, from: jsonData)
                        print("ProjectList  :", response)
                        if response.code == 200 {
                            completionHandler(true, response.data as! EmptyData, "")

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
    
    func deletePunch(punchId: Int, completionHandler: @escaping(_ status: Bool, _ response: PunchDetailModel?, _ errorMsg: String?) -> Void){
        
        DispatchQueue.main.async {

            var url = API.deletePunch
            url = url + "\(punchId)"

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
}
