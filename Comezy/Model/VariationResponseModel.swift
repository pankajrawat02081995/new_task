//
//  VariationResponseModel.swift
//  Comezy
//
//  Created by aakarshit on 02/06/22.
//

import Foundation

struct VariationResponseModel: Codable {
    let status: String
    let code: Int
    let data: ResponseDataClass
    let message: String
}

// MARK: - DataClass
struct ResponseDataClass: Codable {
}
