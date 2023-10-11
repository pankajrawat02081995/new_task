//
//  ChangePasswordModel.swift
//  Comezy
//
//  Created by amandeepsingh on 02/08/22.
//

import Foundation


// MARK: - Welcome
struct ChangePasswordModel: Codable {
    let id: Int
    let firstName, lastName, email, phone: String
    let userType: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, phone
        case userType = "user_type"
    }
}
