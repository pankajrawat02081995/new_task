//
//  UserDataModel.swift
//  SoundTide
//
//  Created by archie on 31/03/21.
//

import Foundation

struct UserDataModel: DictionaryEncodable {
    var userEmail : String?
    var firstName: String?
    var lastName: String?
    var profileImage: String?
    var socialLoginId: String?
    var socialType: String?
}
