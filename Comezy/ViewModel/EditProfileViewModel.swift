//
//  EditProfileViewModel.swift
//  Comezy
//
//  Created by amandeepsingh on 04/08/22.
//

import UIKit
import Alamofire
class EditProfileViewModel:NSObject{
    func updateProfile(firstName:String, lastName:String, phone: String, occupation: Int ,company: String ,profilePicture:String, completionHandler: @escaping(_ status: Bool, _ editProfile: EditProfileModel?, _ errorMsg: String?) -> Void){
  
    var parameters = [String : Any]()
    
    
    parameters = ["first_name":firstName,"last_name":lastName,"phone":phone,"occupation":occupation,"company":company, "profile_picture":profilePicture]
    print("parameters <!@#$!@#$@#$%^^&$&*%^&*%^#$@%$>", parameters)
    DispatchQueue.main.async{
        
        let url = API.updateProfile        
        APIManager.shared.request(url: url, method: .put, parameters:parameters ,encoding:URLEncoding.default,completionCallback: { (_ ) in
            
        }, success: {  (json) in
            print("json", json)
            if let json = json {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject:json)
                    let editProfileResponse = try JSONDecoder().decode(BaseResponse<EditProfileModel>.self, from: jsonData)
                    print(editProfileResponse)
                    print(editProfileResponse.code, "!@#$!@#$@#$%^#   Edit Profile   $%$%^$%^##$%")
                    if editProfileResponse.code == 200 {
                        completionHandler(true, editProfileResponse.data , "")
                    } else {
                        
                        completionHandler(false, nil ,editProfileResponse.message ?? "")
                    }
                    
                }
                
                catch let err{
                    
                    print("!@#$!@#$@#$%^#    FAILED  $%$%^$%^##$%", err)
                    completionHandler(false,nil,err.localizedDescription ?? "")
                    
                }
            }
        }) { (error) in
            print("json error", error)
            completionHandler(false,nil,error)
        }
        
    }
    
}
}
