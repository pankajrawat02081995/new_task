//
//  ClientListModel.swift
//  Comezy
//
//  Created by shiphul on 23/11/21.
//

import Foundation

/// <#Description#>
struct AddProjectModel:Codable{
    var id: Int?
    var name: String?
    var address : Caddress?
    var client: Int?
    var dataDescription: String?
    var scopeOfWork: [String]?
    var status: String?

    enum CodingKeys: String, CodingKey {
        case id, name, address, client
        case dataDescription = "description"
        case scopeOfWork = "scope_of_work"
        case status
    }
}

struct Caddress: Codable{
    var name: String?
    var longitude: Double?
    var latitude: Double?
}


