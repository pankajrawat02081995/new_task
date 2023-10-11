//
//  DKLeftSlideMenuController.swift
//  Doctalkgo
//
//  Created by Jitendra Kumar on 12/08/20.
//  Copyright © 2020 Jitendra Kumar. All rights reserved.
//

import UIKit

enum DKLeftMenu:String {
    case notifications
    case archiveJob
    case deleteJob
    case accountInfo
    case invitationList
      case cancelSubscription
    case logout
    
    var title:String{
        switch self {
        case .notifications:      return "Notifications"
        case .archiveJob :       return "Archive Job"
        case .deleteJob :     return "Delete Job"
        case .accountInfo: return "Account Info"
        case .invitationList:   return "Invitation List"
              case .cancelSubscription:         return "Cancel Subscription"

        case .logout:         return "Logout"
        
        }
    }
    
    var icon:UIImage{
   
        switch self {
        case .notifications :       return App.Images.notificationIcon!
        case .archiveJob :         return App.Images.archiveIcon!
        case .deleteJob :        return App.Images.deleteIcon!
        case .accountInfo:    return App.Images.personCircleIcon!
        case .invitationList:  return App.Images.personCircleIcon!
        case .cancelSubscription:    return App.Images.crossMarkIcon!
        case .logout:            return App.Images.logoutIcon

        }
    }
    
    var navigationController:UINavigationController?{
        switch self {
        case .notifications:
            return UINavigationController.instance(from:.Main, withIdentifier: .kMyProjectsNavigationController)
        case .archiveJob:
           return UINavigationController.instance(from:.Main, withIdentifier: .kMyProjectsNavigationController)
        case .deleteJob:
            return UINavigationController.instance(from:.Main, withIdentifier: .kMyProjectsNavigationController)
        case .accountInfo:
            return UINavigationController.instance(from:.Main, withIdentifier: .kMyProjectsNavigationController)
        case .invitationList:
            return UINavigationController.instance(from:.Main, withIdentifier: .kMyProjectsNavigationController)
        default: return  nil
            
        }
    }
}

enum DKLeftMenuWorker:String {
    case notifications
    case leaveJob
    case accountInfo
    case logout
    
    var title:String{
        switch self {
        case .notifications:      return "Notifications"
        case .accountInfo: return "Account Info"
        case .logout:         return "Logout"
        case .leaveJob:  return "Leave Job"
        }
    }
    
    var icon:UIImage {
   
        switch self {
        case .notifications :       return App.Images.notificationIcon!
        case .accountInfo:    return App.Images.personCircleIcon!
        case .logout:           return App.Images.logoutIcon
        case .leaveJob:        return App.Images.calendarIcon!
        }
    }
    
    var navigationController:UINavigationController?{
        switch self {
        case .notifications:
            return UINavigationController.instance(from:.Main, withIdentifier: .kMyProjectsNavigationController)
        case .leaveJob:
            return UINavigationController.instance(from:.Main, withIdentifier: .kMyProjectsNavigationController)
        case .accountInfo:
            return UINavigationController.instance(from:.Main, withIdentifier: .kMyProjectsNavigationController)
//            return UINavigationController.instance(from:.Main, withIdentifier: .kNotificationNavigationController)
        default: return  nil
            
        }
    }
}

enum DKLeftMenuClient: String {
    case notifications
    case accountInfo
  //  case cancelSubscription
    case logout
    
    var title:String{
        switch self {
        case .notifications:      return "Notifications"
        case .accountInfo: return "Account Info"
      //  case .cancelSubscription:         return "Cancel Subscription"
        case .logout:         return "Logout"

        }
    }
    
    var icon:UIImage {
   
        switch self {
        case .notifications :       return App.Images.notificationIcon!
        case .accountInfo:    return App.Images.personCircleIcon!
       // case .cancelSubscription:    return App.Images.crossMarkIcon!
        case .logout:            return UIImage(systemName: "power.circle.fill")!.withTintColor(App.Colors.appGreenColor!, renderingMode: .alwaysOriginal)
        }
    }
    
    var navigationController:UINavigationController?{
        switch self {
        case .notifications:
            return UINavigationController.instance(from:.Main, withIdentifier: .kMyProjectsNavigationController)
        case .accountInfo:
            return UINavigationController.instance(from:.Main, withIdentifier: .kMyProjectsNavigationController)
//            return UINavigationController.instance(from:.Main, withIdentifier: .kNotificationNavigationController)
        default: return  nil
            
        }
    }
}
//MARK: DKLeftSlideMenu VC
class DKLeftSlideMenuController: UIViewController {
    
    var loggedInUserOcc = ""
    var objCancelSubscriptionViewModel = CancelSubscriptionViewModel()
    @IBOutlet private weak var patientIDlbl: UILabel!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var namelbl: UILabel!
    @IBOutlet private weak var versionlbl: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerview: UIView!
    @IBOutlet weak var UsrImgView: UIImageView!
    fileprivate var menulist:[DKLeftMenu] =
    [.notifications, .archiveJob, .deleteJob, .invitationList, .accountInfo, .logout]
    fileprivate var menulistWorker:[DKLeftMenuWorker] = [.notifications, .leaveJob, .accountInfo, .logout]
    fileprivate var menulistOwnerSubscribed: [DKLeftMenu] = [.notifications, .archiveJob, .deleteJob, .invitationList, .accountInfo,.cancelSubscription,.logout]
    fileprivate var menulistSubscribedClient: [DKLeftMenuClient] = [.notifications, .accountInfo, .logout]

    private var userViewModel = UserViewModel.shared //UserViewModel.shared
    private var objAllNotifVM = NotificationsViewModel()
    private var notifCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWindowLevel()
        // Do any additional setup after loading the view.
    }
    
    var keyWindow:UIWindow?{
        if #available(iOS 13, *) {
            return UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        }else{
            return UIApplication.shared.keyWindow
        }
        
    }
    
    private func setWindowLevel() {
        if let window  =  self.keyWindow{
            window.windowLevel = UIWindow.Level.normal
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        loggedInUserOcc = UserDefaults.getString(forKey: "userOccupation")
        loggedInUserOcc = kUserData?.user_type ?? ""
        print(kUserData?.occupation)
        self.loadProfileData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //tableView.updateHeaderHeight()
    }
    @IBAction func btnCancel_action(_ sender: Any) {
        self.toggleRight()
        
        let vc = UINavigationController.instance(from:.Main, withIdentifier: .kMyProjectsNavigationController)
            
        slideMenuController()?.changeMainViewController(mainViewController: vc, close: true)
        
    }
    
    private func loadProfileData(){
        
        
        if let url = URL(string: (kUserData?.profile_picture ?? "")){
            UsrImgView.kf.setImage(with: url)
        } else {
            UsrImgView.image = UIImage(systemName: "person.crop.circle.fill")

        } 
        objAllNotifVM.getAllNotificationsCount { success, resp, errorMsg in
            if success {
                self.notifCount = resp?.notificationCount ?? 0
                self.tableView.reloadData()
                print(self.notifCount)
            }
        }
        //if !userViewModel.profileImg.isEmpty {
        //userImageView.loadImage(source: userViewModel.profileImg)
        //}
        //        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        //        versionlbl.text = "Version: " + (appVersion ?? "")
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension DKLeftSlideMenuController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loggedInUserOcc == UserType.kOwner{
           // return menulist.count
            if(kUserData?.is_subscription == AppConstant.REGULAR){
            return menulistOwnerSubscribed.count
            }else{
                return menulist.count

            }
        } else if loggedInUserOcc == UserType.kWorker {
            return menulistWorker.count
        } else {
                return menulistSubscribedClient.count
        }
                    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if loggedInUserOcc == UserType.kOwner {
            let cell = tableView.dequeue(DKLeftMenuCell.self, for: indexPath)
            print(indexPath.row)
            
            
            if(kUserData?.is_subscription == AppConstant.REGULAR){
            cell.iconView.image = menulistOwnerSubscribed[indexPath.row].icon
            cell.titlelbl.text = menulistOwnerSubscribed[indexPath.row].title
            print(indexPath.row)
            }
            else {
                cell.iconView.image = menulist[indexPath.row].icon
                cell.titlelbl.text = menulist[indexPath.row].title
                print(indexPath.row)
            }
            
            if notifCount > 0 && indexPath.row == 0  {
//                print(cell.item?.title, indexPath.row)
                cell.lblNotificationCount.text = "\(notifCount)"
                cell.lblNotificationCount.isHidden = false
            } else {
                cell.lblNotificationCount.isHidden = true
            }
            // cell.selectionStyle = .blue
            return cell
        } else if loggedInUserOcc == UserType.kWorker {
            let cell = tableView.dequeue(DKLeftMenuCell.self, for: indexPath)
            
            cell.titlelbl.text = menulistWorker[indexPath.row].title
            cell.iconView.image = menulistWorker[indexPath.row].icon
            print(indexPath.row)
            if notifCount > 0 && indexPath.row == 0  {
//                print(cell.item?.title, indexPath.row)
                cell.lblNotificationCount.text = "\(notifCount)"
                cell.lblNotificationCount.isHidden = false
            } else {

                cell.lblNotificationCount.isHidden = true
            }
            return cell
        } else {
           
            let cell = tableView.dequeue(DKLeftMenuCell.self, for: indexPath)
//            if(kUserData?.is_subscription == AppConstant.REGULAR){
//            cell.iconView.image = menulistClient[indexPath.row].icon
//            cell.titlelbl.text = menulistClient[indexPath.row].title
//            print(indexPath.row)
//            }
//            else {
//                cell.iconView.image = menulistSubscribedClient[indexPath.row].icon
//                cell.titlelbl.text = menulistSubscribedClient[indexPath.row].title
//                print(indexPath.row)
//            }
//                    print(cell.item?.title, indexPath.row)
            cell.iconView.image = menulistSubscribedClient[indexPath.row].icon
            cell.titlelbl.text = menulistSubscribedClient[indexPath.row].title
            if notifCount > 0 && indexPath.row == 0  {
                cell.lblNotificationCount.text = "\(notifCount)"
                cell.lblNotificationCount.isHidden = false
            } else {
                cell.lblNotificationCount.isHidden = true
            }
            
            return cell
            }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 //return UITableView.automaticDimension
    }
    
    
}
//MARK: TableView Delegates
extension DKLeftSlideMenuController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? DKLeftMenuCell else { return  }
        cell.isHighlighted = true
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? DKLeftMenuCell else { return  }
        cell.isHighlighted = false
    }
    /* func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
     guard let cell = tableView.cellForRow(at: indexPath) as? DKLeftMenuCell else { return  }
     cell.isSelected = false
     }*/
    
    //MARK: Did Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if loggedInUserOcc == UserType.kOwner {
            let type: DKLeftMenu
            if(kUserData?.is_subscription == AppConstant.REGULAR){
                         type  = menulistOwnerSubscribed[indexPath.row]
                        }else{
                             type  = menulist[indexPath.row]
            
                        }
            switch type {
            case .notifications:
                guard let navigation = type.navigationController else{return}
                navigation.title = type.title
                navigation.topViewController?.navigationItem.title = type.title
                isFromMenu = true
                isFromNotifOnSlideMenu = true
    //            let vc = ScreenManager.getController(storyboard: .main, controller: NotificationListVC()) as! NotificationListVC
                slideMenuController()?.changeMainViewController(mainViewController: navigation, close: true)
            case .archiveJob:
                guard let navigation = type.navigationController else{return}
                navigation.title = type.title
                navigation.topViewController?.navigationItem.title = type.title
                isFromMenu = true
                isFromArchivOnSlideMenu = true
    //            let vc = ScreenManager.getController(storyboard: .main, controller: NotificationListVC()) as! NotificationListVC
                slideMenuController()?.changeMainViewController(mainViewController: navigation, close: true)
                

            case .deleteJob:
                guard let navigation = type.navigationController else {return}
                navigation.title = type.title
                navigation.topViewController?.navigationItem.title = type.title
                isFromMenu = true
                isFromDeleteOnSlideMenu = true
    //            let vc = ScreenManager.getController(storyboard: .main, controller: NotificationListVC()) as! NotificationListVC
                slideMenuController()?.changeMainViewController(mainViewController: navigation, close: true)
                
            case .accountInfo:
//                showWorkInProgress()
                guard let navigation = type.navigationController else {return}
                navigation.title = type.title
                navigation.topViewController?.navigationItem.title = type.title
                isFromMenu = true
                isFromAccountInfo = true
    //            let vc = ScreenManager.getController(storyboard: .main, controller: NotificationListVC()) as! NotificationListVC
                slideMenuController()?.changeMainViewController(mainViewController: navigation, close: true)
                
            case .invitationList:
                guard let navigation = type.navigationController else {return}
                navigation.title = type.title
                navigation.topViewController?.navigationItem.title = type.title
                isFromMenu = true
                isFromInviteOnSlideMenu = true
    
                slideMenuController()?.changeMainViewController(mainViewController: navigation, close: true)
            case .cancelSubscription:
                self.showAppAlert(title: "Cancel Subscription", message: "Do you want to cancel the subscription") {
                    self.objCancelSubscriptionViewModel.getSubscriptionId()
                { success, response, message in
                if success {
                    
                    print(response![0].subscription)
                    self.objCancelSubscriptionViewModel.cancelSubscription(subscriptionId: response![0].subscription)
                { success, response, message in
                if success {
                    tableView.reloadData()
                    self.toggleRight()
                    let vc = UINavigationController.instance(from:.Main, withIdentifier: .kMyProjectsNavigationController)
                        
                    self.slideMenuController()?.changeMainViewController(mainViewController: vc, close: true)
                    self.showToast(message: "Unsubscribed Successfully")
                }else{
                    self.showToast(message: message!)

                }}}
                    else{
                        self.showToast(message: message!)

                    }}}
                
            case .logout:
                self.showAppAlert(title: "Logout", message: "Do you want to logout?") {
                    //self.userViewModel.logout {
                    AppDelegate.shared.signOut()
    //                DispatchQueue.main.async {
    //                    AppDelegate.shared.signOut()
    //                }
                    //}
                    
                    
                }
                self.toggleRight()
        }
      
        /* guard let cell = tableView.cellForRow(at: indexPath) as? DKLeftMenuCell else { return  }
         cell.isSelected = true
         */
        
        } else if loggedInUserOcc == UserType.kWorker {
            let type  = menulistWorker[indexPath.row]
            switch type {
            case .notifications:
                guard let navigation = type.navigationController else{return}
                navigation.title = type.title
                navigation.topViewController?.navigationItem.title = type.title
                isFromMenu = true
                isFromNotifOnSlideMenu = true
    //            let vc = ScreenManager.getController(storyboard: .main, controller: NotificationListVC()) as! NotificationListVC
                slideMenuController()?.changeMainViewController(mainViewController: navigation, close: true)
            case .accountInfo:
                guard let navigation = type.navigationController else {return}
                navigation.title = type.title
                navigation.topViewController?.navigationItem.title = type.title
                isFromMenu = true
                isFromAccountInfo = true
    //            let vc = ScreenManager.getController(storyboard: .main, controller: NotificationListVC()) as! NotificationListVC
                slideMenuController()?.changeMainViewController(mainViewController: navigation, close: true)
                
            case .logout:
                self.showAppAlert(title: "Logout", message: "Do you want to logout?") {
                    //self.userViewModel.logout {
                    AppDelegate.shared.signOut()
    //                DispatchQueue.main.async {
    //                    AppDelegate.shared.signOut()
    //                }
                    //}
                }
                self.toggleRight()
            case .leaveJob:
                guard let navigation = type.navigationController else {return}
                navigation.title = type.title
                navigation.topViewController?.navigationItem.title = type.title
                isFromMenu = true
                isFromLeaveOnSlideMenu = true
    //            let vc = ScreenManager.getController(storyboard: .main, controller: NotificationListVC()) as! NotificationListVC
                slideMenuController()?.changeMainViewController(mainViewController: navigation, close: true)
        }
      
        /* guard let cell = tableView.cellForRow(at: indexPath) as? DKLeftMenuCell else { return  }
         cell.isSelected = true
         */
        
        } else {
        let type: DKLeftMenuClient
//            if(kUserData?.is_subscription == AppConstant.REGULAR){
//             type  = menulistClient[indexPath.row]
//            }else{
//                 type  = menulistSubscribedClient[indexPath.row]
//
//            }
            type  = menulistSubscribedClient[indexPath.row]

            switch type {
            case .notifications:
                guard let navigation = type.navigationController else{return}
                navigation.title = type.title
                navigation.topViewController?.navigationItem.title = type.title
                isFromMenu = true
                isFromNotifOnSlideMenu = true
    //            let vc = ScreenManager.getController(storyboard: .main, controller: NotificationListVC()) as! NotificationListVC
                slideMenuController()?.changeMainViewController(mainViewController: navigation, close: true)
//            case .cancelSubscription:
//                self.showAppAlert(title: "Cancel Subscription", message: "Do you want to cancel the subscription") {
//                    self.objCancelSubscriptionViewModel.getSubscriptionId()
//                { success, response, message in
//                if success {
//
//                    print(response![0].subscription)
//                    self.objCancelSubscriptionViewModel.cancelSubscription(subscriptionId: response![0].subscription)
//                { success, response, message in
//                if success {
//                    tableView.reloadData()
//                    self.toggleRight()
//                    let vc = UINavigationController.instance(from:.Main, withIdentifier: .kMyProjectsNavigationController)
//
//                    self.slideMenuController()?.changeMainViewController(mainViewController: vc, close: true)
//                    self.showToast(message: "Unsubscribed Successfully")
//                }else{
//                    self.showToast(message: message!)
//
//                }}}
//                    else{
//                        self.showToast(message: message!)
//
//                    }}}
            case .accountInfo:
                guard let navigation = type.navigationController else {return}
                navigation.title = type.title
                navigation.topViewController?.navigationItem.title = type.title
                isFromMenu = true
                isFromAccountInfo = true
    //            let vc = ScreenManager.getController(storyboard: .main, controller: NotificationListVC()) as! NotificationListVC
                slideMenuController()?.changeMainViewController(mainViewController: navigation, close: true)
                
            case .logout:
                self.showAppAlert(title: "Logout", message: "Do you want to logout?") {
                    //self.userViewModel.logout {
                    AppDelegate.shared.signOut()
    //                DispatchQueue.main.async {
    //                    AppDelegate.shared.signOut()
    //                }
                    //}
                }
                self.toggleRight()
        }
        }
}
}
