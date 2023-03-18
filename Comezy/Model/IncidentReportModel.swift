//// This file was generated from JSON Schema using quicktype, do not modify it directly.
//// To parse the JSON, add this file to your project and do:
////
////   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)
//
//import Foundation
//
//// MARK: - Welcome
//struct IncidentReportModel: Codable {
//    let next, previous: String
//    let totalCount: Int
//    let results: [IncidentResult]
//
//    enum CodingKeys: String, CodingKey {
//        case next, previous
//        case totalCount = "total_count"
//        case results
//    }
//}
//
//// MARK: - Result
//struct IncidentResult: Codable {
//    let id: Int
//    let personCompletingForm, witnessOfIncident: CreatedBy
//    let typeOfIncident: TypeOfIncident
//    let project: [IncidentProject]
//    let createdBy: IncidentCreatedBy
//    let timeOfIncidentReported, dateOfIncidentReported, dateOfIncident, timeOfIncident: String
//    let reportCreatedDate, reportUpdatedDate, descriptionOfIncident, preventativeActionTaken: String
//    let files: [String]
//    let name, personCompletingFormWatch, witnessOfIncidentWatch: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case personCompletingForm = "person_completing_form"
//        case witnessOfIncident = "witness_of_incident"
//        case typeOfIncident = "type_of_incident"
//        case project
//        case createdBy = "created_by"
//        case timeOfIncidentReported = "time_of_incident_reported"
//        case dateOfIncidentReported = "date_of_incident_reported"
//        case dateOfIncident = "date_of_incident"
//        case timeOfIncident = "time_of_incident"
//        case reportCreatedDate = "report_created_date"
//        case reportUpdatedDate = "report_updated_date"
//        case descriptionOfIncident = "description_of_incident"
//        case preventativeActionTaken = "preventative_action_taken"
//        case files, name
//        case personCompletingFormWatch = "person_completing_form_watch"
//        case witnessOfIncidentWatch = "witness_of_incident_watch"
//    }
//}
//
//// MARK: - CreatedBy
//struct IncidentCreatedBy: Codable {
//    let id: Int
//    let firstName: FirstName
//    let lastName: LastName
//    let phone: Phone
//    let email: String
//    let profilePicture: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case phone, email
//        case profilePicture = "profile_picture"
//    }
//}
//
//
//enum FirstName: String, Codable {
//    case edward = "Edward"
//    case finn = "Finn"
//    case test = "Test"
//}
//
//enum LastName: String, Codable {
//    case developer = "Developer"
//    case miller = "Miller"
//    case peden = "Peden"
//}
//
//enum Phone: String, Codable {
//    case empty = ""
//    case the8083492345 = "8083492345"
//    case the9023139935 = "9023139935"
//}
//
//// MARK: - Project
//struct IncidentProject: Codable {
//    let id: Int
//    let name, createdDate, status, projectDescription: String
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case createdDate = "created_date"
//        case status
//        case projectDescription = "description"
//    }
//}
//
//// MARK: - TypeOfIncident
//struct TypeOfIncident: Codable {
//    let name: String
//    let id: Int
//}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)



import Foundation

// MARK: - Welcome
struct IncidentReportModel: Codable {
    let next, previous: String?
    let totalCount: Int?
    let results: [IncidentResult]

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Result
struct IncidentResult: Codable {
    let id: Int?
    let personCompletingForm, witnessOfIncident: IncidentCreatedBy?
    let typeOfIncident: TypeOfIncident?
    let project: [IncidentProject?]
    let created_by: IncidentCreatedBy?
    let timeOfIncidentReported, dateOfIncidentReported, dateOfIncident, timeOfIncident: String?
    let reportCreatedDate, reportUpdatedDate, descriptionOfIncident, preventativeActionTaken: String?
    let files: [String?]
    let name, personCompletingFormWatch,visitor_witness, visitor_witness_phone, witnessOfIncidentWatch: String?

    enum CodingKeys: String, CodingKey {
        case id
        case personCompletingForm = "person_completing_form"
        case witnessOfIncident = "witness_of_incident"
        case typeOfIncident = "type_of_incident"
        case project
        case created_by = "created_by"
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
        case visitor_witness = "visitor_witness"
        case visitor_witness_phone = "visitor_witness_phone"
    }
}

// MARK: - CreatedBy
struct IncidentCreatedBy: Codable {
    let id: Int?
    let firstName, lastName, phone, email: String?
    let profilePicture: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case phone, email
        case profilePicture = "profile_picture"
      
    }
}

// MARK: - Project
struct IncidentProject: Codable {
    let id: Int?
    let name, createdDate, status, projectDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdDate = "created_date"
        case status
        case projectDescription = "description"
    }
}

// MARK: - TypeOfIncident
struct TypeOfIncident: Codable {
    let name: String?
    let id: Int?
}

