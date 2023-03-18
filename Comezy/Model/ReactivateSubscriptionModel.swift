//
//  ReactivateSubscriptionModel.swift
//  Comezy
//
//  Created by amandeepsingh on 01/10/22.
//

import Foundation

// MARK: - Welcome
struct ReactivateSubscriptionModel: Codable {
    let status: String
    let code: Int
    let data: ReactivateSubscriptionModelDataClass
    let message: String
}

// MARK: - DataClass
struct ReactivateSubscriptionModelDataClass: Codable {
}

