//
//  PlansListModel.swift
//  Comezy
//
//  Created by shiphul on 03/12/21.
//

import Foundation

struct PlansListModel: Codable {
        let next, previous: String
       let totalCount: Int
       let results: [PlansResult]

       enum CodingKeys: String, CodingKey {
           case next, previous
           case totalCount = "total_count"
           case results
       }
}

// MARK: - Result
struct PlansResult: Codable {
 
    let id: Int?
        var name, resultDescription: String?
        var file: [String]

        var createdDate, workerWatch, builderWatch, clientWatch: String?
        var project, createdBy: Int?

        enum CodingKeys: String, CodingKey {
            case id, name
            case resultDescription = "description"
            case file
            case createdDate = "created_date"
            case workerWatch = "worker_watch"
            case builderWatch = "builder_watch"
            case clientWatch = "client_watch"
            case project
            case createdBy = "created_by"
        }
}
