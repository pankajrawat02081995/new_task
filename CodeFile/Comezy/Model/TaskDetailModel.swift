// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your ProjectTask and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct TaskDetailModel: Codable {
    let id: Int
    let taskName, startDate, endDate, dataDescription: String
    let documents: [String]
    let project: ProjectTask
    let occupation: OccupationTask
    let assignedWorker: AssignedWorkerTask
    let workerAction, completeStatus, color: String

    enum CodingKeys: String, CodingKey {
        case id
        case taskName = "task_name"
        case startDate = "start_date"
        case endDate = "end_date"
        case dataDescription = "description"
        case documents, project, occupation
        case assignedWorker = "assigned_worker"
        case workerAction = "worker_action"
        case completeStatus = "complete_status"
        case color
    }
}

// MARK: - AssignedWorkerTask
struct AssignedWorkerTask: Codable {
    let id: Int
    let firstName, lastName, email, phone: String
    let profilePicture: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, phone
        case profilePicture = "profile_picture"
    }
}

// MARK: - OccupationTask
struct OccupationTask: Codable {
    let id: Int
    let name: String
}

// MARK: - ProjectTask
struct ProjectTask: Codable {
    let id: Int
    let name, createdDate, status, projectDescription: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdDate = "created_date"
        case status
        case projectDescription = "description"
    }
}
