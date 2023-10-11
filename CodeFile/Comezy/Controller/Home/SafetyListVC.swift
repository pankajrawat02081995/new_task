//
//  SafetyListVC.swift
//  Comezy
//
//  Created by aakarshit on 28/06/22.
//

import UIKit

class SafetyListVC: UIViewController {
    
    var ProjectId: Int?
    var objBadgeCountModel: NotificationBadgeCountModel?

    @IBOutlet weak var tblDocs: UITableView!

    
    var arrayOfItems : [Item]=[Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfItems = APIClient().getSafetyData()
        configureTableView()
        
      
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBadgeCount()

    }
    
    func loadBadgeCount() {
        let obj = NotificationsViewModel.shared
        objBadgeCountModel = obj.objBadgeCount
        self.tblDocs.reloadData()
    }
    
    func clearBadgeCount() {
        
    }

    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnHome_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .main, controller: HomeVC()) as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SafetyListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DocsCell") as? DocsCell {
         cell.configureCell(item: arrayOfItems[indexPath.row])
            if(kUserData?.user_type != UserType.kOwner){
            
            if let obj = objBadgeCountModel?.allCount.docs.safety {
                
                if indexPath.row == 0 && obj.safeWorkMethodStatement > 0 {
                    cell.lblCount.isHidden = false
                    cell.lblCount.text = "\(obj.safeWorkMethodStatement)"
                }  else if indexPath.row == 0 && obj.safeWorkMethodStatement == 0 {
                    cell.lblCount.isHidden = true
                }
                
                if indexPath.row == 1 && obj.materialSafetyDataSheets > 0 {
                    cell.lblCount.isHidden = false
                    cell.lblCount.text = "\(obj.materialSafetyDataSheets)"
                }  else if indexPath.row == 1 && obj.materialSafetyDataSheets == 0 {
                    cell.lblCount.isHidden = true
                }
                
                if indexPath.row == 2 && obj.siteRiskAssessment > 0 {
                    cell.lblCount.isHidden = false
                    cell.lblCount.text = "\(obj.siteRiskAssessment)"
                }  else if indexPath.row == 2 && obj.siteRiskAssessment == 0 {
                    cell.lblCount.isHidden = true
                }
                
                if indexPath.row == 3 && obj.incidentReport > 0 {
                    cell.lblCount.isHidden = false
                    cell.lblCount.text = "\(obj.incidentReport)"
                }  else if indexPath.row == 0 && obj.incidentReport == 0  {
                    cell.lblCount.isHidden = true
                }
                
                if indexPath.row == 4 && obj.workHealthAndSafetyPlan > 0 {
                    cell.lblCount.isHidden = false
                    cell.lblCount.text = "\(obj.workHealthAndSafetyPlan)"
                }  else if indexPath.row == 4 && obj.workHealthAndSafetyPlan == 0 {
                    cell.lblCount.isHidden = true
                }
            }
            }else{
                
            }
           return cell
        }
    return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = ScreenManager.getController(storyboard: .safety, controller: SafetyWorkMethodVC()) as! SafetyWorkMethodVC
            vc.ProjectId = ProjectId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 1 {
            let vc = ScreenManager.getController(storyboard: .safety, controller: MaterialSafetyDataSheetVC()) as! MaterialSafetyDataSheetVC
            vc.ProjectId = ProjectId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 2 {
           // self.showAlert(message: "Site Risk Assessment is in progress")

            let vc = ScreenManager.getController(storyboard: .safety, controller: SiteRiskBannerListVC()) as! SiteRiskBannerListVC
            vc.ProjectId = ProjectId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 3 {
            let vc = ScreenManager.getController(storyboard: .safety, controller: IncidentReportListVC()) as! IncidentReportListVC
            vc.ProjectId = ProjectId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 4 {
            let vc = ScreenManager.getController(storyboard: .safety, controller: WorkHealthSafetyPlanVC()) as! WorkHealthSafetyPlanVC
            vc.ProjectId = ProjectId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func configureTableView() {
        tblDocs.register(UINib(nibName: "DocsCell", bundle: nil), forCellReuseIdentifier: "DocsCell")
    }
    
}


