//
//  IncidentReportViewModel.swift
//  Comezy
//
//  Created by aakarshit on 30/06/22.
//

import Foundation

class IncidentReportListViewModel: NSObject {
    ///Variables
    static let shared = SafetyListViewModel()
    
    ///API Method to get Incident Report List
    func getList(size: String, page: Int, project_id: Int, completionHandler: @escaping(_ success: Bool, _ resp: IncidentReportModel?, _ errorMsg: String?) -> Void){
      
        DispatchQueue.main.async{
            var url = API.getIncidentReportList
            url = url + "size=" + size + "&page=" + "\(page)" + "&project_id=" + "\(project_id)"
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
            }, success: { (json) in
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let result = try JSONDecoder().decode(BaseResponse<IncidentReportModel>.self, from: jsonData)
                        if result.code == 200 {
                            completionHandler(true, result.data, "")
                        } else {
                            completionHandler(false, nil, result.message ?? "Error occured while Decoding")
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
    ///API Method to Delete Incident Report 

    func deleteIncidentReport(id: Int, completionHandler: @escaping(_ status: Bool, _ variationDetailResp: EmptyData?, _ errorMsg: String?) -> Void){
        
        DispatchQueue.main.async {

            var url = API.deleteIncidentReport
            url = url + "\(id)"

            APIManager.shared.request(url: url, method: .delete, parameters:nil ,completionCallback: { (_ ) in
 
            }, success: { (json) in

                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let variationResponseData = try JSONDecoder().decode(BaseResponse<EmptyData>.self, from: jsonData)
                        if variationResponseData.code == 200 {
                            completionHandler(true, nil , "")

                        } else {
                            completionHandler(false, nil, variationResponseData.message ?? "Error occured while Decoding")
                        }

                    }
                    catch let err {
                        completionHandler(false,nil,err.localizedDescription)
                    }
                }
            }) { (error) in
                completionHandler(false,nil,error)

            }
        }
    }
}
