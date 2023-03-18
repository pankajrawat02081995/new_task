//
//  CreateDocumentModel.swift
//  Comezy
//
//  Created by shiphul on 10/12/21.
//

import Foundation
// MARK: - Welcome
struct CreateDocumentModel: Codable {
    let id: Int
    let filesList: [FilesList]
    let name, welcomeDescription, supplierDetails, type: String
    let createdDate, updatedDate, workerWatch, builderWatch: String
    let clientWatch: String
    let project, createdBy: Int

    enum CodingKeys: String, CodingKey {
        case id
        case filesList = "files_list"
        case name
        case welcomeDescription = "description"
        case supplierDetails = "supplier_details"
        case type
        case createdDate = "created_date"
        case updatedDate = "updated_date"
        case workerWatch = "worker_watch"
        case builderWatch = "builder_watch"
        case clientWatch = "client_watch"
        case project
        case createdBy = "created_by"
    }
}

// MARK: - FilesList
struct FilesList: Codable {
    let id: Int
    let fileName: String
    let fileSize: String

    enum CodingKeys: String, CodingKey {
        case id
        case fileName = "file_name"
        case fileSize = "file_size"
    }
}

