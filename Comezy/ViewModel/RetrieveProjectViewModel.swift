//
//  RetrieveProjectViewModel.swift
//  Comezy
//
//  Created by shiphul on 01/12/21.
//

import Foundation

//API for Retrieve Project Details
class RetrieveProjectViewModel : NSObject{
    
    var retrieveProjectDataDetail:RetrieveProjectModel?
    
    func getRetrieveProjectDetail(id:Int, completionHandler: @escaping(_ status: Bool, _ errorMsg: String?) -> Void) {
    DispatchQueue.main.async {
        
        APIManager.shared.request(url: API.retrieveProjectDetail + "\(id)" , method: .get,parameters:nil ,completionCallback: { (_ ) in
            
        }, success: { [self] (json) in
            
            if let json = json {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject:json)
                    let projectDetail = try JSONDecoder().decode(BaseResponse<RetrieveProjectModel?>.self, from: jsonData)
                    print(projectDetail)
                    if projectDetail.code == 200 {
                        self.retrieveProjectDataDetail = projectDetail.data.self as! RetrieveProjectModel
                        print(retrieveProjectDataDetail, "<========================  retrieveProjectDataDetail")
                        completionHandler(true, nil)
                    } else {
                        completionHandler(false, projectDetail.message)
                    }
                    
                }
                catch let err{
                    print(err, "<=================  Printing error jsno not getting decoded retrieveProjectDataDetail")
                    completionHandler(false, err.localizedDescription)
                }
            }
        }) { (error) in
            print(error)
            completionHandler(false, error)
            
        }
    }
}
}
