//
//  ForgotPasswordModel.swift
//  Comezy
//
//  Created by shiphul on 13/11/21.
//

import Foundation

struct DataClass: Codable{
    var next: String?
    var previous: String?
    var totalCount: Int?
    var results: [ProjectResult] = []
    
    enum CodingKeys: String, CodingKey {
        case next, previous, totalCount = "total_count", results
    }
}

struct ProjectResult: Codable {
    var id: Int?
    var name: String?
    var createdDate : String?
    var status: String?
    var resultDescription: String?
    var subscription_status : Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, name, subscription_status,createdDate = "created_date", status, resultDescription = "description"
    }
}
