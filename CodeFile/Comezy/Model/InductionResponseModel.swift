//
//  InductionResponseModel.swift
//  Comezy
//
//  Created by aakarshit on 05/08/22.
//

import Foundation

struct InductionResponseElement: Codable {
    let id: Int
    let answer, createdDate: String
    let question: InductionResponseQuestion
    let answeredBy: Int

    enum CodingKeys: String, CodingKey {
        case id, answer
        case createdDate = "created_date"
        case question
        case answeredBy = "answered_by"
    }
}

// MARK: - Question
struct InductionResponseQuestion: Codable {
    let id: Int
    let question, correctAnswer: String

    enum CodingKeys: String, CodingKey {
        case id, question
        case correctAnswer = "correct_answer"
    }
}

typealias InductionResponseModel = [InductionResponseElement]

