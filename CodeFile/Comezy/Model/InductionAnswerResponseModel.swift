//
//  InductionAnswerResponseModel.swift
//  Comezy
//
//  Created by amandeepsingh on 10/08/22.
//

import Foundation
struct InductionAnswerResponseModel: Codable {
    let next, previous: String
    let totalCount: Int
    let results: [InductionAnswerResponseResult]

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Result
struct InductionAnswerResponseResult: Codable {
    let id: Int
    let question: InductionAnswerResponseQuestion
    let answer, createdDate: String
    let answeredBy: Int

    enum CodingKeys: String, CodingKey {
        case id, question, answer
        case createdDate = "created_date"
        case answeredBy = "answered_by"
    }
}

// MARK: - Question
struct InductionAnswerResponseQuestion: Codable {
    let id: Int
    let question: String
}
