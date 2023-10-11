//
//  InductionQuestionsViewModel.swift
//  Comezy
//
//  Created by aakarshit on 29/07/22.
//

import Foundation
import Alamofire

class InductionQuestionsViewModel: NSObject {
    func getInductionQuestions(completionHandler: @escaping(_ success: Bool, _ resp: InductionQuestionModel?, _ errorMsg: String?) -> Void){
        var parameters = [String : Any]()
            APIManager.shared.requestWithoutHeaders(url: API.getInductionQuestions, method: .get,parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let response = try JSONDecoder().decode(BaseResponse<InductionQuestionModel>.self, from: jsonData)
                        if response.code == 200 {
                           
                            completionHandler(true, response.data, "")
                        }else {
                            completionHandler(false,nil,response.message ?? "")
                        }
                        
                    }
                    catch let err{
                        
                        completionHandler(false,nil,err.localizedDescription)
                    }
                }
            }) { (error) in
                completionHandler(false,nil,error)
                
            }
    }
    
    func sendInductionResponse(jwt: String, response: [[String: Any]], completionHandler: @escaping(_ success: Bool, _ resp: InductionResponseModel?, _ errorMsg: String?) -> Void){
        
        let values: [[String: Any]] = response
         
        let url = URL(string: API.devURL + API.sendInductionResponse)
        print(url)
    
        if let safeUrl = url {
            print("URL ->",safeUrl)
//            print("Token ->",safeToken)
            var request = URLRequest(url: safeUrl)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("jwt \(jwt)", forHTTPHeaderField: "Authorization")
            
        
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
                                let result = try JSONDecoder().decode(BaseResponse<InductionResponseModel>.self, from: jsonData)
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
    func getCompletedInductionResponse(userId:Int,completionHandler: @escaping(_ success: Bool, _ resp: InductionAnswerResponseModel?, _ errorMsg: String?) -> Void){
        var url = API.getInductionResponse+"size=1000"+" "+"&page="+"\(1)"+"&user_id="+"\(userId)"

            APIManager.shared.request(url: url, method: .get,parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let response = try JSONDecoder().decode(BaseResponse<InductionAnswerResponseModel>.self, from: jsonData)
                        if response.code == 200 {
                           
                            completionHandler(true, response.data, "")
                        }else {
                            completionHandler(false,nil,response.message ?? "")
                        }
                        
                    }
                    catch let err{
                        
                        completionHandler(false,nil,err.localizedDescription)
                    }
                }
            }) { (error) in
                completionHandler(false,nil,error)
                
            }
    }
    
    
}
