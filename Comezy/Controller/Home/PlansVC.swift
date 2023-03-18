//
//  PlansVC.swift
//  Comezy
//
//  Created by shiphul on 03/12/21.
//

import UIKit

class PlansVC: UIViewController {
    var ProjectId: Int?
    var loggedInUserOcc: String?
    let objPlansListViewModel = PlansListViewModel()
    @IBOutlet weak var addPlanBtn: UIButton!
    var myPlanList = [PlansResult]()
    @IBOutlet weak var lblNoPlans: UILabel!
    
    @IBOutlet weak var tblPlans: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        //Noplans()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loggedInUserOcc = kUserData?.user_type ?? ""
        getPlansListDetails()
        
        if loggedInUserOcc == UserType.kOwner {
            addPlanBtn.isHidden = false
        } else {
            addPlanBtn.isHidden = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let obj = NotificationsViewModel.shared
        obj.clearBadgeCount(projectId: ProjectId ?? 0, module: "plan") { success, resp, errorMsg in
            if success {
                print("Notification count cleared")
            }
        }
    }
    func getPlansListDetails() {
        self.objPlansListViewModel.getPlansList(size: 1000, page: 1, project_id: ProjectId ?? 0) { (success, plansList, error) in
                if success {
                    self.myPlanList = plansList ?? [PlansResult]()
                    self.Noplans()
                    DispatchQueue.main.async {
                        self.tblPlans.reloadData()
                    }
                }else {
                    self.showAlert(message: error)
                }
            }
        }
    
    func Noplans(){
        if myPlanList.count == 0{
            lblNoPlans.isHidden = false
            tblPlans.isHidden = true
        }else{
            lblNoPlans.isHidden = true
            tblPlans.isHidden = false
        }
    }

    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnHome_action(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func btnAdd_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .main, controller: AddPlanVC()) as! AddPlanVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension PlansVC: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPlanList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlansTableViewCell", for: indexPath) as! PlansTableViewCell
        let item = myPlanList[indexPath.row]
        cell.lblPlanHeading.text = item.name
        cell.lblPlanDescription.text = item.resultDescription
        return cell
    }
    
    func configureTableView() {
        tblPlans.register(UINib(nibName: "PlansTableViewCell", bundle: nil), forCellReuseIdentifier: "PlansTableViewCell")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ScreenManager.getController(storyboard: .main, controller: PlanDetailVC()) as! PlanDetailVC
        vc.safetyId = myPlanList[indexPath.row].id
        vc.planDetail = myPlanList[indexPath.row]
        vc.projectId = ProjectId
        let item = myPlanList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
      //  showAlert(message: "This Task is in Progress")

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
