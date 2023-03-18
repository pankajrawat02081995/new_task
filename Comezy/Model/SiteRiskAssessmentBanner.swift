//
//  SiteRiskAssessmentBanner.swift
//  Comezy
//
//  Created by prince on 26/01/23.
//

import Foundation
struct SiteRiskAssessmentBannerResponse: Codable {
    let next, previous: String?
    let totalCount: Int?
    let results: [SiteRiskAssessmentBannerResponseResult]

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}
struct SiteRiskAssessmentBannerResponseResult: Codable {
    let id: Int?
    let createdBy: SiteRiskAssessmentBannerCreatedBy
    let createdDate, updatedDate: String?
    let siteRiskAssessmentList: [SiteRiskAssessmentBannerList]

    enum CodingKeys: String, CodingKey {
        case id
        case createdBy = "created_by"
        case createdDate = "created_date"
        case updatedDate = "updated_date"
        case siteRiskAssessmentList = "site_risk_assessment_list"
    }
}

// MARK: - CreatedBy
struct SiteRiskAssessmentBannerCreatedBy: Codable {
    let id: Int?
    let firstName, lastName, email, phone: String?
    let profilePicture: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, phone
        case profilePicture = "profile_picture"
    }
}

// MARK: - SiteRiskAssessmentList
struct SiteRiskAssessmentBannerList: Codable {
    let id: Int?
    let uploadFile: String?
    let assignedTo: SiteRiskAssessmentBannerCreatedBy
    let project: SiteRiskAssessmentBannerListProject
    let file, statusOption: String?
    let question: SiteRiskAssessmentBannerListQuestion
    let response: String?

    enum CodingKeys: String, CodingKey {
        case uploadFile = "upload_file"
        case assignedTo = "assigned_to"
        case project, file
        case statusOption = "status_option"
        case question, response,id
    }
}

// MARK: - Project
struct SiteRiskAssessmentBannerListProject: Codable {
    let id: Int?
    let name, createdDate, status, description: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdDate = "created_date"
        case status, description
    }
}

// MARK: - Question
struct SiteRiskAssessmentBannerListQuestion: Codable {
    let id: Int?
    let question: String?
}


