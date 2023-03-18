//
//  AddSpecificationRequest.swift
//  Comezy
//
//  Created by amandeepsingh on 01/07/22.
//

import Foundation
struct AddSpecificationRequest: Codable {
    let project: Int
    let welcomeDescription, name: String
    let filesList: Array<[String:String]>
    let type: String
    let supplierDetail:String

    enum CodingKeys: String, CodingKey {
        case project
        case welcomeDescription = "description"
        case name
        case filesList = "files_list"
        case type
        case supplierDetail="supplier_details"
    }
}

