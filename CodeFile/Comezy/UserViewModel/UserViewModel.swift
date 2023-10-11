//
//  UserViewModel.swift
//  Comezy
//
//  Created by mandeepkaur on 13/07/21.
//

import UIKit
import Combine
class UserViewModel:NSObject {
    
    fileprivate var user:UserBasicDetails?
    
    class var shared:UserViewModel{
        struct Singlton{
            static let instance = UserViewModel()
        }
        return Singlton.instance
    }
    func createUser(){
        if user != nil {
            user = nil
        }
        user = UserBasicDetails()
    }
    override private init() {
        
        super.init()
        
    }
}

extension UserViewModel{
    var first_name:String{
        set{
            if user != nil {
                user?.first_name = newValue
            }else{
                kUserData?.first_name = newValue
            }
        }
        get{
            if user != nil {
                return user?.first_name ?? ""
            }
            return kUserData?.first_name ?? ""
        }
    }
    
    var last_name:String{
        set{
            if user != nil {
                user?.last_name = newValue
            }else{
                kUserData?.last_name = newValue
            }
        }
        get{
            if user != nil {
                return user?.last_name ?? ""
            }
            return kUserData?.last_name ?? ""
        }
    }
    
    
    var userID:String?{kUserData?.username}
    
    func resetUser(){
        user = nil
        
    }
}
