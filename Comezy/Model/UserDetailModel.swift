//
//  UserDetailModel.swift
//  Comezy
//
//  Created by aakarshit on 02/06/22.
//

import Foundation
struct UserDetailModel: Codable {
    let id: Int?
    let jwtToken, firstName, lastName, email: String?
    let phone, userType, isSubscription, trialEnded: String?
    let occupation: Occupation?
    let company: String?
    let signature: String?
    let username, profilePicture: String?

    enum CodingKeys: String, CodingKey {
        case id
        case jwtToken = "jwt_token"
        case firstName = "first_name"
        case lastName = "last_name"
        case email, phone
        case userType = "user_type"
        case isSubscription = "is_subscription"
        case trialEnded = "trial_ended"
        case occupation, company, signature, username
        case profilePicture = "profile_picture"
    }
}
