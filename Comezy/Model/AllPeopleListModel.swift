//
//  AllPeopleListModel.swift
//  Comezy
//
//  Created by aakarshit on 24/05/22.
//
import Foundation

// MARK: - WelcomeElement
struct AllPeopleListElement: Codable {
    let id: Int
    var firstName, lastName, phone, email: String
    let profilePicture, userType: String
    let occupation: Occupation?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case phone, email
        case profilePicture = "profile_picture"
        case userType = "user_type"
        case occupation
    }
}


typealias AllPeopleListModel = [AllPeopleListElement]

struct AllPeopleResults: Codable {
    
}

struct SelectedReceiver {
    var receiverId: Int?
    var checked: Bool?
    var person: AllPeopleListElement
}
