//
//  ChangePasswordViewModel.swift
//  Comezy
//
//  Created by amandeepsingh on 02/08/22.
//

import Foundation
import UIKit

//Api for Password Reset
class ChangePasswordViewModel: NSObject {
    static var shared = ChangePasswordViewModel()

    func changePassword(oldPassword:String,newPassword:String,confirmPassword:String, completionHandler: @escaping(_ status: Bool, _ errorMsg: String?) -> Void){
    if (oldPassword.trimmingCharacters(in: .whitespaces).isEmpty) {
        completionHandler(false,FieldValidation.kEmailEmpty)
    }
    else if (newPassword.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kPasswordEmpty)
        }else if (newPassword.count < 6){
            completionHandler(false,FieldValidation.kPasswordsLength)
        }
        else if (newPassword.trimmingCharacters(in: .whitespaces) != confirmPassword.trimmingCharacters(in: .whitespaces)){
            completionHandler(false,FieldValidation.kPasswordsUnmatch)
        }else {
            var parameters = [String : Any]()
            parameters = ["old_password":oldPassword,"new_password":newPassword]

        DispatchQueue.main.async{
            APIManager.shared.request(url: API.changePassword, method: .post, parameters:parameters ,completionCallback: { (_ ) in
 
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let EmailList = try JSONDecoder().decode(BaseResponse<ChangePasswordModel>.self, from: jsonData)
                        if EmailList.code == 200 {
                            completionHandler(true, "")
                        }else {
                            completionHandler(false, json.value(forKey: "message") as! String)
                        }
                        
                    }
                    catch let err{
                        completionHandler(false,err.localizedDescription )
                    }
                }
            }) { (error) in
                completionHandler(false,error)
                
            }
        }
    }
    
}




}

