//
//  TimesheetStatusModel.swift
//  Comezy
//
//  Created by shiphul on 29/12/21.
//

import Foundation
struct TimesheetSatusModel: Codable {
    var timesheet_status: String?

    enum CodingKeys: String, CodingKey {
        case timesheet_status = "timesheet_status"
    }
}
