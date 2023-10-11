//
//  UserDefaults.swift
//  PickerCustomer
//
//  Created by Developer IOS on 29/05/23.
//

import Foundation

var accessTokenSaved: String {
    get {
        return UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
    }
    set {
        UserDefaults.standard.setValue(newValue, forKey: "accessToken")
    }
}
var fName: String {
    get {
        return UserDefaults.standard.value(forKey: "fName") as? String ?? ""
    }
    set {
        UserDefaults.standard.setValue(newValue, forKey: "fName")
    }
}
var lName: String {
    get {
        return UserDefaults.standard.value(forKey: "lName") as? String ?? ""
    }
    set {
        UserDefaults.standard.setValue(newValue, forKey: "lName")
    }
}
var userProfileImg: String {
    get {
        return UserDefaults.standard.value(forKey: "userProfileImg") as? String ?? ""
    }
    set {
        UserDefaults.standard.setValue(newValue, forKey: "userProfileImg")
    }
}
