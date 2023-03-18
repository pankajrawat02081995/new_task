//
//  SignupViewModel.swift
//  Comezy
//
//  Created by MAC on 17/08/21.
//

import Foundation
import UIKit
import Alamofire

enum call: String {
    case signUp
    case login
}

class SignupViewModel: NSObject {
    var projectDataDetail : DataClass?
    
    
    
    func getsignupDetails(signupType: String,controller: UIViewController, first_name:String,last_name:String, user_type:String,email:String,password: String, cpassword: String, phone: String, facebook_token: String, apple_token: String, google_token: String, occupation: Int, company: String, signature: String, completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ type: String?) -> Void) {
        if signupType == "social" {
            serviceLogin(controller: controller, email: "", password: "", facebook_token: facebook_token, apple_token: apple_token, google_token: google_token) { (status, userDetail, err, mytype)  in
                if status {
                    completionHandler(true,err,mytype)
                }else {
                    completionHandler(false,err,mytype)
                }
            }
        }else if signupType == "socialSignup" {
            if (first_name.trimmingCharacters(in: .whitespaces).isEmpty) {
                completionHandler(false,FieldValidation.kFirstNameEmpty, "")
            }else if (last_name.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false,FieldValidation.kLastNameEmpty, "")
            }else if (phone.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false,FieldValidation.kPhoneEmpty, "")
            }else if occupation == 0{
                completionHandler(false,FieldValidation.kOccupationEmpty, "")
            }else if (company.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false,FieldValidation.kCompanyNameEmpty, "")
            }else if (signature.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false,FieldValidation.kSignatureEmpty, "")
            }else if (email.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false,FieldValidation.kEmailEmpty, "")
            }else if !email.isvalidEmail {
                completionHandler(false,FieldValidation.kValidEmail , "")
            }else {
            serviceSignup(controller: controller, first_name: first_name, last_name: last_name, user_type: user_type, email: email, password: password, phone: phone, facebook_token: facebook_token, apple_token: apple_token, google_token: google_token, occupation: occupation, company: company, signature: signature) { (status, userDetail, error, mytype) in
                if status {
                    completionHandler(true,nil,mytype)
                }else {
                    completionHandler(false,error,mytype)
                }
            }
            }
        }else {
            if (first_name.trimmingCharacters(in: .whitespaces).isEmpty) {
                completionHandler(false,FieldValidation.kFirstNameEmpty, "")
            }else if (last_name.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false,FieldValidation.kLastNameEmpty, "")
            }else if (phone.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false,FieldValidation.kPhoneEmpty, "")
            }else if (email.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false,FieldValidation.kEmailEmpty, "")
            }else if !email.isvalidEmail {
                completionHandler(false,FieldValidation.kValidEmail , "")
            }else if occupation == 0{
                completionHandler(false,FieldValidation.kOccupationEmpty, "")
            }else if (company.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false,FieldValidation.kCompanyNameEmpty, "")
            }else if (password.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false,FieldValidation.kPasswordEmpty , "")
            }else if (password.trimmingCharacters(in: .whitespaces) != cpassword.trimmingCharacters(in: .whitespaces)){
                completionHandler(false,FieldValidation.kPasswordsUnmatch,"")
            }else if (password.count < 6){
                completionHandler(false,FieldValidation.kPasswordsLength,"")
            }else if (signature.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false,FieldValidation.kSignatureEmpty, "")
            }else {
                serviceSignup(controller: controller, first_name: first_name, last_name: last_name, user_type: user_type, email: email, password: password, phone: phone, facebook_token: facebook_token, apple_token: apple_token, google_token: google_token, occupation: occupation, company: company, signature: signature) { (status, userDetail, error, mytype) in
                    if status {
                        completionHandler(true,nil,"")
                    }else {
                        completionHandler(false,error,"")
                    }
                }
            }
        }
    }
    
    func inviteWorkerSignupPressed(controller: UIViewController, first_name:String,last_name:String, user_type:String,email:String,password: String, cpassword: String, phone: String, occupation: Int, company: String, signature: String, safetyCard: String, tradingLicense: String, inviteId: Int, completionHandler:@escaping (_ sucess:Bool,_ user: UserBasicDetails?, _ eror:String?,_ type: String?) -> Void) {
        
            if (first_name.trimmingCharacters(in: .whitespaces).isEmpty) {
                completionHandler(false,nil, FieldValidation.kFirstNameEmpty, "")
            }else if (last_name.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false, nil, FieldValidation.kLastNameEmpty, "")
            }else if (phone.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false, nil, FieldValidation.kPhoneEmpty, "")
            }else if (email.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false, nil, FieldValidation.kEmailEmpty, "")
            }else if !email.isvalidEmail {
                completionHandler(false, nil, FieldValidation.kValidEmail , "")
            }else if occupation == 0{
                completionHandler(false, nil, FieldValidation.kOccupationEmpty, "")
            }else if (company.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false, nil, FieldValidation.kCompanyNameEmpty, "")
            }else if (password.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false, nil, FieldValidation.kPasswordEmpty , "")
            }else if (password.trimmingCharacters(in: .whitespaces) != cpassword.trimmingCharacters(in: .whitespaces)){
                completionHandler(false, nil, FieldValidation.kPasswordsUnmatch,"")
            }else if (password.count < 6){
                completionHandler(false, nil, FieldValidation.kPasswordsLength,"")
            }else if (signature.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false, nil, FieldValidation.kSignatureEmpty, "")
            }else {
                inviteWorkerSignupAPI(controller: controller, first_name: first_name, last_name: last_name, user_type: user_type, email: email, password: password, phone: phone, occupation: occupation, company: company, signature: signature, safetyCard: safetyCard ?? "", tradingLicense: tradingLicense ?? "", inviteId: inviteId) { status, user, errorMsg, type in
                    if status {
                        completionHandler(true, user, nil,"")
                    }else {
                        completionHandler(false, user, errorMsg,"")
                    }

                }
            }
        }
    
    func inviteClientSignupPressed(controller: UIViewController, first_name:String,last_name:String, user_type:String,email:String,password: String, cpassword: String, phone: String, occupation: Int, company: String, signature: String, inviteId: Int, completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ type: String?) -> Void) {
        
            if (first_name.trimmingCharacters(in: .whitespaces).isEmpty) {
                completionHandler(false,FieldValidation.kFirstNameEmpty, "")
            }else if (last_name.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false,FieldValidation.kLastNameEmpty, "")
            }else if (phone.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false,FieldValidation.kPhoneEmpty, "")
            }else if (email.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false,FieldValidation.kEmailEmpty, "")
            }else if !email.isvalidEmail {
                completionHandler(false,FieldValidation.kValidEmail , "")
            }else if occupation == 0{
                completionHandler(false,FieldValidation.kOccupationEmpty, "")
            }else if (company.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false,FieldValidation.kCompanyNameEmpty, "")
            }else if (password.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false,FieldValidation.kPasswordEmpty , "")
            }else if (password.trimmingCharacters(in: .whitespaces) != cpassword.trimmingCharacters(in: .whitespaces)){
                completionHandler(false,FieldValidation.kPasswordsUnmatch,"")
            }else if (password.count < 6){
                completionHandler(false,FieldValidation.kPasswordsLength,"")
            }else if (signature.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false,FieldValidation.kSignatureEmpty, "")
            }else {
                inviteClientSignupAPI(controller: controller, first_name: first_name, last_name: last_name, user_type: user_type, email: email, password: password, phone: phone, occupation: occupation, company: company, signature: signature, inviteId: inviteId) { status, user, errorMsg, type in
                    if status {
                        completionHandler(true,nil,"")
                    }else {
                        completionHandler(false,errorMsg,"")
                    }

                }
            }
        }

    
    
    
    func getEmailString(email:String,password: String,controller: UIViewController, completionHandler:@escaping (_ sucess:Bool,_ eror:String?) -> Void){
        if (email.isEmpty) {
            completionHandler(false,FieldValidation.kEmailEmpty)
        } else if !email.isvalidEmail {
            completionHandler(false,FieldValidation.kValidEmail)
            
        } else if (password.trimmingCharacters(in: .whitespaces).isEmpty) {
            completionHandler(false,FieldValidation.kPasswordEmpty)
        } else{
            serviceLogin(controller: controller, email: email, password: password, facebook_token: "", apple_token: "", google_token: "", completionHandler: { (status, userDetail, error, mytype)  in
                if status {
                    completionHandler(true,nil)
                } else {
                    completionHandler(false,error)
                }
            })
        }
    }
    //API for SignUp
    
func inviteWorkerSignupAPI(controller: UIViewController,first_name:String,last_name:String, user_type:String,email:String,password: String,phone: String, occupation: Int, company: String, signature: String, safetyCard: String, tradingLicense: String, inviteId: Int, completionHandler: @escaping(_ status: Bool, _ user: UserBasicDetails?, _ errorMsg: String?,_ type: String?) -> Void){
    var parameters = [String : Any]()
    parameters = ["first_name":first_name,"last_name":last_name, "user_type":user_type,"email":email, "password":password,"phone":phone, "occupation":occupation, "safety_card" : safetyCard, "trade_licence" : tradingLicense, "company":company, "signature":signature, "invite_id": inviteId,"facebook_token":"","google_token":"","apple_token":"" ]
    DispatchQueue.main.async {
        APIManager.shared.requestWithoutHeaders(url: API.registerApi, method: .post, parameters:parameters ,completionCallback: { (_ ) in
            
        }, success: { (json) in
                
            if let json = json {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject:json)
                    let profile = try JSONDecoder().decode(BaseResponse<UserBasicDetails>.self, from: jsonData)
                    if profile.code == 200 {
                        kUserData = profile.data
                        completionHandler(true, profile.data, "", "login")
                    }else if profile.code == 401 {
//                        kUserData = profile.data
                        completionHandler(false, nil, profile.message, "")
                    } else if profile.code == 400 {
                        completionHandler(false, nil, profile.message , "" )
                    } else if profile.code == 402 {
                        //kUserData = profile.data
                        completionHandler(false,nil,profile.message, "login")
                    } else {
                        completionHandler(false,nil,profile.message ?? "", "")
                    }
                    
                }
                catch {
                    completionHandler(false,nil,"Something went wrong","")
                }
            }
        }) { (error) in
            completionHandler(false,nil,error,"")
            
        }
    }
}
    
func inviteClientSignupAPI(controller: UIViewController,first_name:String,last_name:String, user_type:String,email:String,password: String,phone: String, occupation: Int, company: String, signature: String, inviteId: Int, completionHandler: @escaping(_ status: Bool, _ user: UserBasicDetails?, _ errorMsg: String?,_ type: String?) -> Void){
    var parameters = [String : Any]()
    parameters = ["first_name":first_name,"last_name":last_name, "user_type":user_type,"email":email, "password":password,"phone":phone, "occupation":occupation, "company":company, "signature":signature, "invite_id": inviteId ]
    DispatchQueue.main.async {
        APIManager.shared.requestWithoutHeaders(url: API.registerApi, method: .post,parameters:parameters ,completionCallback: { (_ ) in
            
        }, success: { (json) in
                
            if let json = json {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject:json)
                    let profile = try JSONDecoder().decode(BaseResponse<UserBasicDetails>.self, from: jsonData)
                    if profile.code == 200 {
                        kUserData = profile.data
                        completionHandler(true, profile.data, "", "login")
                    }else if profile.code == 401 {
//                        kUserData = profile.data
                        completionHandler(false, nil, profile.message, "")
                    } else if profile.code == 400 {
                        completionHandler(false, nil,  profile.message, "" )
                    } else if profile.code == 402 {
                        //kUserData = profile.data

                        completionHandler(false,nil,profile.message ?? "", "")
                        
                    } else {
                        completionHandler(false,nil,profile.message ?? "", "")
                    }
                    
                }
                catch {
                    completionHandler(false,nil,"Something went wrong","")
                }
            }
        }) { (error) in
            completionHandler(false,nil,error,"")
            
        }
    }
}

    func serviceSignup(controller: UIViewController,first_name:String,last_name:String, user_type:String,email:String,password: String,phone: String, facebook_token: String, apple_token: String, google_token: String, occupation: Int, company: String, signature: String, completionHandler: @escaping(_ status: Bool, _ user: UserBasicDetails?, _ errorMsg: String?,_ type: String?) -> Void){
        var parameters = [String : Any]()
        print(google_token)
        if google_token != "" {
            parameters = ["first_name":first_name,"last_name":last_name, "user_type":user_type,"email":email,"phone":phone, "facebook_token":facebook_token,"apple_token":apple_token,"google_token":google_token, "occupation":occupation, "company":company, "signature":signature, "password": ""]
         //parameters = ["first_name":first_name,"last_name":last_name, "user_type":user_type,"email":email, "google_token":google_token]
        }else if facebook_token != "" {
            parameters = ["first_name":first_name,"last_name":last_name, "user_type":user_type,"email":email,"phone":phone, "facebook_token":facebook_token,"apple_token":apple_token,"google_token":google_token, "occupation":occupation, "company":company, "signature":signature, "password": ""]
            //parameters = ["first_name":first_name,"last_name":last_name, "user_type":user_type,"email":email, "facebook_token":facebook_token]
           }else if apple_token != "" {
            parameters = ["first_name":first_name,"last_name":last_name, "user_type":user_type,"email":email,"phone":phone, "facebook_token":facebook_token,"apple_token":apple_token,"google_token":google_token, "occupation":occupation, "company":company, "signature":signature, "password": ""]
            //parameters = ["first_name":first_name,"last_name":last_name, "user_type":user_type,"email":email, "apple_token":apple_token]
           }else {
            parameters = ["first_name":first_name,"last_name":last_name, "user_type":user_type,"email":email, "password":password,"phone":phone, "facebook_token":facebook_token,"apple_token":apple_token,"google_token":google_token, "occupation":occupation, "company":company, "signature":signature]
           }
        DispatchQueue.main.async {
            APIManager.shared.requestWithoutHeaders(url: API.registerApi, method: .post,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                    
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let profile = try JSONDecoder().decode(BaseResponse<UserBasicDetails>.self, from: jsonData)
                        if profile.code == 200 {
                            kUserData = profile.data
                            completionHandler(true, profile.data, "", "login")
                        }else if profile.code == 401 {
//                            kUserData = profile.data
                            completionHandler(false,nil,  profile.message, "")
                        } else if profile.code == 400 {
                            completionHandler(false, nil,  profile.message, "" )
                        } else if profile.code == 402 {
                            //kUserData = profile.data

                            completionHandler(false,nil,profile.message ?? "", "")
                        } else {
                            completionHandler(false,nil,profile.message ?? "", "")
                        } 
                        
                    }
                    catch {
                        completionHandler(false,nil,"Something went wrong","")
                    }
                }
            }) { (error) in
                completionHandler(false,nil,error,"")
                
            }
        }
    }
    //API for Login
    func serviceLogin(controller: UIViewController,email:String,password:String, facebook_token: String, apple_token: String, google_token: String, completionHandler: @escaping(_ status: Bool, _ user: UserBasicDetails?, _ errorMsg: String?, _ type: String) -> Void){
        var parameters = [String : Any]()
        if google_token != "" {
            parameters = ["email":email.lowercased(),"password":password, "google_token":google_token]
        }else if facebook_token != "" {
            parameters = ["email":email.lowercased(),"password":password, "facebook_token":facebook_token]
           }else if apple_token != "" {
               parameters = ["email":email.lowercased(),"password":password, "apple_token":apple_token]
           }else {
               parameters = ["email":email.lowercased(),"password":password]
           }
            APIManager.shared.requestWithoutHeaders(url: API.loginApi, method: .post,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let response402 = try JSONDecoder().decode(BaseResponse<EmptyData>.self, from: jsonData)
                        let profile = try JSONDecoder().decode(BaseResponse<UserBasicDetails>.self, from: jsonData)
                        let profileWithId = try JSONDecoder().decode(BaseResponse<UserDetailModel>.self, from: jsonData)
                        let defaults = UserDefaults.standard

                        if profile.code == 200 {
                            defaults.set(profileWithId.data?.id, forKey: "userId")
                            defaults.set(profileWithId.data?.userType, forKey: "userOccupation")
                            print(profileWithId.data?.id)
                            kUserData = profile.data
                            print(profile.data?.safety_card)
//                            print(kUserData)
//                            print(kUserData?.jwt_token)
//                            print(kUserData?.profile_picture)
                            print(profileWithId.data)
                            print(profile.data)
                           
                            completionHandler(true, profile.data, "", "login")
                        }else if profile.code == 401 {
//                            kUserData = profile.data

                            completionHandler(true, nil, profile.message, "")
                        }else if response402.code == 402 {
                            //kUserData = profile.data

                            completionHandler(false,nil,profile.message ?? "", "")
                        }
                        else {
                            completionHandler(false,nil,profile.message ?? "", "")
                        }
                        
                    }
                    catch let err{
                        print(json)
                        if json.value(forKey: "code") as! Int == 401  {
                            completionHandler(true, nil, "", "signup")
                        } else if json.value(forKey: "code") as! Int == 400 {
                            completionHandler(false, nil, "You have entered an invalid username or password", "")
                        }
                        else {
                            completionHandler(false,nil,err.localizedDescription, "")
                        }
                    }
                }
            }) { (error) in
                completionHandler(false,nil,error, "")
                
            }
        
    }
    
    func getOccupationList(completionHandler: @escaping(_ status: Bool, _ occList: OccupationModel?, _ errorMsg: String?) -> Void) {
        DispatchQueue.main.async {
            APIManager.shared.requestWithoutHeaders(url: API.getOccupationList, method: .get,parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let occupation = try JSONDecoder().decode(BaseResponse<OccupationModel>.self, from: jsonData)
                        print(occupation)
                        if occupation.code == 200 {
                            completionHandler(true, occupation.data, "")
                        }else {
                            completionHandler(false,nil,occupation.message ?? "")
                        }
                        
                    }
                    catch let err{
                        completionHandler(false,nil,err.localizedDescription ?? "")
                    }
                }
            }) { (error) in
                completionHandler(false,nil,error)
                
            }
        }
    }
    
    func addOccupation(name: String ,completionHandler: @escaping(_ status: Bool, _ variationModel: AddOccupationModel?, _ errorMsg: String?) -> Void){
        
        
        var parameters = [String : Any]()
        parameters = [    "name": name,
                    ]
//        parameters = ["name": name, "summary": summary, "sender": sender, "price": price, "total_price": totalPrice, "receiver": receiver,  "file": file, "project":project, "gst": gst]
        
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
            APIManager.shared.requestWithoutHeaders(url: API.addOccupation, method: .post ,parameters: parameters ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let occupation = try JSONDecoder().decode(BaseResponse<AddOccupationModel>.self, from: jsonData)
                        print(occupation)
                        if occupation.code == 200 {
                            completionHandler(true, occupation.data, "")
                        }else {
                            completionHandler(false,nil,occupation.message ?? "")
                        }
                        
                    }
                    catch let err{
                        completionHandler(false,nil,err.localizedDescription ?? "")
                    }
                }
            }) { (error) in
                completionHandler(false,nil,error)
                
            }

//            APIManager.shared.request(url: API.addOccupation, method: .post,parameters:parameters, encoding: URLEncoding.default ,completionCallback: { (_ ) in
//
//            }, success: {  (json) in
//                print("json", json)
//                if let json = json {
//                    do {
//                        let jsonData = try JSONSerialization.data(withJSONObject:json)
//                        let decodedData = try JSONDecoder().decode(BaseResponse<AddOccupationModel>.self, from: jsonData)
//                        print(decodedData)
//                        if decodedData.code == 200 {
//                            completionHandler(true, decodedData.data!, "")
//                        } else {
//                            completionHandler(false, nil ,decodedData.message ?? "")
//                        }
//
//                    }
//                    catch let err {
//                        completionHandler(false,nil,err.localizedDescription ?? "")
//                    }
//                }
//            }) { (error) in
//                print("json error", error)
//                completionHandler(false,nil,error)
//            }
            
        }
        
    }
    
    
    //API for List Projects
    func getListProjects(searchProject: String, type: String, completionHandler: @escaping(_ status: Bool, _ projectList: [ProjectResult]?, _ errorMsg: String?) -> Void){
      
        DispatchQueue.main.async{
//            var parameters = [String : Any]()
//            parameters = ["status" : type, "page": 1 , "size": 10, "search": searchProject ]
            var url = API.projectListApi
            url = url + "status=" +  "\(type)" + "&page=" + "1" + "&size=" + "1000" + "&search=" + "\(searchProject)"
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let ProjectList = try JSONDecoder().decode(BaseResponse<DataClass>.self, from: jsonData)
                        print("ProjectList  :", ProjectList)
                        if ProjectList.code == 200 {
                            completionHandler(true, ProjectList.data?.results, "")
                            
                        }else {
                            completionHandler(false,nil,ProjectList.message ?? "")
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
    
    //Api for Password Reset
    func getPassLink(email:String, completionHandler: @escaping(_ status: Bool, _ errorMsg: String?) -> Void){
        if (email.trimmingCharacters(in: .whitespaces).isEmpty) {
            completionHandler(false,FieldValidation.kEmailEmpty)
        }else if !email.isvalidEmail {
            completionHandler(false,FieldValidation.kValidEmail)
        }else {
            DispatchQueue.main.async{
                APIManager.shared.requestWithoutHeaders(url: API.getForgotPassLink+"?email=\(email)", method: .get,parameters: nil ,completionCallback: { (_ ) in
                    
                }, success: { (json) in
                    
                    if let json = json {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject:json)
                            let EmailList = try JSONDecoder().decode(BaseResponse<UserBasicDetails>.self, from: jsonData)
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
   

    func profileDetail(completionHandler: @escaping(_ status: Bool, _ createSubscriptionModel: ProfileDetailModel?, _ errorMsg: String?) -> Void){
        
      
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.profileDetail, method: .get,parameters:nil ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let profile = try JSONDecoder().decode(BaseResponse<UserBasicDetails>.self, from: jsonData)
                        let decodedData = try JSONDecoder().decode(BaseResponse<ProfileDetailModel>.self, from: jsonData)
                        print(decodedData)
                        if decodedData.code == 200 {
                            kUserData = profile.data
                            completionHandler(true, decodedData.data!, "")
                        } else {
                            completionHandler(false, nil ,decodedData.message ?? "")
                        }
                        
                    }
                    catch let err {
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
