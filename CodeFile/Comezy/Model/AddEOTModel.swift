//
//  AddEOTModel.swift
//  Comezy
//
//  Created by aakarshit on 23/06/22.
//

import Foundation

// MARK: - AddEOTModel
struct AddEOTModel: Codable {
    let id: Int
    let name, numberOfDays, reasonForDelay, extendDateFrom: String
    let extendDateTo, createdDate: String
    let sender: Int
    let receiver: [EOTReceiver]
    let project: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case numberOfDays = "number_of_days"
        case reasonForDelay = "reason_for_delay"
        case extendDateFrom = "extend_date_from"
        case extendDateTo = "extend_date_to"
        case createdDate = "created_date"
        case sender, receiver, project
    }
}

// MARK: - Receiver
struct EOTReceiver: Codable {
    let id: Int
    let firstName, lastName, phone, email: String
    let profilePicture: String
    let occupation: Occupation

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case phone, email
        case profilePicture = "profile_picture"
        case occupation
    }
}
