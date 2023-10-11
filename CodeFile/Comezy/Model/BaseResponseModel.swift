//
//  BaseResponseModel.swift
//  Comezy
//
//  Created by MAC on 17/08/21.
//

import Foundation

struct BaseResponse<T>:Codable where T: Codable{
    let code:Int?
    let status:String?
    let message: String?
    let data: T?
}
