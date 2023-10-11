//
//  UserDetail.swift
//  LoginSignUp
//
//  Created by archie on 19/02/21.
//

import Foundation
import UIKit


struct UserBasicDetails: Codable {
    
    var id: Int?
    var jwt_token: String?
    var first_name : String?
    var last_name: String?
    var email: String?
    var phone: String?
    var user_type: String?
    var apple_token: String?
    var google_token: String?
    var occupation: Occupaton?
    var company: String?
    var signature: String?
    var username: String?
    var profile_picture: String?
    var is_subscription:String?
    var trial_ended:String?
    var trade_licence:String?
    var safety_card:String?
    var abn: String?
    var builderAddress: String?
    
    

    enum CodingKeys: String, CodingKey {
        case jwt_token, first_name, last_name, email, phone, user_type, apple_token, google_token, occupation, company, signature, username, profile_picture,is_subscription,trial_ended,safety_card,trade_licence,id, abn, builderAddress

    }
}

