//
//  AddDailyLogModel.swift
//  Comezy
//
//  Created by shiphul on 23/12/21.
//

import Foundation

struct AddDailyLogModel: Codable {
    var id: Int?
    var createdTime: String?
    var location: myLocation?
    var weather: myWeather?
    var updatedTime: String?
    var documents: [String]?
    var notes: String?
    var project: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case createdTime = "created_time"
        case location, weather
        case updatedTime = "updated_time"
        case documents, notes, project
    }
}

// MARK: - Location
struct myLocation: Codable {
    let name: String
    let longitude, latitude: Double
}

// MARK: - Weather
struct myWeather: Codable {
    let current, maximum, weatherType: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case current, maximum
        case weatherType = "weather_type"
        case icon
    }
}
