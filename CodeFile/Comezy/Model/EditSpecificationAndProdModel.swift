//
//  EditSpecificationAndProdModel.swift
//  Comezy
//
//  Created by amandeepsingh on 08/07/22.
//

import Foundation
struct EditSpecificationAndProdModel: Codable {
    let id: Int
    let filesList: [EditSpecificationAndProductInfoFilesList]
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

// MARK: - EditSpecificationAndProductInfoFilesList
struct EditSpecificationAndProductInfoFilesList: Codable {
    let id: Int
    let fileName: String
    let fileSize: String

    enum CodingKeys: String, CodingKey {
        case id
        case fileName = "file_name"
        case fileSize = "file_size"
    }
}
