//
//  SubmitROIModel.swift
//  Comezy
//
//  Created by aakarshit on 16/06/22.
//

import Foundation

// MARK: - Welcome
struct SubmitROIModel: Codable {
    let status: String
    let code: Int
    let data: SubmitROIDataClass
    let message: String
}

// MARK: - DataClass
struct SubmitROIDataClass: Codable {
    let id: Int
    let infoResponse, action: String

    enum CodingKeys: String, CodingKey {
        case id
        case infoResponse = "info_response"
        case action
    }
}
