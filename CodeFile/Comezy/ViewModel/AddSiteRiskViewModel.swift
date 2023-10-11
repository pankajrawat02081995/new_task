//
//  AddSiteRiskViewModel.swift
//  Comezy
//
//  Created by aakarshit on 06/07/22.
//

import Foundation
import Alamofire

class AddSiteRiskViewModel: NSObject {
    static let shared = AddSiteRiskViewModel()
    
    func getList(size: String, page: Int, project_id: Int, completionHandler: @escaping(_ success: Bool, _ resp: SiteQuestionListModel?, _ errorMsg: String?) -> Void){
      
        DispatchQueue.main.async{
            var url = API.getAddSiteRiskQuestions
            url = url + "size=" + size + "&page=" + "\(page)" + "&project_id=" + "\(project_id)"
            print(url)
            
            
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let result = try JSONDecoder().decode(BaseResponse<SiteQuestionListModel>.self, from: jsonData)
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
                }
            }) { (error) in
                print("ProjectList  error:", error)
                completionHandler(false,nil,error)
                
            }
        }
    }
    
    func createSiteRisk(dict: [[String: Any]],completionHandler: @escaping(_ status: Bool, _ variationModel: AddSiteRiskModel?, _ errorMsg: String?) -> Void){

        
        let url = URL(string: API.devURL + API.addSiteRiskAssessment)
        print(url)
  
        if let safeUrl = url, let safeToken = kUserData?.jwt_token {
            print("URL ->",safeUrl)
            print("Token ->",safeToken)
            var request = URLRequest(url: safeUrl)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("jwt \(safeToken)", forHTTPHeaderField: "Authorization")
            
            let values = dict
            print("Params ->", values)
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: values, options: [])
//            print("httpBody ->", request.httpBody.jsonObject)
            

            AF.request(request)
                .responseJSON { response in
                    switch response.result {
                    case .success(let responseObject):
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject:responseObject)
                                print("jsonData  :", jsonData)
                                let result = try JSONDecoder().decode(BaseResponse<AddSiteRiskModel>.self, from: jsonData)
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
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                let outputStr  = String(data: data!, encoding: String.Encoding.utf8) as String?
//                print(outputStr)
////                switch response.result {
////                case .failure(let error):
////                    print(error)
////
//
////                case .success(let responseObject):
////                    print(responseObject)
////                }
//
//            }.resume()
//
//
////            AF.request(request)                               // Or `Alamofire.request(request)` in prior versions of Alamofire
////                .responseJSON { response in
////            }
//        }
//
//
//
//        //==========================================================================================================================================================
//
////        var parameters = [String : Any]()
//////        parameters = [    "name": name,
//////                          "type": type,
//////                          "project": project,
//////                          "description": description,
//////                          "file": file,
//////                    ]
//////        parameters = ["name": name, "summary": summary, "sender": sender, "price": price, "total_price": totalPrice, "receiver": receiver,  "file": file, "project":project, "gst": gst]
////
////        print("parameters @#$%@#$^%#^%#$%@", parameters)
////        print(dict.asParameters())
////
////
////        DispatchQueue.main.async{
////            APIManager.shared.request(url: API.addSiteRiskAssessment, method: .post,parameters: dict.asParameters() ,completionCallback: { (_ ) in
////
////            }, success: {  (json) in
////                print("json", json)
////                if let json = json {
////                    do {
////                        let jsonData = try JSONSerialization.data(withJSONObject:json)
////                        let decodedData = try JSONDecoder().decode(BaseResponse<AddSafetyModel>.self, from: jsonData)
////                        print(decodedData)
////                        if decodedData.code == 200 {
////                            completionHandler(true, decodedData.data!, "")
////                        } else {
////                            completionHandler(false, nil ,decodedData.message ?? "")
////                        }
////
////                    }
////                    catch let err {
////                        completionHandler(false,nil,err.localizedDescription ?? "")
////                    }
////                }
////            }) { (error) in
////                print("json error", error)
////                completionHandler(false,nil,error)
////            }
////
////        }
////
////    }
//
//
//    }
//
//
//
//}
//
//struct JSONArrayEncoding: ParameterEncoding {
//    private let array: [Parameters]
//
//    init(array: [Parameters]) {
//        self.array = array
//    }
//
//    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
//        var urlRequest = try urlRequest.asURLRequest()
//
//        let data = try JSONSerialization.data(withJSONObject: array, options: [])
//
//        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
//            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
}
