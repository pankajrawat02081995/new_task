//
//  EditDailyLogModel.swift
//  Comezy
//
//  Created by shiphul on 30/12/21.
//

import Foundation

struct EditDailyLogModel: Codable {
    var id: Int?
    var createdTime, updatedTime: String?
    var location: EditLocation?
    var weather: EditWeather?
    var documents: [String]?
    var notes: String?
    var project: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case createdTime = "created_time"
        case updatedTime = "updated_time"
        case location, weather, documents, notes, project
    }
}

// MARK: - Location
struct EditLocation: Codable {
    let name: String
    let longitude, latitude: Double
}

// MARK: - Weather
struct EditWeather: Codable {
    let current, maximum, weatherType: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case current, maximum
        case weatherType = "weather_type"
        case icon
    }
}
