//
//  PunchListVC.swift
//  Comezy
//
//  Created by aakarshit on 17/06/22.
//

import UIKit

class PunchListVC: UIViewController {

    var loggedInUserOcc: String?
    var ProjectId: Int?
    let objVM = PunchListViewModel()
    var myList = [PunchListResult]()
    @IBOutlet weak var lblNoROI: UILabel!
    @IBOutlet weak var tblROIs: UITableView!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureTableView()

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
        obj.clearBadgeCount(projectId: ProjectId ?? 0, module: "punchlist") { success, resp, errorMsg in
            if success {
                print("Notification count cleared")
            }
        }
    }
    
    
    func getDocsListDetails() {
        self.objVM.getList(size: "1000", page: 1, project_id: ProjectId ?? 0) { (success, resp, error) in
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
        let vc = ScreenManager.getController(storyboard: .general, controller: AddPunchVC()) as! AddPunchVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

extension PunchListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlansTableViewCell", for: indexPath) as! PlansTableViewCell
        cell.lblStatus.isHidden=false

        let item = myList[indexPath.row]
        var count = 0
        item.checklist.forEach{ element in
            if(element.status == "true"){
                count+=1
                
            }
        }
        if(count == item.checklist.count){
            cell.lblStatus.text = "Completed"
        }else{
            cell.lblStatus.backgroundColor = UIColor(red: 250, green: 218, blue: 94)
            cell.lblStatus.text = "Pending"
        }
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        cell.lblPlanHeading.text = item.name
        
        
        cell.lblPlanDescription.text = item.resultDescription
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: item.createdDate ?? "")!
        dateFormatter.dateFormat = "EE, MMM d"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        cell.lblDate.text = dateString
        cell.lblDate.isHidden = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ScreenManager.getController(storyboard: .general, controller: PunchDetailVC()) as! PunchDetailVC
        vc.punchId = myList[indexPath.row].id
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

