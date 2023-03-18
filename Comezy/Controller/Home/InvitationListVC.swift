//
//  InvitationListVC.swift
//  Comezy
//
//  Created by aakarshit on 25/07/22.
//

import UIKit

class InvitationListVC: UIViewController {
    var loggedInUserOcc: String?
    var ProjectId: Int?
    let objVM = ProjectStatusViewModel()
    var myList = [InviteListResult]()
    
    @IBOutlet weak var btnColor: UIButton!
    @IBOutlet weak var lblNoROI: UILabel!
    @IBOutlet weak var tblROIs: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
//        let signInNavigationController =  UINavigationController.instance(from: .Main, withIdentifier: .kMyProjectsNavigationController)
//        AppDelegate.shared.window?.rootViewController = signInNavigationController
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(ProjectId as Any, "Printing project ID from <============== ROI VC")
        getDocsListDetails()
        loggedInUserOcc = kUserData?.user_type ?? ""
        
    }
    
    func getDocsListDetails() {
        
        self.objVM.getInviteList { (success, resp, error) in
                if success {
                    
//                    let newList = resp?.filter({ item in
//                        item.status != "archive"
//                    })
                    
                    self.myList = resp?.results ?? []
                    self.NoDocs()
                    DispatchQueue.main.async {
                        self.tblROIs.reloadData()
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

extension InvitationListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "invitationCell", for: indexPath) as! invitationCell
        let item = myList[indexPath.row]
        cell.lblWorkerName.text = item.firstName + " " + item.lastName
        cell.lblEmail.text = item.email
        cell.lblOccupation.text = item.userType.capitalized
        if item.status == "pending" {
            cell.lblStatus.textColor = .systemRed
            cell.lblStatus.text = "Pending"
        } else if item.status == "accepted" {
            cell.lblStatus.textColor = .systemGreen
            cell.lblStatus.text = "Accepted"
        } else {
            cell.lblStatus.textColor = .systemGreen
            cell.lblStatus.text = "Completed"
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = ScreenManager.getController(storyboard: .main, controller: ProjectDetailVC()) as! ProjectDetailVC
//        vc.ProjectId = myList[indexPath.row].projectID
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
        }

        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

            return 150

        }
    
    func configureTableView() {
        tblROIs.register(UINib(nibName: "invitationCell", bundle: nil), forCellReuseIdentifier: "invitationCell")
    }
}
