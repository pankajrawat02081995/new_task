//
//  ScheduleViewModel.swift
//  Comezy
//
//  Created by aakarshit on 09/08/22.
//

import Foundation

class ScheduleViewModel: NSObject {
    func getScheduleTasksList(size: String, page: Int, project_id: Int, month: String, date: String, completionHandler: @escaping(_ success: Bool, _ resp: ScheduleModel?, _ errorMsg: String?) -> Void){
        
        DispatchQueue.main.async{
            var url = API.getSchedule
            url = url + "size=" + size + "&page=" + "\(page)" + "&project_id=" + "\(project_id)" + "&month=" + month + "&date=" + date
            print(url)
            

            APIManager.shared.requestWithoutHUD(url: url, method: .get, completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let result = try JSONDecoder().decode(BaseResponse<ScheduleModel>.self, from: jsonData)
                        print("ProjectList  :", result)
                        if result.code == 200 {
                            completionHandler(true, result.data, "")
                            
                        }else {
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
}
