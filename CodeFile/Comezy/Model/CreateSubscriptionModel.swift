// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct CreateSubscriptionModel: Codable {
    let status, id: String
    let createTime: String
    let links: [CreateSubscriptionLink]

    enum CodingKeys: String, CodingKey {
        case status, id
        case createTime = "create_time"
        case links
    }
}

// MARK: - Link
struct CreateSubscriptionLink: Codable {
    let href: String
    let rel, method: String
}
