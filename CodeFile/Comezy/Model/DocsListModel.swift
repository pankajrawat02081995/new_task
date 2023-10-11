//
//  DocsListModel.swift
//  Comezy
//
//  Created by shiphul on 07/12/21.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - DocsListModel
struct DocsListModel: Codable {
    let next: String
    let previous: String
    let totalCount: Int
    let results: [DocsListModelResult]

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - DocsListModelResult
struct DocsListModelResult: Codable {
    let id: Int
    let filesList: [DocsListModelFilesList]
    let name, resultDescription, supplierDetails, type: String
    let createdDate, updatedDate, workerWatch, ownerWatch: String
    let clientWatch: String
    let project, createdBy: Int

    enum CodingKeys: String, CodingKey {
        case id
        case filesList = "files_list"
        case name
        case resultDescription = "description"
        case supplierDetails = "supplier_details"
        case type
        case createdDate = "created_date"
        case updatedDate = "updated_date"
        case workerWatch = "worker_watch"
        case ownerWatch = "builder_watch"
        case clientWatch = "client_watch"
        case project
        case createdBy = "created_by"
    }
}

// MARK: - DocsListModelFilesList
struct DocsListModelFilesList: Codable {
    let id: Int
    let fileName: String
    let fileSize: String

    enum CodingKeys: String, CodingKey {
        case id
        case fileName = "file_name"
        case fileSize = "file_size"
    }
}
