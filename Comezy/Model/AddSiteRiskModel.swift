// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct AddSiteRiskElement: Codable {
    let id: Int
    let project: Project
    let createdBy, assignedTo: AssignedTo
    let file: String
    let response: String
    let question: Question
    let createdDate, updatedDate: String

    enum CodingKeys: String, CodingKey {
        case id, project
        case createdBy = "created_by"
        case assignedTo = "assigned_to"
        case file, response, question
        case createdDate = "created_date"
        case updatedDate = "updated_date"
    }
}

//// MARK: - AssignedTo
//struct AssignedTo: Codable {
//    let id: Int
//    let firstName, lastName, email, phone: String
//    let profilePicture: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case email, phone
//        case profilePicture = "profile_picture"
//    }
//}
//
//// MARK: - Project
//struct Project: Codable {
//    let id: Int
//    let name, createdDate, status, projectDescription: String
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case createdDate = "created_date"
//        case status
//        case projectDescription = "description"
//    }
//}
//
//// MARK: - Question
//struct Question: Codable {
//    let id: Int
//    let question: String
//}

typealias AddSiteRiskModel = [AddSiteRiskElement]
