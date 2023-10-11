//
//  NotificationListVC.swift
//  Comezy
//
//  Created by aakarshit on 14/07/22.
//

import UIKit
import Kingfisher

class NotificationListVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
//        let signInNavigationController =  UINavigationController.instance(from: .Main, withIdentifier: .kMyProjectsNavigationController)
//        AppDelegate.shared.window?.rootViewController = signInNavigationController
        // Do any additional setup after loading the view.
    }
    
    
    var loggedInUserOcc: String?
    var ProjectId: Int?
    let objVM = NotificationsViewModel()
    var myList = [AllNotifListResult]()
    
    @IBOutlet weak var lblNoROI: UILabel!
    @IBOutlet weak var tblROIs: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(ProjectId as Any, "Printing project ID from <============== ROI VC")
           UIApplication.shared.applicationIconBadgeNumber=0

        getDocsListDetails()
        
        loggedInUserOcc = kUserData?.user_type ?? ""
        
    }
    
    func getDocsListDetails() {
        
        self.objVM.getAllNotifList() { (success, resp, error) in
                if success {
                    self.myList = resp?.results ?? []
                    self.NoDocs()
                    DispatchQueue.main.async {
                        self.tblROIs.reloadData()
                    }
                    
                    self.objVM.clearAllNotifCount { success, resp, errorMsg in
                        if success {
                            print("Notifications cleared")
                        }
                    }
                    
                } else {
                    self.showAlert(message: error)
                }
            }
        }
    
    func NoDocs(){
        if myList.count == 0{
            lblNoROI.isHidden = false
            tblROIs.isHidden = true
        }else{
            lblNoROI.isHidden = true
            tblROIs.isHidden = false
        }
    }
   
    @IBAction func btnBack_action(_ sender: Any) {
//        let vc = UINavigationController.instance(from:.Main, withIdentifier: .kMyProjectsNavigationController)
//        slideMenuController()?.changeMainViewController(mainViewController: vc, close: true)
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnHome_action(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    

}

extension NotificationListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        let item = myList[indexPath.row]
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        cell.lblName.text = item.senderID.firstName + " " + item.senderID.lastName
        if let url = URL(string: item.senderID.profilePicture) {
            cell.imgView.kf.setImage(with: url)
        }
        cell.imgView.contentMode = .scaleAspectFill
        cell.lblNotification.text = item.message
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        let date = dateFormatter.date(from: item.createdDate ?? "")!
//        dateFormatter.dateFormat = "EE, MMM d"
//        dateFormatter.locale = tempLocale // reset the locale
//        let dateString = dateFormatter.string(from: date)
//        print("EXACT_DATE : \(dateString)")
        return cell
    }
    
    //MARK: Did select
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        slideMenuController()?.toggleLeft()
//        let vc = ScreenManager.getController(storyboard: .safety, controller: SafetyWorkMethodDetailVC()) as! SafetyWorkMethodDetailVC
//        vc.safetyId = myList[indexPath.row].id
//        vc.safetyDetail = myList[indexPath.row]
//        vc.projectId = ProjectId
//        let item = myList[indexPath.row]
//        let vc = ScreenManager.getController(storyboard: .main, controller: ProjectDetailVC()) as! ProjectDetailVC
//        vc.ProjectId = myList[indexPath.row].projectID
//        slideMenuController()?.changeMainViewController(mainViewController: vc, close: true)
        
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let type = myList[indexPath.row].notificationType
        
        if type == Ntype.inviteAcceptedClient {
            let vc = ScreenManager.getController(storyboard: .main, controller: HomeVC()) as! HomeVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = ScreenManager.getController(storyboard: .main, controller: ProjectDetailVC()) as! ProjectDetailVC
            vc.ProjectId = myList[indexPath.row].projectID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
  
    }
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
        }

        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

            return 150

        }
    
    func configureTableView() {
        tblROIs.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
    }
}


