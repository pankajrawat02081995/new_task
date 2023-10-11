//
//  ProjectDetailsVC.swift
//  Comezy
//
//  Created by shiphul on 03/12/21.
//

import UIKit

class ProjectDetailsVC: UIViewController {
    
    var ProjectId: Int?
    var objNotifVM = NotificationsViewModel.shared
    var objNotifModel: NotificationBadgeCountModel?
    
    @IBOutlet weak var lblPlanCount: UILabel!
    @IBOutlet weak var lblDocsCount: UILabel!
    @IBOutlet weak var lblPeopleCount: UILabel!
    @IBOutlet weak var lblDailyCount: UILabel!
    
    
    
    
    override func viewDidLoad() {
        intialLoad()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func intialLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }
    
    func updateUI() {
        if let obj = objNotifVM.objBadgeCount?.allCount {
            if(kUserData?.user_type != UserType.kOwner){
                print(obj)
                
                if obj.plan > 0 {
                    lblPlanCount.isHidden = false
                    lblPlanCount.text = "\(obj.plan)"
                } else {
                    lblPlanCount.isHidden = true
                }
                
                if obj.docs.docsTotal > 0 {
                    lblDocsCount.isHidden = false
                    lblDocsCount.text = "\(obj.docs.docsTotal)"
                }else{
                    lblDocsCount.isHidden = true
                    
                }
                
                if obj.people > 0 {
                    lblPeopleCount.isHidden = false
                    lblPeopleCount.text = "\(obj.people)"
                }else{
                    lblPeopleCount.isHidden = true
                }
                
                if obj.daily.dailyTotal > 0 {
                    lblDailyCount.isHidden = false
                    lblDailyCount.text = "\(obj.daily.dailyTotal)"
                }else{
                    lblDailyCount.isHidden = true
                    
                }
            } else{
                if obj.daily.dailyTotal > 0 {
                    lblDailyCount.isHidden = false
                    lblDailyCount.text = "\(obj.daily.dailyTotal)"
                }else{
                    lblDailyCount.isHidden = true
                    
                }
                lblPlanCount.isHidden = true
                lblDocsCount.isHidden = true
                lblPeopleCount.isHidden = true
            }
        }
    }
    
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn1stView_action(_ sender: Any) {
        //  showWorkInProgress()
        let vc = ScreenManager.getController(storyboard: .main, controller: PlansVC()) as! PlansVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btn2ndView_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .main, controller: DocsVC()) as! DocsVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btn3rdView_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .main, controller: PeopleVC()) as! PeopleVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btn4thView_action(_ sender: Any) {
        //        showWorkInProgress()
        let vc = ScreenManager.getController(storyboard: .main, controller: DailysVC()) as! DailysVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
