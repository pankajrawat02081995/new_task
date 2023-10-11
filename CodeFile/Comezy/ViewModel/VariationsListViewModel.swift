//
//  VariationsListViewModel.swift
//  Comezy
//
//  Created by aakarshit on 26/05/22.
//

import Foundation

class VariationsListViewModel: NSObject {
    func getVariationsList(size: String, page: Int, project_id: Int, completionHandler: @escaping(_ status: Bool, _ variationsListResp: VariationsListModel?, _ errorMsg: String?) -> Void){
      
        DispatchQueue.main.async{
            var url = API.getVariationsList
            url = url + "size=" + size + "&page=" + "\(page)" + "&project_id=" + "\(project_id)"
            print(url)

            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let variationsList = try JSONDecoder().decode(BaseResponse<VariationsListModel>.self, from: jsonData)
                        print("ProjectList  :", variationsList)
                        if variationsList.code == 200 {
                            completionHandler(true, variationsList.data, "")
                            
                        }else {
                            completionHandler(false, nil, variationsList.message ?? "Error occured while Decoding")
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
