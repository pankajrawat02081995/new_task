//
//  ClientListModel.swift
//  Comezy
//
//  Created by shiphul on 23/11/21.
//

import Foundation

struct ClientListModel: Codable{
    var data : ClientData?
}

struct ClientData: Codable {
    var next : String?
    var previous: String?
    var total_count: Int?
    var results : [CResult] = []

}

struct CResult: Codable{
    var id : Int?
    var first_name: String!
    var last_name: String!
    var email: String?
    var phone: String
    var profile_picture: String?
}

