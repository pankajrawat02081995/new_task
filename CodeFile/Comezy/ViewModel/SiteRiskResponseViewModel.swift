//
//  SiteRiskResponseViewModel.swift
//  Comezy
//
//  Created by aakarshit on 12/07/22.
//

import Foundation
import Alamofire

class SiteRiskResponseViewModel: NSObject {
    func putSiteRiskResponse(siteRiskId: Int, response: String, createdById: Int, assignedToId: Int, projectId: Int, questionId: Int,upload_file:String, completionHandler: @escaping(_ status: Bool, _ variationDetailResp: SiteRiskResponseModel?, _ errorMsg: String?) -> Void){
        
        let values: [String: Any] = [        "id": siteRiskId,
                                                "response": response,
                                                "created_by": createdById,
                                                "project": projectId,
                                                "question": questionId ,
                                                "assigned_to": assignedToId,
                                             "upload_file": upload_file]
        print(values)
         
        let url = URL(string: API.devURL + API.siteRiskResponse)
        print(url)
  
        if let safeUrl = url, let safeToken = kUserData?.jwt_token {
            print("URL ->",safeUrl)
            print("Token ->",safeToken)
            var request = URLRequest(url: safeUrl)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("jwt \(safeToken)", forHTTPHeaderField: "Authorization")
            
        
            print(values)
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: values, options: [])
            print("httpBody ->", request.httpBody.jsonObject)
            
            AF.request(request)
                .responseJSON { response in
                    switch response.result {
                    case .success(let responseObject):
                        
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject:responseObject)
                                print("jsonData  :", jsonData)
                                let result = try JSONDecoder().decode(BaseResponse<SiteRiskResponseModel>.self, from: jsonData)
                                print("ProjectList  :", result)
                                if result.code == 200 {
                                    completionHandler(true, result.data, "")

                                } else {
                                    completionHandler(false, nil, result.message ?? "Error occured while Decoding")
                                }

                            }
                            catch let err{
                                print("ProjectList  err.localizedDescription:", err.localizedDescription)
                                completionHandler(false,nil,err.localizedDescription)
                            }

                        print(responseObject)
                    case .failure(let error):
                        
                        print("ProjectList  error:", error)
                        completionHandler(false,nil,error.localizedDescription)
                        print(error)
                    }
            }
        }
    }
}
