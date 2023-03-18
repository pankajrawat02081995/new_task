//
//  VariationDetailModel.swift
//  Comezy
//
//  Created by aakarshit on 31/05/22.
//

import Foundation

struct VariationDetailModel: Codable {
    let id: Int
    let action, name, summary: String
    let gst: Bool
    let file: [String]
    let price, totalPrice, createdDate: String
    let project: Int
    let sender: Sender
    let receiver: [ReceiverResponse]

    enum CodingKeys: String, CodingKey {
        case id, action, name, summary, gst, file, price
        case totalPrice = "total_price"
        case createdDate = "created_date"
        case project, sender, receiver
    }
}

struct ReceiverResponse: Codable {
    let id: Int
    let firstName, lastName, phone, email: String
    let profilePicture: String
    let occupation: Occupation
    let action: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case phone, email
        case profilePicture = "profile_picture"
        case occupation, action
    }
}
