//
//  SendSubscribedUserModel.swift
//  Comezy
//
//  Created by amandeepsingh on 07/08/22.
//

import Foundation
struct SendSubscribedUserModel: Codable {
    let id: Int
    let status: String
    let startTime, createTime, statusUpdateTime: String
    let planOverridden: Bool
    let updateTime: String
    let user: Int
    let plan, subscription: String
    let subscriber, billingInfo: Int

    enum CodingKeys: String, CodingKey {
        case id, status
        case startTime = "start_time"
        case createTime = "create_time"
        case statusUpdateTime = "status_update_time"
        case planOverridden = "plan_overridden"
        case updateTime = "update_time"
        case user, plan, subscription, subscriber
        case billingInfo = "billing_info"
    }
}
