//
//  TimesheetListModel.swift
//  Comezy
//
//  Created by shiphul on 30/12/21.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct TimesheetListModel: Codable {
    let status: String
    let code: Int
    let data: TimesheetListModelDataClass
    let message: String
}

// MARK: - DataClass
struct TimesheetListModelDataClass: Codable {
    let next, previous: String
    let totalCount: Int
    let results: [TimesheetListModelResult]

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Result
struct TimesheetListModelResult: Codable {
    let id: Int
    let dateAdded, startTime, endTime: String
    let location: Location
    let workedHours: String

    enum CodingKeys: String, CodingKey {
        case id
        case dateAdded = "date_added"
        case startTime = "start_time"
        case endTime = "end_time"
        case location
        case workedHours = "worked_hours"
    }
}

// MARK: - Location
struct TimesheetListModelLocation: Codable {
    let name: String
    let longitude, latitude: Double
}
