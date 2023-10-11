//
//  DailyLogListModel.swift
//  Comezy
//
//  Created by shiphul on 23/12/21.
//

import Foundation

struct DailyLogListModel: Codable {
    var next, previous: String?
    var totalCount: Int?
    var results: [DailyLogResult]?

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Result
struct DailyLogResult: Codable {
    var id: Int?
    var createdTime: String?
    var location: Location?
    var weather: Weather?
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
struct Location: Codable {
    var name: String?
    var longitude, latitude: Double?
}

// MARK: - Weather
struct Weather: Codable {
    let current, maximum, weatherType: String?
    let icon: String?

    enum CodingKeys: String, CodingKey {
        case current, maximum
        case weatherType = "weather_type"
        case icon
    }
    func getImage()->String{

            switch icon {

            case "http://openweathermap.org/img/wn/01d@2x.png":

                return "01d"

            case "http://openweathermap.org/img/wn/01n@2x.png":

                return "01n"

            

            case "http://openweathermap.org/img/wn/02n@2x.png":

                return "02n"

            case "http://openweathermap.org/img/wn/03d@2x.png":

                return "03d"

            case "http://openweathermap.org/img/wn/10n@2x.png":

                return "10n"

            

            case "http://openweathermap.org/img/wn/10d@2x.png":

                return "10d"

            case  "http://openweathermap.org/img/wn/13d@2x.png" :

                return "13d"

            case  "http://openweathermap.org/img/wn/13n@2x.png":

                return "13n"

            case  "http://openweathermap.org/img/wn/04d@2x.png":

                return "4d"

                

            case  "http://openweathermap.org/img/wn/04n@2x.png":

                return "4n"

            case  "http://openweathermap.org/img/wn/50d@2x.png":

                return "50d"

            case   "http://openweathermap.org/img/wn/50n@2x.png":

                return "50n"

            case   "http://openweathermap.org/img/wn/09d@2x.png" :

                return "9d"

            case     "http://openweathermap.org/img/wn/09n@2x.png" :

                return "9n"

            default :

                return "02d"

            

        }

    }
}
