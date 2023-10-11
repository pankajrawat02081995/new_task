//
//  NotificationBadgeCountModel.swift
//  Comezy
//
//  Created by aakarshit on 15/07/22.
//

import Foundation

// MARK: - Welcome
struct NotificationBadgeCountModel: Codable {
    let allCount: AllCount

    enum CodingKeys: String, CodingKey {
        case allCount = "all_count"
    }
}

// MARK: - AllCount
struct AllCount: Codable {
    let plan: Int
    let docs: Docs
    let people: Int
    let daily: Daily
}

// MARK: - Daily
struct Daily: Codable {
    let dailyTotal, task, schedule, dailyWorkReport: Int

    enum CodingKeys: String, CodingKey {
        case dailyTotal = "daily_total"
        case task, schedule
        case dailyWorkReport = "daily_work_report"
    }
}

// MARK: - Docs
struct Docs: Codable {
    let docsTotal, variations, specificationsAndProductInformation: Int
    let safety: Safety
    let general: General
    

    enum CodingKeys: String, CodingKey {
        case docsTotal = "docs_total"
        case specificationsAndProductInformation = "specifications_and_product_information"
        case safety, general, variations
    }
}

// MARK: - General
struct General: Codable {
    let generalTotal, toolbox, roi: Int
    let eot, punchlist: Int

    enum CodingKeys: String, CodingKey {
        case generalTotal = "general_total"
        case toolbox, roi, eot, punchlist
    }
}

// MARK: - Safety
struct Safety: Codable {
    let safetyTotal, safeWorkMethodStatement, materialSafetyDataSheets, workHealthAndSafetyPlan: Int
    let siteRiskAssessment, incidentReport: Int

    enum CodingKeys: String, CodingKey {
        case safetyTotal = "safety_total"
        case safeWorkMethodStatement = "safe_work_method_statement"
        case materialSafetyDataSheets = "material_safety_data_sheets"
        case workHealthAndSafetyPlan = "work_health_and_safety_plan"
        case siteRiskAssessment = "site_risk_assessment"
        case incidentReport = "incident_report"
    }
}
