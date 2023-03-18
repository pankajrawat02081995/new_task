//
//  WorkHealthSafetyPlanVC.swift
//  Comezy
//
//  Created by aakarshit on 29/06/22.
//

import Foundation
import UIKit

class WorkHealthSafetyPlanVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    var loggedInUserOcc: String?
    var ProjectId: Int?
    let objVM = SafetyListViewModel()
    var myList = [SafetyListResult]()
    var callback: ((SafetyListResult)->Void)?
    @IBOutlet weak var lblNoROI: UILabel!
    @IBOutlet weak var tblROIs: UITableView!
    @IBOutlet weak var addButton: UIButton!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(ProjectId as Any, "Printing project ID from <============== ROI VC")
        configureTableView()
        getDocsListDetails()
        
        loggedInUserOcc = kUserData?.user_type ?? ""
        
        if loggedInUserOcc == UserType.kOwner {
            addButton.isHidden = false
        } else {
            addButton.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let obj = NotificationsViewModel.shared
        obj.clearBadgeCount(projectId: ProjectId ?? 0, module: "work_health_and_safety_plan") { success, resp, errorMsg in
            if success {
                print("Notification count cleared")
            }
        }
    }
    
    func getDocsListDetails() {
        self.objVM.getList(size: "1000", page: 1, project_id: ProjectId ?? 0, type: "work_health_and_safety_plan" ) { (success, resp, error) in
                if success {
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHome_action(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func btnAddROI_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .safety, controller: AddWorkHealthSafetyPlanVC()) as! AddWorkHealthSafetyPlanVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

extension WorkHealthSafetyPlanVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlansTableViewCell", for: indexPath) as! PlansTableViewCell
        let item = myList[indexPath.row]
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        cell.lblPlanHeading.text = item.name
        
        cell.lblPlanDescription.text = item.resultDescription
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: item.createdDate ?? "")!
        dateFormatter.dateFormat = "EE, MMM d"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        cell.lblDate?.text = dateString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ScreenManager.getController(storyboard: .safety, controller: WorkHealthSafetyPlanDetailVC()) as! WorkHealthSafetyPlanDetailVC
        vc.safetyId = myList[indexPath.row].id
        vc.safetyDetail = myList[indexPath.row]
        vc.projectId = ProjectId
        let item = myList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
        }

        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

            return 150

        }
    
    func configureTableView() {
        tblROIs.register(UINib(nibName: "PlansTableViewCell", bundle: nil), forCellReuseIdentifier: "PlansTableViewCell")
    }


}
