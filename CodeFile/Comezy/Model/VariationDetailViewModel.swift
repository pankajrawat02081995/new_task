//
//  VariationDetailViewModel.swift
//  Comezy
//
//  Created by aakarshit on 31/05/22.
//

import Foundation

class VariationDetailViewModel: NSObject {
    func getVariationDetail(variation_id: Int, completionHandler: @escaping(_ status: Bool, _ variationDetailResp: VariationDetailModel?, _ errorMsg: String?) -> Void){
        

        DispatchQueue.main.async {

            var url = API.getVariationDetail
            url = url + "\(variation_id)"
            print(url)

            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in

            }, success: { (json) in

                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let variationDetailResponse = try JSONDecoder().decode(BaseResponse<VariationDetailModel>.self, from: jsonData)
                        print("ProjectList  :", variationDetailResponse)
                        if variationDetailResponse.code == 200 {
                            completionHandler(true, variationDetailResponse.data as! VariationDetailModel, "")

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
}

// I F   N O T    U S I N G   A L A M O F I R E
//        //URLComponents to the rescue!
//        let urlString = "http://3.21.238.163:8000/api/variation/retrieve/"
//        var urlBuilder = URLComponents(string: urlString)
//        urlBuilder?.queryItems = [
//            URLQueryItem(name: "variation_id", value: "34")
////            URLQueryItem(name: "variation_id", value: "16"),
////            URLQueryItem(name: "size", value: "0"),
////            URLQueryItem(name: "page", value: "1")
//        ]
//
//        guard let url = urlBuilder?.url else { return }
//
//                 var request = URLRequest(url: url)
//                 request.httpMethod = "GET"
//        request.setValue("JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo3LCJ1c2VybmFtZSI6IjE0Mjc4MDliLWUyNGItNDczMy04YTgyLTlhOTY2YmE1ZGYwYSIsImV4cCI6MjUxNjk2ODg4MSwiZW1haWwiOiJ0ZXN0ZGV2ZWxvcGVyQHlvcG1haWwuY29tIn0.dAeRU4OwkQh18fc0K5kEmF42L13fp4r2Ov7C0SWchRI"
//,forHTTPHeaderField: "Authorization")
//        print("jwt \(kUserData!.jwt_token)")
//
//
//                 URLSession.shared.dataTask(with: request) { (data, response, error) in
//                     print(response,"<====== R E S P O N S E")
//                     print(data,"<====== D A T A ")
//                     print(error, "<====== E R R O R")
//
//                     if let data = data {
//                              if let jsonString = String(data: data, encoding: .utf8) {
//                                 print(jsonString)
//                              }
//                            }
//                 }.resume()
//             }
