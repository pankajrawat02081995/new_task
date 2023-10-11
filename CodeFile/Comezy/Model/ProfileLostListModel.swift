//
//  ProfileLostListModel.swift
//  Comezy
//
//  Created by Lalit Kumar on 28/09/23.
//

import Foundation


struct ProfitLostListModel : Codable {
    let status : String?
    let code : Int?
    let data : ProfitLostData?
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
        data = try values.decodeIfPresent(ProfitLostData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}

struct ProfitLostData : Codable {
    let client : ProfitLostClient?
    let total_earning : Int?
    let expenses : Double?
    let currency : String?
    let total_profit_loss : Int?
    let result : Int?

    enum CodingKeys: String, CodingKey {

        case client = "client"
        case total_earning = "total_earning"
        case expenses = "expenses"
        case currency = "currency"
        case total_profit_loss = "total_profit_loss"
        case result = "result"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        client = try values.decodeIfPresent(ProfitLostClient.self, forKey: .client)
        total_earning = try values.decodeIfPresent(Int.self, forKey: .total_earning)
        expenses = try values.decodeIfPresent(Double.self, forKey: .expenses)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        total_profit_loss = try values.decodeIfPresent(Int.self, forKey: .total_profit_loss)
        result = try values.decodeIfPresent(Int.self, forKey: .result)
    }

}


struct ProfitLostClient : Codable {
    let id : Int?
    let username : String?
    let email : String?
    let first_name : String?
    let last_name : String?
    let user_type : String?
    let occupation : Int?
    let profile_picture : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case username = "username"
        case email = "email"
        case first_name = "first_name"
        case last_name = "last_name"
        case user_type = "user_type"
        case occupation = "occupation"
        case profile_picture = "profile_picture"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        user_type = try values.decodeIfPresent(String.self, forKey: .user_type)
        occupation = try values.decodeIfPresent(Int.self, forKey: .occupation)
        profile_picture = try values.decodeIfPresent(String.self, forKey: .profile_picture)
    }

}
