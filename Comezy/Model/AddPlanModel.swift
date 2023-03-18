//
//  AddPlansModel.swift
//  Comezy
//
//  Created by shiphul on 07/12/21.
//

import Foundation
struct AddPlanModel: Codable {
    let id: Int
    let name, welcomeDescription: String
    let file: [String]
    let createdDate, workerWatch, builderWatch, clientWatch: String
    let project, createdBy: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case welcomeDescription = "description"
        case file
        case createdDate = "created_date"
        case workerWatch = "worker_watch"
        case builderWatch = "builder_watch"
        case clientWatch = "client_watch"
        case project
        case createdBy = "created_by"
    }
}
