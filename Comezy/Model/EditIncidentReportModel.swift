//
//  EditIncidentReportModel.swift
//  Comezy
//
//  Created by aakarshit on 02/07/22.
//

import Foundation
// MARK: - Welcome
struct EditIncidentReportModel: Codable {
    let id: Int
    let timeOfIncidentReported, dateOfIncidentReported, dateOfIncident, timeOfIncident: String
    let reportCreatedDate, reportUpdatedDate, descriptionOfIncident, preventativeActionTaken: String
    let files: [String]
    let name, personCompletingFormWatch, witnessOfIncidentWatch: String
    let personCompletingForm, witnessOfIncident: EditIncidentCreatedBy
    let typeOfIncident: EditIncidentType
    let project: [EditIncidentProject]
    let createdBy: EditIncidentCreatedBy

    enum CodingKeys: String, CodingKey {
        case id
        case timeOfIncidentReported = "time_of_incident_reported"
        case dateOfIncidentReported = "date_of_incident_reported"
        case dateOfIncident = "date_of_incident"
        case timeOfIncident = "time_of_incident"
        case reportCreatedDate = "report_created_date"
        case reportUpdatedDate = "report_updated_date"
        case descriptionOfIncident = "description_of_incident"
        case preventativeActionTaken = "preventative_action_taken"
        case files, name
        case personCompletingFormWatch = "person_completing_form_watch"
        case witnessOfIncidentWatch = "witness_of_incident_watch"
        case personCompletingForm = "person_completing_form"
        case witnessOfIncident = "witness_of_incident"
        case typeOfIncident = "type_of_incident"
        case project
        case createdBy = "created_by"
    }
}

// MARK: - CreatedBy
struct EditIncidentCreatedBy: Codable {
    let id: Int
    let firstName, lastName, phone, email: String
    let profilePicture: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case phone, email
        case profilePicture = "profile_picture"
    }
}

// MARK: - Project
struct EditIncidentProject: Codable {
    let id: Int
    let name, createdDate, status, projectDescription: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdDate = "created_date"
        case status
        case projectDescription = "description"
    }
}

// MARK: - TypeOfIncident
struct EditIncidentType: Codable {
    let id: Int
    let name: String
}
