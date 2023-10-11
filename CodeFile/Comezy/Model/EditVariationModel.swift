//
//  EditVariationModel.swift
//  Comezy
//
//  Created by aakarshit on 07/06/22.
//

import Foundation

// MARK: - Welcome
struct EditVariationModel: Codable {
    let id: Int
    let receiver: [Receiver]
    let createdDate, name, summary: String
    let gst: Bool
    let file: [String]
    let price, totalPrice, senderWatch: String
    let sender, project: Int

    enum CodingKeys: String, CodingKey {
        case id, receiver
        case createdDate = "created_date"
        case name, summary, gst, file, price
        case totalPrice = "total_price"
        case senderWatch = "sender_watch"
        case sender, project
    }
}

//// MARK: - Receiver
//struct Receiver: Codable {
//    let id: Int
//    let firstName, lastName, phone, email: String
//    let profilePicture: String
//    let occupation: Occupation
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case phone, email
//        case profilePicture = "profile_picture"
//        case occupation
//    }
//}
