//
//  CommonEnumFile.swift
//  Picker
//
//  Created by Developer IOS on 29/05/23.
//

import Foundation

//MARK: - STORYBOARD ENUM
enum Storyboards: String {
    case main = "Main"
    case loginSignUpFlow = "LoginSignupFlow"
    case home = "Home"
    case profile = "Profile"
    case bookings = "Bookings"
    case chats = "Chats"
    case properties = "Properties"
    case bookService = "BookService"
}

//MARK: - VIEWCONTROLLER ENUM
enum ViewControllers {
    static let loginVC = "LoginVC"
    static let forgotPasssVC = "ForgotPassVC"
    static let registerVC = "RegisterVC"
    static let otpVerificationVC = "OtpVerificationVC"
    static let createNewPassVC = "CreateNewPassVC"
    static let passwordSucessVC = "PasswordSucessVC"
    static let tabbarVC = "TabBarVC"
    static let addPropertyVC = "AddPropertyVC"
    static let addPropertyLocationVC = "AddPropertyLocationVC"
    static let propertyDetailsVC = "PropertyDetailsVC"
    static let editProfileVC = "EditProfileVC"
    static let paymentHistoryVC =  "PaymentHistoryVC"
    static let settingsVC = "SettingsVC"
    static let changePasswordVC = "ChangePasswordVC"
    static let deletePropertyAlertVC = "DeletePropertyAlertVC"
    static let verifyPasswordVC = "VerifyPasswordVC"
}

//MARK: - CELL CLASS NAME
enum CellClassName {
    static let onBoardingCVC = "OnBoardingCVC"
    static let servicesCVC = "ServicesCVC"
}

//MARK: - XIB ENUM
enum XibsName {
    static let navigationVw = "NavigationView"
}

//MARK: - API HEADER PARAMS ENUM
enum Param {
    static let contentType = "content-type"
    static let deviceId = "device-id"
    static let deviceType = "device-type"
    static let appVersion = "app-version"
    static let auth = "Authorization"
    static let appJson = "application/json"
    static let ios = "ios"
    static let timezone = "Timezone"
}

//MARK: - CUSTOM COLOR ENUM
enum CustomColor {
    static let border = "border"
    static let btnBgColor = "btnBgColor"
    static let headerBgColor = "headerBgColor"
    static let mainHeadingColor = "mainHeading"
    static let subHeadingColor = "subHeading"
    static let tfBgColor = "tfBgColor"
}

enum ButtonTitles {
    static let signIn = "Sign In"
    static let forogtPass = "Forgot Password?"
    static let register = "Register"
    static let sendOtp = "Send OTP"
    static let cont = "Continue"
    static let resend = "Resend"
    static let resetPass = "Reset Password"
}

enum LoginParam {
    static let email = "email"
    static let password = "password"
}

enum SignUpParam {
    static let email = "email"
    static let password = "password"
    static let otp = "otp"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let confirmPassword = "confirmPassword"
    static let fcmToken = "fcmToken"
    static let countryCode = "countryCode"
    static let mobile = "mobile"
    static let deviceType = "deviceType"
    static let deviceId = "deviceId"
    static let otpCode = "otpcode"
}
