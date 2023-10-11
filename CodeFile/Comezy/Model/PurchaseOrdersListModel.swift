//
//  PurchaseOrdersListModel.swift
//  Comezy
//
//  Created by Lalit Kumar on 28/09/23.
//

import Foundation


struct PurchaseOrdersListModel : Codable {
    let status : String?
    let code : Int?
    let data : PurchaseOrdersData?
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
        data = try values.decodeIfPresent(PurchaseOrdersData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}


struct PurchaseOrdersData : Codable {
    let count : Int?
    let next : String?
    let previous : String?
    let results : PurchaseOrdersResults?

    enum CodingKeys: String, CodingKey {

        case count = "count"
        case next = "next"
        case previous = "previous"
        case results = "results"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        next = try values.decodeIfPresent(String.self, forKey: .next)
        previous = try values.decodeIfPresent(String.self, forKey: .previous)
        results = try values.decodeIfPresent(PurchaseOrdersResults.self, forKey: .results)
    }

}


struct PurchaseOrdersResults : Codable {
    let purchase_details : [PurchaseOrdersdetails]?

    enum CodingKeys: String, CodingKey {

        case purchase_details = "purchase_details"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        purchase_details = try values.decodeIfPresent([PurchaseOrdersdetails].self, forKey: .purchase_details)
    }

}


struct PurchaseOrdersdetails : Codable {
    let id : Int?
    let currency : String?
    let created_date : String?
    let purchase_code : String?
    let amount_of_purchase : Double?
    let owner : PurchaseOrderOwner?
    let client : PurchaseOrdersClient?
    let project : PurchaseOrderProject?
    let address : PurchaseOrdersAddress?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case currency = "currency"
        case created_date = "created_date"
        case purchase_code = "purchase_code"
        case amount_of_purchase = "amount_of_purchase"
        case owner = "Owner"
        case client = "Client"
        case project = "project"
        case address = "address"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        created_date = try values.decodeIfPresent(String.self, forKey: .created_date)
        purchase_code = try values.decodeIfPresent(String.self, forKey: .purchase_code)
        amount_of_purchase = try values.decodeIfPresent(Double.self, forKey: .amount_of_purchase)
        owner = try values.decodeIfPresent(PurchaseOrderOwner.self, forKey: .owner)
        client = try values.decodeIfPresent(PurchaseOrdersClient.self, forKey: .client)
        project = try values.decodeIfPresent(PurchaseOrderProject.self, forKey: .project)
        address = try values.decodeIfPresent(PurchaseOrdersAddress.self, forKey: .address)
    }

}


struct PurchaseOrderOwner : Codable {
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


struct PurchaseOrderProject : Codable {
    let id : Int?
    let name : String?
    let address : Int?
    let client : Int?
    let description : String?
    let scope_of_work : [String]?
    let created_date : String?
    let last_updated : String?
    let worker : [Int]?
    let status : String?
    let quotations : [String]?
    let builder : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case address = "address"
        case client = "client"
        case description = "description"
        case scope_of_work = "scope_of_work"
        case created_date = "created_date"
        case last_updated = "last_updated"
        case worker = "worker"
        case status = "status"
        case quotations = "quotations"
        case builder = "builder"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        address = try values.decodeIfPresent(Int.self, forKey: .address)
        client = try values.decodeIfPresent(Int.self, forKey: .client)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        scope_of_work = try values.decodeIfPresent([String].self, forKey: .scope_of_work)
        created_date = try values.decodeIfPresent(String.self, forKey: .created_date)
        last_updated = try values.decodeIfPresent(String.self, forKey: .last_updated)
        worker = try values.decodeIfPresent([Int].self, forKey: .worker)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        quotations = try values.decodeIfPresent([String].self, forKey: .quotations)
        builder = try values.decodeIfPresent(Int.self, forKey: .builder)
    }

}


struct PurchaseOrdersClient : Codable {
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


struct PurchaseOrdersAddress : Codable {
    let id : Int?
    let name : String?
    let longitude : Double?
    let latitude : Double?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case longitude = "longitude"
        case latitude = "latitude"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
    }

}
