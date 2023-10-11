//
//  ProfileDetailsViewModel.swift
//  Comezy
//
//  Created by Lalit Kumar on 21/08/23.
//

import Foundation

class ProfileDetailsViewModel {
    
    var jsonData : ProfileDetailsModel?
    
    func getProfileDetails(_ completion:@escaping() -> Void) {
        let url = "\(ApiUrl.profileDetails)"
        
        
        WebServices.shared.getData(url, showIndicator: true) { response in
            if response.isSuccess {
                
                let apiData = Constantss.shared.jsonDecoder.decode(model: ProfileDetailsModel.self, data: response.data)
                self.jsonData = apiData

                completion()
            } else {
                CommonMethod.shared.hideActivityIndicator()
                Alerts.shared.showAlert(title: AppInfo.appName, message: response.message)
            }
        }
    }
    
}
