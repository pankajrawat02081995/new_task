//
//  NotificationsModel.swift
//  Comezy
//
//  Created by aakarshit on 13/07/22.
//

import Foundation

// MARK: - Welcome
struct AllNotificationsCountModel: Codable {
    let notificationCount: Int

    enum CodingKeys: String, CodingKey {
        case notificationCount = "notification_count"
    }
}

// MARK: - Welcome
struct AllNotifcationListModel: Codable {
    let next, previous: String
    let totalCount: Int
    let results: [AllNotifListResult]

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Result
struct AllNotifListResult: Codable {
    let id: Int
    let title, message, notificationType: String
    let projectID, receiverID, taskID, dailyID: Int
    let planID, productInformationID, variationID, roiID: Int
    let eotID, toolboxID, punchlistID, safety: Int
    let incidentReport, siteRisk: Int
    let senderID: SenderID

    enum CodingKeys: String, CodingKey {
        case id, title, message
        case notificationType = "notification_type"
        case projectID = "project_id"
        case receiverID = "receiver_id"
        case taskID = "task_id"
        case dailyID = "daily_id"
        case planID = "plan_id"
        case productInformationID = "product_information_id"
        case variationID = "variation_id"
        case roiID = "roi_id"
        case eotID = "eot_id"
        case toolboxID = "toolbox_id"
        case punchlistID = "punchlist_id"
        case safety
        case incidentReport = "incident_report"
        case siteRisk = "site_risk"
        case senderID = "sender_id"
    }
}

// MARK: - SenderID
struct SenderID: Codable {
    let id: Int
    let firstName, lastName: String
    let profilePicture: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePicture = "profile_picture"
    }
}

// MARK: - Welcome
struct NotificationCountClearModel: Codable {
    let notificationCount: Int

    enum CodingKeys: String, CodingKey {
        case notificationCount = "notification_count"
    }
}
