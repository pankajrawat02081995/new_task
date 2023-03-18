//
//  InductionQuestionModel.swift
//  Comezy
//
//  Created by aakarshit on 29/07/22.
//

import Foundation
struct InductionQuestionModel: Codable {
    let next, previous: String
    let totalCount: Int
    let results: [InductionResult]

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - InductionResult
struct InductionResult: Codable {
    let id: Int
    let question, updatedDate, createdDate, correctAnswer: String
    let createdBy: Int
    var isCorrect: Bool?

    enum CodingKeys: String, CodingKey {
        case id, question
        case updatedDate = "updated_date"
        case createdDate = "created_date"
        case correctAnswer = "correct_answer"
        case createdBy = "created_by"
    }
}
