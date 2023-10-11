//
//  App.swift
//  InsuranceCalculator
//
//  Created by MAC on 29/04/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation
import UIKit

class App {
    static let name = "Build Ezi"
    static let screenSize = UIScreen.main.bounds
    static var GoogleMapApiKey = "AIzaSyASUD6NnLrVXVSmvtE-adHIsg0duOGrBfA"

    class Fonts {
        class Poppins {
            static let light = "Montserrat-Light"
            static let regular = "Montserrat-Regular"
            static let bold = "Montserrat-Bold"
            static let semiBold = "Montserrat-SemiBold"
        }
    }
    
    class Colors {
        static let red = UIColor(named: "red")
        static let appColor = UIColor(named: "AppColor")
        static let appGreenColor = UIColor(named: "AppGreenColor")
        static let appOrangeColor = UIColor(named: "AppOrangeColor")
        static let appBlueColor = UIColor(named: "AppBlueColor")
        static let backColor =  UIColor(red: 248/255.0, green: 249/255.0, blue: 251/255.0, alpha: 1.0)
    }
    
    
    
    

    
    //MARK:- Token & Keys -
    class AccessKeys {
        static let authunticationToken = ""
        static var deviceToken = ""
    }
    
    class Images {
        static let notificationIcon = UIImage(named: "notification-solid")
        static let personCircleIcon = UIImage(named: "account_circle")
        static let calendarIcon = UIImage(named: "calendar-1")
        static let archiveIcon = UIImage(named: "archive")
        static let clockIcon = UIImage(named: "clock")
        static let deleteIcon = UIImage(named: "delete")
        static let crossMarkIcon = UIImage(named: "cross_mark")
        static let logoutIcon = UIImage(systemName: "power.circle.fill")!.withTintColor(App.Colors.appGreenColor!, renderingMode: .alwaysOriginal)
    }
    
}

//MARK:- API's -
class API {
    static let productionURL = "http://3.21.238.163:8001/"

// static let devURL = "http://10.20.1.105:9000/"
    static let devURL = "https://api.buildezi.com/"
    static let loginApi = "accounts/token-auth/"
    static let registerApi = "accounts/register/"
    static let getOccupationList = "accounts/occupation/?size=1000&page=1"
    static let addOccupation = "accounts/occupation/?"
    static let getForgotPassLink = "accounts/password_reset/"
    static let projectListApi = "api/project/?"//status=in_progress"
    static let clientListApi = "api/client/?search="
    static let addProjectApi = "api/project/"
    static let retrieveProjectDetail = "api/project/retrieve/?project_id="
    static let getPlansList = "projectplans/plan/"
    static let getDocsList = "projectdocs/document/"
    static let addPlan = "projectplans/plan/"
    static let addDocs = "projectdocs/document/"
    static let addVariations = "projectdocs/variation/"
    static let getPeopleList = "api/project/"
    static let getIncidentType = "projectdocs/incidenttype/"
    static let getAllPeopleList = "api/project/projectusers/?project_id="
    static let getUnassignedWorkerList = "api/project/"
    static let getAddUnassignedWorker = "api/project/addworker?"
    static let getTaskList = "api/project/"
    static let getTaskDetail = "projecttasks/task/retrieve/?task_id="
    static let addTaskList = "projecttasks/task/"
    static let getDailyLogList = "projectdailylogs/dailylog/"
    static let getTaskResponse = "projecttasks/task/"
    static let addDailyLog = "projectdailylogs/dailylog/"
    static let editDailyLog = "projectdailylogs/dailylog/update/"
    static let getCommentList = "projectcomments/comment/"
    static let addCommentList = "projectcomments/comment/"
    static let getTimesheetStatus = "projecttimesheets/timesheet/status/"
    static let getStartTimesheet = "projecttimesheets/timesheet/start/"
    static let getEndTimesheet = "projecttimesheets/timesheet/end/"
    static let getTimesheetList = "projecttimesheets/timesheet/"
    static let getVariationsList = "projectdocs/variation/?"
    static let getVariationDetail = "projectdocs/variation/retrieve/?variation_id="
    static let getVariationResponse = "projectdocs/variation/"
    static let updateVariation = "projectdocs/variation/update/?variation_id="
    static let deleteVariation = "projectdocs/variation/?variation_id="
    static let getROIList = "projectdocs/roi/?"
    static let getROIDetail = "projectdocs/roi/retrieve/?roi_id="
    static let deleteROI = "projectdocs/roi/?roi_id="
    static let addROI = "projectdocs/roi/"
    static let editROI = "projectdocs/roi/update/?roi_id="
    static let submitROI = "projectdocs/roi/submit/?roi_id="
    static let getPunchList = "projectdocs/punchlist/?size=1000&page=1&project_id="
    static let getPunchDetail = "projectdocs/punchlist/retrieve/?punchlist_id="
    static let markCompletion = "projectdocs/punchlist/"
    static let addPunch = "projectdocs/punchlist/"
    static let editPunch = "projectdocs/punchlist/update/?punchlist_id="
    static let deletePunch = "projectdocs/punchlist/?punchlist_id="
    static let getEOTList = "projectdocs/eot/?size=1000&page=1&project_id="
    static let getEOTDetail = "projectdocs/eot/retrieve/?eot_id="
    static let submitEOT = "projectdocs/eot/accept/?eot_id="
    static let addEOT = "projectdocs/eot/"
    static let editEOT = "projectdocs/eot/update/?eot_id="
    static let getToolBoxTalkList = "projectdocs/toolbox/?"
    static let getToolBoxDetail = "projectdocs/toolbox/retrieve/?toolbox_id="
    static let getToolBoxResponse = "projectdocs/toolbox/"
    static let addToolBox = "projectdocs/toolbox/"
    static let editToolBox = "projectdocs/toolbox/update/?toolbox_id="
    static let getSafetyList = "projectdocs/safety/?"
    static let deleteSafety = "projectdocs/safety/?safety_id="
    static let addSafety = "projectdocs/safety/"
    static let editSafety = "projectdocs/safety/update/?safety_id="
    static let getIncidentReportList = "projectdocs/incidentreport/?"
    static let addIncidentReport = "projectdocs/incidentreport/?"
    static let deleteIncidentReport = "projectdocs/incidentreport/?incident_report_id="
    static let deleteEOT = "projectdocs/eot/?eot_id="
    static let editIncident = "projectdocs/incidentreport/update/?incident_report_id="
    static let getSiteRiskAssesment = "projectdocs/siteriskassessment/?"
    static let getAddSiteRiskQuestions = "projectdocs/siteriskassessmentquestion/?"
    static let deleteToolbox = "projectdocs/toolbox/?toolbox_id="
    static let getSiteRiskAssessmentBanner = "projectdocs/siteriskassessmentrelation/?"

    static let deleteDocument = "projectdocs/document/?document_id="
    static let editDocs = "projectdocs/document/update/?document_id="


    static let addRiskAssessment = "projectdocs/siteriskassessment/"
	
    static let addSiteRiskAssessment = "projectdocs/siteriskassessment/"
    static let siteRiskResponse = "projectdocs/siteriskassessment/response/"
    static let getAllNotificationsCount = "projectnotifications/fcm/count/?"
    static let getAllNotificationList = "projectnotifications/fcm/?"
    static let clearAllNotificationCount = "projectnotifications/fcm/countclear/?"
    static let updatedTimeSheet="projecttimesheets/timesheet/edit/?"
    static let getBadgeCount = "api/project/count/?project_id="
    static let clearBadgeCount = "api/project/countclear/?project_id="
    static let getArchiveList = "api/project/archivelist/?page=1&size=1000"
    static let editPlan = "projectplans/plan/update/?plan_id="
    static let deletePlan = "projectplans/plan/?plan_id="

    static let changePassword = "accounts/changepassword/"

    static let invitePerson = "accounts/invite/"
    static let getInductionQuestions = "accounts/inductionquestion/?size=1000&page=1"
    static let updateProfile = "accounts/profiledetails/update/"
    static let sendInviteMail = "accounts/invite/email/?"
    static let createSubscription = "accountspayments/subscription/"
    static let sendSubscribedUser = "accountspayments/payment/"
    static let profileDetail = "accounts/profiledetails/"
    static let cancelSubscription = "accountspayments/subscription/cancel/"
    static let unAssignedWorker = "api/project/removeworker/?project_id="
    static let sendInductionResponse = "accounts/inductionresponse/?"
    static let getInductionResponse = "accounts/inductionresponse/?"
    static let getSchedule = "projecttasks/task/schedule/?"
    static let getSubscriptionId="accountspayments/payment/"
    static let deleteAccount="accounts/register/"
    static let getInvoiceList="invoice/invoices/list"
    static let createInvoice="invoice/invoices/create/"
    static let reactivateSubscription = "accountspayments/subscription/activate/?subscription_id="


}
struct UserDefaultConst {
    static let location = "location"
    static let userOccupation = "userOccupation"
    
}

class Constants {
    static let shared = Constants()
    var deviceToken = ""
    var deviceType = "iOS"
    static var FirestoreAppStatusId = "wTBmkujMo3Fp4ipQ6ebu"
    static var FirestoreCollection = "app_status"
    static var DocumentField = "isLive"
    static var thousand = 1000
}

struct FieldValidation {
    //LoginSignup
    
    static let kFirstName = "First name should be less then or equals to 16 characters"
    static let kLastName = "Last name should be less then or equals to 16 characters"
    static let kFirstNameEmpty       = "Please enter your first name."
    static let kLastNameEmpty       = "Please enter your last name."
    static let kEmailEmpty      = "Please enter your email address."
    static let kUsernameEmpty      = "Please enter your username."
    static let kUsernameValidation      = "Username cannot contain spaces."
    static let kGender      = "Please select Gender first."
    static let kValidEmail      = "Please enter a valid email address."
    static let kPasswordEmpty   = "Please enter your password."
    static let kOccupationEmpty       = "Please select your occupation."
    static let kPhoneEmpty       = "Please enter your phone number."
    static let kValidPhone      = "Please enter valid phone number. Phone number should me between 10 to 13 characters."
    static let kCompanyNameEmpty       = "Please enter your company name."
    static let kSignatureEmpty       = "Please enter your signature."
    static let kBuilderAddressEmpty       = "Please enter builder address."
    static let kAbnEmpty       = "Please enter ABN number."
    static let kInvalidAbnEmpty       = "Please enter valid ABN number. ABN number should be of 11 characters."
    
    static let kTradingLicenseEmpty = "Please upload your Trading License"
    static let kSafetyCardEmpty = "Please upload your Safety Card."
    static let kvalidPassword = "The password should be at least 8 digits in combination of lower case, upper case, numbers and special characters.."
    static let kPasswordsUnmatch       = "Passwords do not match."
    static let kPasswordsLength       = "Password must be minimum 8 characters long."
    
    //CreateAudio
    static let kTitleEmpty       = "Please enter the title."
    static let kGenreEmpty       = "Please select a genre first."
    static let kAudioEmpty       = "Please select an audio first."
    static let kCoverEmpty       = "Please select a cover Image."
    
    //AddProjects
    static let kNameEmpty       = "Please enter your project name"
    static let kAddressEmpty       = "Please enter your address"
    static let kClient       = "Client should be selected"
    static let kProjectDetailEmpty       = "Please enter project details"
    static let kQuatationPresentationPDFEmpty       = "Quatation presentation PDF is empty"
    static let kScopeOfWorkEmpty       = "Scope of work is empty"
    static let kAddPeople = "Add people to the project"
    
    //AddPlans
    static let kPlanNameEmpty       = "Please enter a plan name"
    static let kDescriptionEmpty       = "Please enter a plan description"
    static let KfileEmpty = "Please add a plan file"
    
    //AddDocs
    static let kDocNameEmpty       = "Please enter name"
    static let kDocDescriptionEmpty       = "Please enter description"
    static let KDocfileEmpty = "Please select a file"
    static let kDocSupplierEmpty       = "Please enter supplier detail"
    
    //AddVariation
    static let kVariationTitleEmpty = "Please enter title"
    static let kVariationFromEmpty = "Please select \"From\""
    static let kVariationToEmpty = "Please select \"To\""
    static let kVariationSummaryEmpty = "Please enter summary"
    static let kVariationDocumentEmpty = "Please select a document"
    static let kVariationPriceEmpty = "Please enter price"

    
    //AddTask
    static let kTaskNameEmpty   = "Please enter task name"
    static let kStart_DateEmpty   = "Please enter start date"
    static let kEnd_DateEmpty   = "Please enter end date"
    static let kTaskDescriptionEmpty   = "Please enter task description"
    static let kAssignedWorkerEmpty   = "Please add workers"
    static let koccupationEmpty     = "please add worker's occupation"
    
    //AddDailyLog
    static let kLocationEmpty   = "Please enter location"
    static let kNotesEmpty   = "Please enter notes"
    static let kDocumentEmpty   = "Please upload documents"
    
    //AddROI
    static let kROITitleEmpty = "Please enter ROI title"
    static let kROIInfoNeededEmpty = "Please enter Information needed"
    
    //AddPunch
    static let kAddPunchTitleEmpty = "Please enter a title"
    static let kAddPunchDescriptionEmpty = "Please enter a description"
    static let kAddPunchChecklistEmpty = "Please enter all checklists"
    static let kAddPunchChecklistCountZero = "Please add atleast one checklist"
    
    //AddEOT
    
    static let kAddEOTTitleEmpty = "Please enter a title"
    static let kAddEOTReasonForDelay  = "Please enter a reason for delay"
    static let kAddEOTNumberOfDays = "Please enter number of days"
    static let kAddEOTExtendedFromDate = "Please choose a extended from date"
    static let kAddEOTExtendedToDate = "Please choose a extended to date"
    
    //AddToolbox
    static let kAddTBTitle = "Please enter a title"
    static let kAddTopicOfDiscussion  = "Please enter a topic of discussion"
    static let kAddRemedies = "Please enter remedy"
    static let kfileEmpty = "Please select a file"
    
    //Invite Person
    static let kInvitePersonFirstName = "Please enter a first name"
    static let kInvitePersonLastName = "Please enter a last name"
    static let kInvitePersonPhoneName = "Please enter phone number"

    static let kInvitePersonEmail = "Please enter an email"
    
    //Safety
    static let kSafetyDesctipn = "Please enter description"
    
    ///Incident Report Validatopm
    static let kIncidentReportName = "Please enter a name"
    static let kIncidentReportedDate = "Please enter date of incident Reported"
    static let kIncidentDate = "Please enter date of Incident"
    static let kIncidentType = "Please select type of incident"
    static let kIncidentTime = "Please enter time of incident"
    static let kIncidentDesc = "Please enter description of incident"
    static let kIncidentPrevAct =  "Please enter preventive action taken"
    static let kIncidentPerCompleteForm =   "Please select person completing form"
    static let kIncidentSelecWitness =   "Please select witness of incident"
    static let kIncidentVisitorWitnessName =   "Please enter witness name"
    static let kIncidentVisitorWitnessPhone =   "Please enter witness phone"
    static let selectIncidentDate = "Please select Date of Incident first"
    
    //Site Risk Assessment Validation
    static let kAddOneQuestion = "Please add atleast one question"
    static let kAddProof = "Please add proof before submission"


}
struct fileUploadPopUp {
    static let kUploadFile = "Upload a file"
    static let kChooseFromGallery = "Choose From Gallery"
    static let kChooseADocument = "Choose A Document"
    static let kTakeAPhoto = "Take A Photo"
    static let kChooseAOption = "Please choose a option"
}
struct commmentSectionMessage {
    static let writeComment = "Write a comment here"
    static let cantPostEmptyComment = "Cannot post an empty comment"
    
}
struct DateTimeFormat{
    static let kTimeSheetDateTimeFormat = "yyyy-MM-dd HH:mm:ss"
    static let kTimeSheetDateFormat = "yyyy-MM-dd"
    static let kTrailEndedTimeFormat = "yyyy-MM-dd"
    static let kyy_MM_dd = "yyyy-MM-dd"
    
    static let kSpecificationDateFormat = "yyyy-MM-dd HH:mm:ss"
    static let kDateTimeFormat = "yyyy-MM-dd HH:mm:ss"
    static let kEE_MMM_d = "EE, MMM d"
    static let kTimeHH_mm_SS = "HH:mm:SS"

}
struct localeIdentifier {
    static let en_USA = "en_US_POSIX"
}
struct IncidentTypeList {
    static let incidentType = ["Minor-no loss of work", "Minor- went home for day", "Minor- went to doctor", "Medium- work days lost", "Medium- hospital required", "Medium- Ambulance called", "Major- Hospital stay required"]
}
struct colorString {
    static let AppBrightGreenColor = "AppBrightGreenColor"
}
struct SuccessMessage{
    static let kTimeSheetUpdate = "Timesheet updated successfully"
    static let kFileUpload = "file uploaded successfully"
    static let kProductAdded = "Product information added successfully"
    static let kSafetyWorkUpdated = "Safety Work Method updated successfully"
    static let kSafetyWorkAdded = "Safety Work Method added successfully"
    static let kWorkHealthSafetyUpdated = "Work Health Safety updated successfully"
    static let kWorkHealthSafetyAdded = "Work Health Safety added successfully"
    static let kSafetyUpdated = "Material Safety updated successfully"
    static let kSafetyAdded = "Material Safety added successfully"
    static let kIncidentReportAdded = "Incident report added successfully"
    static let kIncidentReportEdit = "Incident report edit successfully"
    static let kSiteRiskAdded =  "Site Risk Assessment added successfully"
    static let kRoiAdded =   "Request for Information updated successfully"
    static let kPausedSuccess =   "You have successfully paused the project."
    static let kResumeSuccess =   "You have successfully resume the project."
    static let kCompletedSuccess =   "You have successfully completed the project."
    static let kPasswordChangeSuccess =   "Password changes successfully"
    static let kPlanUpdated = "Plan updated successfully"
    static let kProjectAdded = "Project added successfully"
    static let kProjectAddedWorker = "Project has been added successfully, now let's add people to the project"
    static let kDailyLogAdded =  "DailyLog added successfully"
    static let kDailyLogUpdate =  "DailyLog updated successfully"
    static let kCommentSuccess =  "Comment added successfully"
    static let kResponseSubmitted = "Response submitted succesfully"



}
struct AppConstant {
    static let SUBSCRIPTION_PLAN_ID = "P-91X92397YH477180NMM3AUTI"
    static let RETURN_URL = "https://example.com/returnUrl"
    static let CANCEL_URL = "https://example.com/cancelUrl"
    static let REGULAR = "REGULAR"
    static let TRIAL = "TRIAL"
    static let NO_ACTIVE_PLAN = "NO_ACTIVE_PLAN"
    
    static let STRIPE_RETURN_URL = "http://ec2-3-21-238-163.us-east-2.compute.amazonaws.com:8001/accountspayments/stipe_success"
    static let STRIPE_CANCEL_URL = "http://ec2-3-21-238-163.us-east-2.compute.amazonaws.com:8001/accountspayments/stripe_cancel"


}

struct K {
    static let appStoreId = "1632089570"
    static let fallBackURL = "https://buildezii.page.link/NLtk"
    static let inductionURL = "https://docs.google.com/document/d/151ukKWq3nP7TmPR2CEvYYhxOetC5CK_RheK_2fd_FAw/export?format=pdf"
    static let dynamicLinkPrefix = "https://buildezii.page.link"
    static let androidPackageName = "com.buildezi.app"

}

struct Ntype {
    static let inviteAcceptedClient = "invite_accepted_client"
}

struct FailureMessage{
    static let kPasswordChangeFailure =   "Change password request is failed"
    static let kErrorOccured = "Error Occured"


}
struct ProjectProgressType {
    static let kInProgress = "inProgress"
    static let kPaused = "paused"
    static let kCompleted = "completed"
    static let kArchived = "archived"
}

struct UserType {
    static let kOwner = "builder"
    static let kClient = "client"
    static let kWorker = "worker"
}

struct AWSFileDirectory{
    static let PUBLIC = "public/"
    static let PROFILE_FOLDER = "profileImages/"
            static let PROFILE_IMAGE = "profile_"
            static let SIGNATURE_FOLDER = "signatureImages/"
            static let SIGNATURE_IMAGE = "signature_"
            static let QUOTATION_FOLDER = "quotationFiles/"
            static let QUOTATION_FILE = "quotation_"
            static let TASK_FOLDER = "taskFiles/"
            static let TASK_FILE = "task_"
            static let SOW_FOLDER = "sowFiles/"
            static let SOW_FILE = "sow_"
            static let PLAN_FOLDER = "planFiles/"
            static let PLAN_FILE = "plan_"
            static let SPECIFICATION_FOLDER = "specificationFiles/"
            static let SPECIFICATION_FILE = "specification_"
            static let VARIATION_FOLDER = "variationFiles/"
            static let VARIATION_FILE = "variation_"
            static let GENERAL_FOLDER = "generalFiles/"
            static let GENERAL_FILE = "general_"
            static let SAFETY_FOLDER = "safetyFiles/"
            static let SAFETY_FILE = "safety_"
            static let DAILY_LOG_DOCUMENT_FOLDER = "dailyLogDocumentFiles_/"
            static let DAILY_LOG_DOCUMENT_FILE = "dailyLogDocument_"
            static let REQUEST_OF_INFORMATION_FOLDER = "requestOfInformationFiles/"
            static let REQUEST_OF_INFORMATION_FILE = "requestOfInformation_"
            static let EXTENSION_OF_TIME_FOLDER = "extensionOfTimeFiles/"
            static let EXTENSION_OF_TIME_FILE = "extensionOfTime_"
            static let PUNCH_FOLDER = "punchFiles/"
            static let PUNCH_FILE = "punch_"
            static let TOOLBOX_FOLDER = "toolBoxTalkFiles/"
            static let TOOLBOX_FILE = "toolBoxTalk_"
            static let SAFETY_WORK_METHOD_FOLDER = "safetyWorkMethodFiles/"
            static let SAFETY_WORK_METHOD_FILE = "safetyWorkMethod_"
            static let MATERIAL_SAFETY_DATA_SHEET_FOLDER = "materialSafetySheetFiles/"
            static let MATERIAL_SAFETY_DATA_SHEET_FILE = "materialSafetySheet_"
            static let WORK_HEALTH_SAFETY_PLAN_FOLDER = "workHealthSafetyPlanFiles/"
            static let WORK_HEALTH_SAFETY_PLAN_FILE = "workHealthSafetyPlan_"
            static let SITE_RISK_ASSESSMENT_FOLDER = "siteRiskAssessmentFiles/"
            static let SITE_RISK_ASSESSMENT_FILE = "siteRiskAssessment_"
            static let INCIDENT_FOLDER = "incidentReportFiles/"
            static let INCIDENT_FILE = "incidentReportPlan_"
            static let SAFETY_CARD_FOLDER = "safetyCardFiles/"
            static let SAFETY_CARD_FILE = "safetyCard_"
            static let TRADING_LICENSE_FOLDER = "tradingLicenseFiles/"
            static let TRADING_LICENSE_FILE = "tradingLicenseCard_"
            
}

struct StoryboardID:RawRepresentable,Hashable {
    
    static let KSignInNavigationController             = StoryboardID(rawValue: "SignInNavigationController")
    static let kAccountInfoNavigationController        = StoryboardID(rawValue:"AccountInfoNavigationController")
    static let kMyProjectsNavigationController         = StoryboardID(rawValue:"MyProjectsNavigationController")
    static let kTimeZoneNavigationController           = StoryboardID(rawValue:"TimeZoneNavigationController")
    static let kNotificationNavigationController       = StoryboardID(rawValue:"NotificationNavigationController")
    static let kChangePassswordNavigationController    = StoryboardID(rawValue:"ChangePassswordNavigationController")
    static let kLaunchNavigationController             = StoryboardID(rawValue:"LaunchNavigationController")
    static let kSignUpNavigationController             = StoryboardID(rawValue:"SignUpNavigationController")
    static let kRightSlideNavigationController         = StoryboardID(rawValue:"RightSlideNavigationController")
    static let kProjectDetailController                = StoryboardID(rawValue: "")
    static let kTimeSheetCellController                = StoryboardID(rawValue: "TimesheetCell")
    
    var rawValue: String
    init(rawValue: String) {
        self.rawValue = rawValue
    }
}
struct SiteRiskListConst{
    static let statusYes = "yes"
    static let statusNo = "no"
    static let statusPending = "Pending"
    
}

struct StoryBoardIdentifier{
    static let kTimeSheetCellController = "TimesheetCell"
    static let kAddVariationDocCellController = "AddVariationDocCell"
}


public struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
    static public var isPhone:Bool {UIDevice.current.userInterfaceIdiom == .phone}
    static public var isPad:Bool {UIDevice.current.userInterfaceIdiom == .pad}
    static public var isLandscape:Bool{UIDevice.current.orientation.isLandscape}
    static public var isPortrait:Bool{UIDevice.current.orientation.isPortrait}
}

public struct fileType {
    static let pdf = "PDF"
    static let doc = "DOC"
    static let docs = "DOCX"
}
struct imageFile {
    static let imgPdf = "ic_pdf"
    static let imgdoc =  "ic_doc"
    static let noPath =  "NoPath - Copy (19)"
}
struct cellSize {
    static let size: CGFloat = 330
    static let Hundered: CGFloat = 100
    static let SiteRiskBannerSize: CGFloat  = 120
    static let TimesheetCell: CGFloat = 47
}
