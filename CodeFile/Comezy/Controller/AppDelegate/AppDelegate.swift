//
//  AppDelegate.swift
//  Comezy
//
//  Created by MAC on 08/07/21.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import FBSDKCoreKit
import GooglePlaces
import GoogleMaps
import FirebaseCore
import FirebaseDynamicLinks
import FirebaseMessaging
//import StripePaymentsUI


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let objVM = InductionQuestionsViewModel()
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FRPush.push.config()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        // 1
        UNUserNotificationCenter.current().delegate = self
        // 2
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions) { success, error in
              let settings: UIUserNotificationSettings =
                  UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
              
              //application.registerUserNotificationSettings(settings)
          }
  
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = ScreenManager.getRootViewController()
        self.window!.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
        AWSS3Manager.shared.initializeS3()
        IQKeyboardManager.shared.enable = true
        SocialLogin.shared.configureGoogleSignIn()
        self.setUpGoogleMaps()
        ApplicationDelegate.shared.application (
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        //StripeAPI.defaultPublishableKey = "pk_test_51BTUDGJAJfZb9HEBwDg86TN1KNprHjkfipXmEDMb0gSCassK5T3ZfxsAbcgKVmAIXF7oZ6ItlZZbXO6idTHE67IM007EwQ4uN3"
        
        return true
    }
    
    
    func setUpGoogleMaps() {
        GMSServices.provideAPIKey(App.GoogleMapApiKey)
        GMSPlacesClient.provideAPIKey(App.GoogleMapApiKey)
    }
    
    func application (
        _ app: UIApplication,
        open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
         
        
        ApplicationDelegate.shared.application (
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        
        
        
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance().handle(url)
        if handled {
            return true
        }
        
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            self.handleIncomingDynamicLink(dynamicLink)
            return true
        }
        
        // Handle other custom URL types.
        
        // If not handled by this app, return false.
        return false
    }
    
    
    func setSlideMenuController(_ menu:DKLeftMenu = .notifications){
        
        isFromMenu = false
        guard let mainViewController =  menu.navigationController else{return}
        let rightMenuViewController = UINavigationController.instance(from: .Main, withIdentifier: .kRightSlideNavigationController)
        //        let slideMenuController = JKSlideMenuController(mainViewController: mainViewController, rightMenuViewController: rightMenuViewController, enableRightPanGesture: false, enableRightTapGesture: true)
        let slideMenuController = JKSlideMenuController(mainViewController: mainViewController, leftMenuViewController: rightMenuViewController, enableLeftPanGeture: false, enableLeftTapGeture: true)
        self.window?.rootViewController  = slideMenuController
        
        
        // }
        
    }
    
    private func setupLandingScreen(){
        isFromMenu = false
        let signInNavigationController =  UINavigationController.instance(from: .Main, withIdentifier: .kLaunchNavigationController)
        self.window?.rootViewController = signInNavigationController
        //        self.window?.makeKeyAndVisible()
    }
    

    //MARK: handleIncomingDynamicLink
    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else {
            print("The dynamic link object has no url")
            return
        }
        print("Your incoming link parameter is\(url.absoluteString)")
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else { return }

        var invitedWorker = InvitePersonModel()
        for queryItem in queryItems {
            if queryItem.name == "first_name" {
                invitedWorker.firstName = queryItem.value
            }
            if queryItem.name == "last_name" {
                invitedWorker.lastName = queryItem.value
            }
            if queryItem.name == "contact" {
                invitedWorker.phone = queryItem.value
            }
            if queryItem.name == "type" {
                invitedWorker.userType = queryItem.value
            }
            if queryItem.name == "email" {
                invitedWorker.email = queryItem.value
            }
            if queryItem.name == "invited_id" {
                invitedWorker.inviteId = queryItem.value
            }
            if queryItem.name == "induction_url" {
                invitedWorker.inductionURL = queryItem.value
            }
            if queryItem.name == "project_id" {
                invitedWorker.projectID = queryItem.value
            }
            if queryItem.name == "owner_name" {
                invitedWorker.ownerName = queryItem.value
            }
            print("Parameter \(queryItem.name) has a value of \(queryItem.value ?? "")")
        }
        globalInvitedPerson = invitedWorker
        print("@@@Project Id on global invited person in App delegate ->",globalInvitedPerson?.projectID,globalInvitedPerson?.phone)
        isFromDynamicLink = true
        self.resetPref()
        self.setupLandingScreen()
        
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL {
            print("Incoming URL is \(incomingURL)")
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { dynamicLink, error in
                guard error == nil else {
                    print("Found an error!\(error!.localizedDescription)")
                    self.window?.rootViewController?.showToast(message: error!.localizedDescription)
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handleIncomingDynamicLink(dynamicLink)
                }
            }
            
            if linkHandled {
                return true
            } else {
                return false
            }
        }
        return false
    }


}

extension AppDelegate {
    class var shared:AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    //MARK:- signOut
    
    func signOut(){
        resetPref()
        showMainController()
    }
    
    func resetPref(){
     FRPush.push.subscribeTopic(false)
        UserDefaults.removeObject(forKey: kUserDataKey)
        UserDefaults.removeObject(forKey: kAuthTokenKey)
        usrProfileImage = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        
    }
    
    func showMainController() {
        
        if kAccessToken != nil && !kAccessToken!.isEmpty{
            setSlideMenuController()
        } else {
            self.resetPref()
            self.setupLandingScreen()
        }
        
    }
   
}


@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    

    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      willPresent notification: UNNotification,
      withCompletionHandler completionHandler:
      @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        var badgeCount = 0

        UIApplication.shared.applicationIconBadgeNumber += 1
        process(notification)
        

        if #available(iOS 14.0, *) {
            print("STEP1")

            completionHandler([[.banner, .sound]])
            print("STEP2")

        } else {
            print("STEP3")

            // Fallback on earlier versions
        }
    }

    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      didReceive response: UNNotificationResponse,
      withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        print("STEP4")
        process(response.notification)

      completionHandler()
    }
    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        print("Did Recieved",deviceToken)
     Messaging.messaging().apnsToken = deviceToken
     //   FRPush.push.subscribeTopic(true)

    }
    func application( _ application: UIApplication,
                      didFailToRegisterForRemoteNotificationsWithError error: Error){
        print("ERROR",error)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        var badgeCount = 0
        badgeCount = badgeCount + 1;
        application.applicationIconBadgeNumber = badgeCount

    }
    
    private func process(_ notification: UNNotification) {
      // 1
        let userInfo = notification.request.content.userInfo
        print("USERINFO",userInfo)
//      // 2
//      UIApplication.shared.applicationIconBadgeNumber = 0
//      if let newsTitle = userInfo["newsTitle"] as? String,
//        let newsBody = userInfo["newsBody"] as? String {
//        let newsItem = NewsItem(title: newsTitle, body: newsBody, date: Date())
//        NewsModel.shared.add([newsItem])
//      }
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("App became active")
           //   UIApplication.shared.applicationIconBadgeNumber = 0

    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("App is about to enter foreground")
     //   UIApplication.shared.applicationIconBadgeNumber=0

    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("app is in background")

    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("app is in terminate")

    }
}

extension AppDelegate: MessagingDelegate {
  func messaging(
    _ messaging: Messaging,
    didReceiveRegistrationToken fcmToken: String?
  ) {
    let tokenDict = ["token": fcmToken ?? ""]
      print(tokenDict)
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: tokenDict)
  }
}
