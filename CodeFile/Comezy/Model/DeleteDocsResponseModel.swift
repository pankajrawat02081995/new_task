//
//  DeleteDocsResponeModel.swift
//  Comezy
//
//  Created by amandeepsingh on 06/07/22.
//

import Foundation
struct DeleteDocsResponseModel: Codable {
    let status: String
    let code: Int
    let data: DeleteDocsResponseDataClass
    let message: String
}

// MARK: - DataClass
struct DeleteDocsResponseDataClass: Codable {
}
