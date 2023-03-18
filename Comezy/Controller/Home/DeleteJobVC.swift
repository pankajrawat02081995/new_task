//
//  DeleteJobVC.swift
//  Comezy
//
//  Created by aakarshit on 22/07/22.
//

import UIKit

class DeleteJobVC: UIViewController {
    
    
    var loggedInUserOcc: String?
    var ProjectId: Int?
    let objVM = ProjectStatusViewModel()
    var myList = [ProjectResult]()
    
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
        
        self.objVM.getProjectListByType(type: "deletelist") { (success, resp, error) in
                if success {
                    
//                    let newList = resp?.filter({ item in
//                        item.status != "archive"
//                    })
                    
                    self.myList = resp ?? []
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

extension DeleteJobVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArchiveProjectCell", for: indexPath) as! ArchiveProjectCell
        let item = myList[indexPath.row]
        cell.lblName.text = item.name
 
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: item.createdDate ?? "")!
        dateFormatter.dateFormat = "EE, MMM d"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        cell.lblDate.text = dateString
        cell.lblDate.isHidden = false
        cell.lblSummary.text = item.resultDescription
        
//        if item.status == "in_progress" {
//            cell.lblStatus.textColor = .systemYellow
//            cell.lblStatus.text = "In Progress"
//        } else if item.status == "completed" {
//            cell.lblStatus.textColor = .systemGreen
//            cell.lblStatus.text = "Completed"
//        } else if item.status == "paused" {
//            cell.lblStatus.textColor = .systemRed
//            cell.lblStatus.text = "Paused"
//        }
        cell.lblStatus.text = "Archive"
        cell.lblStatus.textColor = .systemRed
        cell.btnChangeStatus.setTitle("Delete", for: .normal)
        cell.btnChangeStatus.backgroundColor = .systemRed
        cell.btnCallback = {
            self.showAppAlert(title: "Delete Project", message: "Do you want to delete this project?") {
                self.objVM.deleteProject(projectId: item.id ?? 0) { status, projectList, errorMsg in
                    if status {
                        self.showToast(message: "Project deleted successfully")
                        self.getDocsListDetails()
                    }
                }
            }
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
        tblROIs.register(UINib(nibName: "ArchiveProjectCell", bundle: nil), forCellReuseIdentifier: "ArchiveProjectCell")
    }
}

