//
//  CancelSubscriptionResponse.swift
//  Comezy
//
//  Created by amandeepsingh on 08/08/22.
//

import Foundation
struct CancelSubscriptionModel: Codable {
    let status: String
    let code: Int
    let data: CancelSubscriptionDataClass
    let message: String
}

// MARK: - DataClass
struct CancelSubscriptionDataClass: Codable {
}
