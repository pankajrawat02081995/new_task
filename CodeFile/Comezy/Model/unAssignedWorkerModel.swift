//
//  unAssignedWorkerModel.swift
//  Comezy
//
//  Created by amandeepsingh on 08/08/22.
//

import Foundation
struct unAssignedWorkerModel: Codable {
    let status: String
    let code: Int
    let data: unAssignedWorkeDataClass
    let message: String
}

// MARK: - DataClass
struct unAssignedWorkeDataClass: Codable {
}
