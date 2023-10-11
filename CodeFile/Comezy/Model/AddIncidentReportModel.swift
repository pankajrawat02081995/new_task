//
//  AddIncidentReportModel.swift
//  Comezy
//
//  Created by aakarshit on 01/07/22.
//

import Foundation
// MARK: - Welcome
struct AddIncidentReportModel: Codable {
    let id: Int?
    let timeOfIncidentReported, dateOfIncidentReported, dateOfIncident, timeOfIncident: String?
    let reportCreatedDate, reportUpdatedDate, descriptionOfIncident, visitor_witness, visitor_witness_phone, preventativeActionTaken: String?
    let files: [String?]
    let name, personCompletingFormWatch, witnessOfIncidentWatch: String?
    let personCompletingForm, witnessOfIncident, typeOfIncident, project: Int?
    let createdBy: Int?

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
        case visitor_witness = "visitor_witness"
        case visitor_witness_phone = "visitor_witness_phone"
    }
}
