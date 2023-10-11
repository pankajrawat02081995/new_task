// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct SiteRiskModel: Codable {
    let next, previous: String
    let totalCount: Int
    let results: [SiteRiskResult]

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Result
struct SiteRiskResult: Codable {
    let id: Int?
    let project: Project
    let createdBy, assignedTo: AssignedTo
    let question: Question
    let createdDate, updatedDate: String?
    let file: String?
    let status_option: String?
    let response, assignedToWatch, upload_file, ownerWatch: String?

    enum CodingKeys: String, CodingKey {
        case id, project
        case createdBy = "created_by"
        case assignedTo = "assigned_to"
        case question
        case createdDate = "created_date"
        case updatedDate = "updated_date"
        case file, response
        case assignedToWatch = "assigned_to_watch"
        case ownerWatch = "builder_watch"
        case status_option = "status_option"
        case upload_file = "upload_file"
    }
}

// MARK: - AssignedTo
struct AssignedTo: Codable {
    let id: Int?
    let firstName, lastName, email, phone: String?
    let profilePicture: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, phone
        case profilePicture = "profile_picture"
    }
}

// MARK: - Project
struct SiteRiskProject: Codable {
    let id: Int?
    let name, createdDate, status, projectDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdDate = "created_date"
        case status
        case projectDescription = "description"
    }
}

// MARK: - Question
struct Question: Codable {
    let id: Int?
    let question: String?
}
