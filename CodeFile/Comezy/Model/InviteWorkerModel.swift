//
//  InviteWorkerModel.swift
//  Comezy
//
//  Created by aakarshit on 28/07/22.
//

import Foundation

// MARK: - InviteWorkerModel
struct InviteWorkerModel: Codable {
    let id: Int?
    let firstName, lastName, email, userType: String?
    let invitedBy, projectID: Int?
    let inductionURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case userType = "user_type"
        case invitedBy = "invited_by"
        case projectID = "project_id"
        case inductionURL = "induction_url"
    }
}
