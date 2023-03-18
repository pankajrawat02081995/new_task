//
//  ROIListViewModel.swift
//  Comezy
//
//  Created by aakarshit on 09/06/22.
//

import Foundation

class ROIListViewModel: NSObject {
    func getROIList(size: String, page: Int, project_id: Int, completionHandler: @escaping(_ success: Bool, _ resp: ROIListModel?, _ errorMsg: String?) -> Void){
      
        DispatchQueue.main.async {
            var url = API.getROIList
            url = url + "size=" + size + "&page=" + "\(page)" + "&project_id=" + "\(project_id)"
            print(url)

            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let result = try JSONDecoder().decode(BaseResponse<ROIListModel>.self, from: jsonData)
                        print("ProjectList  :", result)
                        if result.code == 200 {
                            completionHandler(true, result.data, "")
                            
                        } else {
                            completionHandler(false, nil, result.message ?? "Error occured while Decoding")
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
