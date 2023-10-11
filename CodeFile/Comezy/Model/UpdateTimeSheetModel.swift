//
//  UpdateTimeSheetModel.swift
//  Comezy
//
//  Created by amandeepsingh on 16/07/22.
//

import Foundation
struct UpdateTimeSheetModel: Codable {
    let endTime, startTime: String

    enum CodingKeys: String, CodingKey {
        case endTime = "end_time"
        case startTime = "start_time"
    }
}
