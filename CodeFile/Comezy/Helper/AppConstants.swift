//
//  AppConstants.swift
//  Picker
//
//  Created by Developer IOS on 29/05/23.
//

import Foundation
import UIKit

final class Constantss {
    private init() {}
    
    //MARK: - VARIABLE DECLERATION
    static let shared = Constantss()
    let jsonDecoder = JSONDecoder()
    let jsonEncoder = JSONEncoder()
    
    let arrTitles = ["Edit Profile", "Payment History", "Settings", "Change Password", "Delete Account", "Logout"]
    let arrImages = [UIImage.init(named: "ic_profile_1"), UIImage.init(named: "ic_clock"), UIImage.init(named: "ic_settings"),UIImage.init(named: "ic_change_password"), UIImage.init(named: "ic_delete_account"), UIImage.init(named: "ic_logout")]
    
    let arrSttings = ["Manage Notifications", "Terms & Conditions"]
    
    //MARK: - APP INFO
    enum AppInfo {
        static let alert = "Alert!"
    }
    //MARK: - APP ALERT MESSAGES
    enum AlertMessages {
        static let okay = "Ok"
        static let checkInternet = "Please check your internet connection"
        static let noInternetConnection = "No Internet connection! Please check your Internet connectivity."
        static let pleaseReviewyournetworksettings = "Please Review your network settings"
        static let serverNotResponding = "Server not responding"
        static let cameraPermissionNotAccess = "Camera access required for capturing photos!"
        static let settingPermission = "This app needs permission to use this feature. You can grant them in app settings"
        static let sessionExpire = "Session expired please login again."
        static let logoutMsg = "Are you sure you want to logout?"
        static let deleteMsg = "Are you sure you want to delete account?"
        static let connectionWasLost = "The network connection was lost"
    }
    //MARK: - ALERT BUTTONS TITLE
    enum AlertButtonsTitle {
        static let okay = "Ok"
        static let cancel = "Cancel"
        static let setting = "Setting"
        static let camera = "Camera"
        static let gallery = "Gallery"
        static let important = "IMPORTANT"
        static let allowCamera = "Allow Camera"
        static let cameraNotSupported = "Camera not supported"
        static let grantPermissions = "Grant Permissions"
        static let error = "Error"
    }
    //MARK: - VALIDATION MESSAGES
    enum ValidationMessages {
        static let connectionProblem = "Connection Problem"
        static let inValidEmail = "Please enter valid email address."
        static let enterEmail = "Please enter email address."
        static let enterPassword = "Please enter password."
        static let enterName = "Please enter name."
        static let selectImage = "Please upload profile image."
        static let enterConfirmPassword = "Please enter confirm password."
        static let passwordMismatch = "Password and confirm password should be same."
        static let passwordNotCorrect = "Please enter valid password"
        static let enterOldPassword = "Please enter old password."
        static let enterNewPassword = "Please enter new password."
        static let enterFirstName = "Please enter first name."
        static let enterLastName = "Please enter last name."
        static let acceptTermsCond = "Please accept Terms of Services and Privacy Policy"
        static let enrerValidOtp = "Please enter valid OTP"
        static let enterPhoneNum = "Please enter phone number"
        static let enterOtp = "Please enter OTP"
        static let passInValid = "Please enter valid password"
        static let enterYourPassword = "Please enter your current password"
        static let enterAddress = "Please enter your address"
        static let enterAddressName = "Please enter your address name"
    }
    
    //MARK: - CONSTANT TEXT's
    enum ConstantText {
        static let welcomeMsg = "Welcome back!"
        static let gladToSee = "Glad to see you, Again!"
        static let completeWelcomMsg = "Welcome back! Glad to see you, Again!"
        static let forgotPass = "Forgot Password?"
        static let forgot = "Forgot"
        static let registerMsg = "Hello! Register to get started"
        static let hello = "Hello!"
        static let createNewPass = "Create New Password"
        static let create = "Create"
        static let otpVerification = "OTP Verification"
        static let otp = "OTP"
        static let resend = "Resend"
    }
    
    
    struct OnBoardingData{
        struct onBoardingItem{
            var title : String
            var desc : String
            var image : UIImage
        }
        
        static let data:[onBoardingItem] =
        
        [onBoardingItem(title: "Welcome to\nPicker", desc: "Your One-Stop Destination for On-Demand\nServices!", image: UIImage(named: "ic_onBoard_1")!),
         onBoardingItem(title: "Your Reliable\nService Partner", desc: "Get the Job Done Quickly and Conveniently\nat your Fingertips.", image: UIImage(named: "ic_onBoard_2")!),
         onBoardingItem(title: "Let Us Handle\nthe Mess", desc: "Out of Sight, Out of Mind - Clear Your\nClutter Today.", image: UIImage(named: "ic_onBoard_3")!)]

        
    }
    
}
