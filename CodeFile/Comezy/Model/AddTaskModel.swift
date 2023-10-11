
import Foundation
struct AddTaskModel: Codable {
    var id: Int?
    var taskName, startDate, endDate, dataDescription: String?
    var documents: [String]?
    var project: Project?
    var occupation: AddTaskOccupation?
    var assignedWorker: AssignedWorker?
    var color: String?
    enum CodingKeys: String, CodingKey {
        case id
        case taskName = "task_name"
        case startDate = "start_date"
        case endDate = "end_date"
        case dataDescription = "description"
        case documents, project, occupation
        case assignedWorker = "assigned_worker"
        case color
    }
}
//struct Adddocuments: Codable{
//
//}

// MARK: - AssignedWorker
struct AssignedWorker: Codable {
    var id: Int?
    var firstName, lastName, email, phone: String?
    var profilePicture: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, phone
        case profilePicture = "profile_picture"
    }
}

// MARK: - Occupation
struct AddTaskOccupation: Codable {
    var id: Int?
    var name: String?
}

// MARK: - Project
struct Project: Codable {
    var id: Int?
    var name, createdDate, status, projectDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdDate = "created_date"
        case status
        case projectDescription = "description"
    }
}
