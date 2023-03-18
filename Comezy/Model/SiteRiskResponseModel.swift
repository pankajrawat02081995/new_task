//
//  SiteRiskResponseModel.swift
//  Comezy
//
//  Created by aakarshit on 13/07/22.
//

import Foundation

// MARK: - Welcome
struct SiteRiskResponseModel: Codable {
    let id: Int?
    let file: String?
    let createdDate, updatedDate, response, upload_file, assignedToWatch: String?
    let ownerWatch: String?
    let createdBy, project, question, assignedTo: Int?

    enum CodingKeys: String, CodingKey {
        case id, file
        case createdDate = "created_date"
        case updatedDate = "updated_date"
        case response
        case assignedToWatch = "assigned_to_watch"
        case ownerWatch = "builder_watch"
        case createdBy = "created_by"
        case project, question
        case assignedTo = "assigned_to"
        case upload_file = "upload_file"
    }
}
