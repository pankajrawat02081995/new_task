//
//  TaskListModel.swift
//  Comezy
//
//  Created by shiphul on 20/12/21.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct TaskListModel: Codable {
    var next: String?
    var previous: String?
    var totalCount: Int?
    var results: [TaskResult]?

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Result
struct TaskResult: Codable {
    var taskName, resultDescription: String?
    var assignedWorker: TaskAssignedWorker?
    var id: Int?
    var startDate, endDate: String?

    enum CodingKeys: String, CodingKey {
        case taskName = "task_name"
        case resultDescription = "description"
        case assignedWorker = "assigned_worker"
        case id
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

// MARK: - AssignedWorker
struct TaskAssignedWorker: Codable {
    var id: Int?
    var firstName, lastName, phone, email: String?
    var profilePicture: String?
    var occupation: TaskOccupation?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case phone, email
        case profilePicture = "profile_picture"
        case occupation
    }
}

// MARK: - Occupation
struct TaskOccupation: Codable {
    var id: Int?
    var name: String?
}
