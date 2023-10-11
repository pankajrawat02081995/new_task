//
//  GeneralVC.swift
//  Comezy
//
//  Created by aakarshit on 09/06/22.
//

import UIKit

class GeneralVC: UIViewController {
    var ProjectId: Int?
    var objBadgeCount: NotificationBadgeCountModel?
    @IBOutlet weak var lblROICount: UILabel!
    @IBOutlet weak var lblPunchListCount: UILabel!
    @IBOutlet weak var lblEOTCount: UILabel!
    @IBOutlet weak var lblToolBoxCount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        objBadgeCount = NotificationsViewModel.shared.objBadgeCount
        if(kUserData?.user_type != UserType.kOwner){

        if let obj = objBadgeCount?.allCount.docs.general {
            print(obj)
            if obj.roi > 0 {
                print("ROI Count ->", obj.roi)
                self.lblROICount.isHidden = false
                self.lblROICount.text = "\(obj.roi)"
            }else{
                self.lblROICount.isHidden = true

            }
            
            if obj.punchlist > 0 {
                self.lblPunchListCount.isHidden = false
                self.lblPunchListCount.text = "\(obj.punchlist)"
            }else{
                self.lblPunchListCount.isHidden = true

            }
            
            
            if obj.eot > 0 {
                self.lblEOTCount.isHidden = false
                self.lblEOTCount.text = "\(obj.eot)"
            }else{
                self.lblEOTCount.isHidden = true

            }
            
            if obj.toolbox > 0 {
                self.lblToolBoxCount.isHidden = false
                self.lblToolBoxCount.text = "\(obj.toolbox)"
            }else{
                
                    self.lblPunchListCount.isHidden = true

            }
        }}else{
            self.lblToolBoxCount.isHidden = true
            self.lblEOTCount.isHidden = true

            self.lblPunchListCount.isHidden = true

            self.lblROICount.isHidden = true


        }
    }
    
    
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnHome_action(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btn1stView_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .general, controller: RequestOfInformationsVC()) as! RequestOfInformationsVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btn2ndView_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .general, controller: PunchListVC()) as! PunchListVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btn3rdView_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .general, controller: ExtensionOfTimeVC()) as! ExtensionOfTimeVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btn4thView_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .general, controller: ToolBoxTalkVC()) as! ToolBoxTalkVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

