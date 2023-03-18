//
//  ProfileDetailModel.swift
//  Comezy
//
//  Created by amandeepsingh on 08/08/22.
//

import Foundation

// MARK: - Welcome
struct ProfileDetailModel: Codable {
    let id: Int
    let jwtToken, firstName, lastName, email: String
    let phone, userType, isSubscription, trialEnded: String
    let occupation: ProfileDetailModelOccupation
    let company: String
    let signature: String
    let username: String
    let profilePicture: String
    let safetyCard, tradeLicence: String

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
        case safetyCard = "safety_card"
        case tradeLicence = "trade_licence"
    }
}

// MARK: - Occupation
struct ProfileDetailModelOccupation: Codable {
    let name: String
    let id: Int
}
