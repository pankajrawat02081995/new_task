//
//  PlDetailsVM.swift
//  Comezy
//
//  Created by Lalit Kumar on 28/09/23.
//

import Foundation







class PLDetailsViewModel {
    
    var jsonData : PLDetailsModel?
    
    //MARK: - PROFIT LOST LIST
    func getProfitLostList(projectId: Int ,_ completion:@escaping() -> Void) {
       
        
        let url = "\(ApiUrl.profileLostDetails)?project_id=\(projectId)"
        
        WebServices.shared.getData(url, showIndicator: true) { response in
            if response.isSuccess {
                let apiData = Constantss.shared.jsonDecoder.decode(model: PLDetailsModel.self, data: response.data)
                self.jsonData = apiData
                completion()
            } else {
                CommonMethod.shared.hideActivityIndicator()
                Alerts.shared.showAlert(title: AppInfo.appName, message: response.message)
            }
        }
    }
    
}
