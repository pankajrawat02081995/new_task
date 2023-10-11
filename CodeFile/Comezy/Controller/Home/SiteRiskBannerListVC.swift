//
//  SiteRiskBannerListVC.swift
//  Comezy
//
//  Created by prince on 25/01/23.
//

import Foundation
import UIKit

class SiteRiskBannerListVC: UIViewController  {
  
    
    
    
    //MARK: - Variable
    //Variables
    var loggedInUserOcc: String?
    var ProjectId: Int?
    let objVM = SiteRiskBannerViewModel()
    var myList = [SiteRiskAssessmentBannerResponseResult]()
    
    //MARK: - IB OUtlet
    //IB Outlet of storyboard view
    @IBOutlet weak var lblNoSiteSafety: UILabel!
    @IBOutlet weak var tblSiteSafety: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    //MARK: - View Controller Lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        tblSiteSafety.register(UINib(nibName: "SiteRiskBannerCell", bundle: nil), forCellReuseIdentifier: "SiteRiskBannerCell")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(ProjectId as Any, "Printing project ID from <============== ROI VC")
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
        obj.clearBadgeCount(projectId: ProjectId ?? 0, module: "site_risk_assessment") { success, resp, errorMsg in
            if success {
                print("Notification count cleared")
            }
        }
        
        PeopleListViewModel.shared.getPeopleListInBackground(size: "1000", page: 1, project_id: ProjectId ?? 0) { status, peopleList, errorMsg in
            
        }
    }
    //MARK: - IBAction Methods
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHome_action(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func btnAddROI_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .safety, controller: AddSiteRiskVC()) as! AddSiteRiskVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - General Methods
    func getDocsListDetails() {
        
        objVM.getList(size: "100", page: 1, project_id: ProjectId ?? 0) { success, resp, errorMsg in
            if success {
                self.myList = resp?.results ?? []
                self.NoDocs()
                DispatchQueue.main.async {
                    self.tblSiteSafety.reloadData()
                }
            } else {
                self.showAlert(message: errorMsg)
            }
        }
        }
    
    func NoDocs(){
        if myList.count == 0{
            lblNoSiteSafety.isHidden = false
            tblSiteSafety.isHidden = true
        }else{
            lblNoSiteSafety.isHidden = true
            tblSiteSafety.isHidden = false
        }
    }
}

//MARK: - UITableViewDelegate Methods
extension SiteRiskBannerListVC: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(myList.count)
        return myList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SiteRiskBannerCell", for: indexPath) as! SiteRiskBannerCell
        let item = myList[indexPath.row]
        print(item)
        cell.lblDate.text =  DateFormatToAnother(inputFormat: DateTimeFormat.kDateTimeFormat, outputFormat: DateTimeFormat.kEE_MMM_d, date: myList[indexPath.row].createdDate!)
       
        cell.createdBy.text = myList[indexPath.row].createdBy.firstName
        cell.serialNumberlbl.text = String(indexPath.row+1)


        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ScreenManager.getController(storyboard: .safety, controller: SiteRiskListVC()) as! SiteRiskListVC
        vc.ProjectId = ProjectId
        let item = myList[indexPath.row]
        vc.myList = item.siteRiskAssessmentList
        vc.createdBy = item.createdBy.id
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return cellSize.SiteRiskBannerSize
        }


    func configureTableView() {
        tblSiteSafety.register(UINib(nibName: "SiteRiskBannerCell", bundle: nil), forCellReuseIdentifier: "SiteRiskBannerCell")
    }


}


