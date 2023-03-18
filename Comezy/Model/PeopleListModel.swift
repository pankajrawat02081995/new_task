//
//  PeopleListModel.swift
//  Comezy
//
//  Created by shiphul on 15/12/21.
//

import Foundation

struct PeopleListModel: Codable {
    var next, previous: String?
    var totalCount: Int?
    var results: PeopleResults?

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Results
struct PeopleResults: Codable {
    var workers: [PeopleClient]?
    var client: PeopleClient?
}

//struct PeopleWorkers: Codable{
//    var id: Int?
//    var first_name: String?
//    var last_name: String?
//    var phone: String?
//    var email: String?
//    var profile_picture: String?
//    var occupation: Occupation?
//}


// MARK: - Client
struct PeopleClient: Codable {
    var id: Int?
    var firstName, lastName, email, phone: String?
    var profilePicture: String?
    var occupation: Occupation?
    var safetyCard: String?
    var tradingLicense: String?
    

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, phone
        case profilePicture = "profile_picture"
        case occupation
        case safetyCard = "safety_card"
        case tradingLicense = "trade_licence"
        
        
    }
}

struct Occupation: Codable {
    var id: Int?
    var name: String?
}
