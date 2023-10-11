//
//  SiteQuestionListModel.swift
//  Comezy
//
//  Created by aakarshit on 06/07/22.
//

import Foundation

struct SiteQuestionListModel: Codable {
    let next, previous: String?
    let totalCount: Int?
    let results: [QuestionResult]

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Result
struct QuestionResult: Codable {
    let id: Int?
    let question, createdDate, updatedDate: String?
    let createdBy: Int?
    var file: String?
    var person: Int = -1
    var personName: String?
    var fileUrl: String?
    var builderResponse: String = ""

    enum CodingKeys: String, CodingKey {
        case id, question, file, fileUrl
        case createdDate = "created_date"
        case updatedDate = "updated_date"
        case createdBy = "created_by"
    }
}
