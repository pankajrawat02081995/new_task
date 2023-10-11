// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct ScheduleModel: Codable {
    let next, previous: String
    let totalCount: Int
    let results: ScheduleResults

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Results
struct ScheduleResults: Codable {
    let noOfEvents: Int?

    let date,start_date, end_date, month: String?
    let schedule: [Schedule]?

    enum CodingKeys: String, CodingKey {
        case noOfEvents = "no_of_events"
        case date, start_date, end_date, month, schedule
    }
}

// MARK: - Schedule
struct Schedule: Codable {
    let id: Int?
    let taskName, startDate, endDate, scheduleDescription: String?
    let color: String?

    let documents: [String]?
    let project: Project
    var allDates: [String]?
    var position: Int?
    let worker_action: String?
    let complete_status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case taskName = "task_name"
        case startDate = "start_date"
        case endDate = "end_date"
        case scheduleDescription = "description"
        case allDates = "all_dates"
        case color, documents, project, position, complete_status, worker_action
        
    }
}
