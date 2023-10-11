//
//  ProfileDetailsModel.swift
//  Comezy
//
//  Created by Lalit Kumar on 21/08/23.
//

import Foundation

struct ProfileDetailsModel : Codable {
    let status : String?
    let code : Int?
    let data : ProfileDetailsData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case code = "code"
        case data = "data"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        data = try values.decodeIfPresent(ProfileDetailsData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}


struct ProfileDetailsData : Codable {
    let id : Int?
    let jwt_token : String?
    let first_name : String?
    let last_name : String?
    let email : String?
    let phone : String?
    let user_type : String?
    let is_subscription : String?
    let trial_ended : String?
    let occupation : ProfileOccupation?
    let company : String?
    let signature : String?
    let username : String?
    let profile_picture : String?
    let safety_card : String?
    let trade_licence : String?
    let address : String?
    let aBN : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case jwt_token = "jwt_token"
        case first_name = "first_name"
        case last_name = "last_name"
        case email = "email"
        case phone = "phone"
        case user_type = "user_type"
        case is_subscription = "is_subscription"
        case trial_ended = "trial_ended"
        case occupation = "occupation"
        case company = "company"
        case signature = "signature"
        case username = "username"
        case profile_picture = "profile_picture"
        case safety_card = "safety_card"
        case trade_licence = "trade_licence"
        case address = "address"
        case aBN = "ABN"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        jwt_token = try values.decodeIfPresent(String.self, forKey: .jwt_token)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        user_type = try values.decodeIfPresent(String.self, forKey: .user_type)
        is_subscription = try values.decodeIfPresent(String.self, forKey: .is_subscription)
        trial_ended = try values.decodeIfPresent(String.self, forKey: .trial_ended)
        occupation = try values.decodeIfPresent(ProfileOccupation.self, forKey: .occupation)
        company = try values.decodeIfPresent(String.self, forKey: .company)
        signature = try values.decodeIfPresent(String.self, forKey: .signature)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        profile_picture = try values.decodeIfPresent(String.self, forKey: .profile_picture)
        safety_card = try values.decodeIfPresent(String.self, forKey: .safety_card)
        trade_licence = try values.decodeIfPresent(String.self, forKey: .trade_licence)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        aBN = try values.decodeIfPresent(String.self, forKey: .aBN)
    }

}


struct ProfileOccupation : Codable {
    let name : String?
    let id : Int?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case id = "id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
    }

}
