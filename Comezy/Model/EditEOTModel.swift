//
//  EditEOTModel.swift
//  Comezy
//
//  Created by aakarshit on 24/06/22.
//

import Foundation

// MARK: - Welcome
struct EditEOTModel: Codable {
    let id: Int
    let name, numberOfDays, reasonForDelay, extendDateFrom: String
    let extendDateTo, createdDate: String
    let sender: Int
    let receiver: [EOTReceiver]
    let project: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case numberOfDays = "number_of_days"
        case reasonForDelay = "reason_for_delay"
        case extendDateFrom = "extend_date_from"
        case extendDateTo = "extend_date_to"
        case createdDate = "created_date"
        case sender, receiver, project
    }
}
