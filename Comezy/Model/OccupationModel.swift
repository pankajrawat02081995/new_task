//
//  OccupationModel.swift
//  Comezy
//
//  Created by archie on 27/10/21.
//

import Foundation

struct OccupationModel: Codable {
    
    var next: String?
    var previous: String?
    var count: Int?
    var results: [Occupaton]?
    
    
    
    enum CodingKeys: String, CodingKey {
        case next, previous, count, results
    }
}

struct Occupaton: Codable {
    var name: String?
    var id: Int?
    
    enum CodingKeys: String, CodingKey {
        case name, id
    }
}

struct AddOccupationModel: Codable {
    let name: String
    let id: Int
}
