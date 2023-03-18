//
//  ToolBoxTalkVC.swift
//  Comezy
//
//  Created by aakarshit on 24/06/22.
//

import UIKit

class ToolBoxTalkVC: UIViewController {

    var loggedInUserOcc: String?
    var ProjectId: Int?
    let objVM = ToolBoxTalkListViewModel()
    var myList = [ToolBoxTalkListResult]()
    @IBOutlet weak var lblNoList: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(ProjectId as Any, "Printing project ID from <============== ROI VC")
        getDocsListDetails()
        
        manageUI()
       
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let obj = NotificationsViewModel.shared
        obj.clearBadgeCount(projectId: ProjectId ?? 0, module: "toolbox") { success, resp, errorMsg in
            if success {
                print("Notification count cleared")
            }
        }
    }
    
    
    func manageUI(){
        loggedInUserOcc = kUserData?.user_type ?? ""
        if loggedInUserOcc == UserType.kOwner {
            addButton.isHidden = false
        } else {
            addButton.isHidden = true
        }
    }
    
    
    func getDocsListDetails() {
        self.objVM.getList(size: "1000", page: 1, project_id: ProjectId ?? 0) { (success, resp, error) in
                if success {
                    self.myList = resp?.results ?? []
                    self.NoDocs()
                    DispatchQueue.main.async {
                        self.tblList.reloadData()
                    }
                } else {
                    self.showAlert(message: error)
                }
            }
        }
    
    func NoDocs(){
        if myList.count == 0{
            lblNoList.isHidden = false
            tblList.isHidden = true
        }else{
            lblNoList.isHidden = true
            tblList.isHidden = false
        }
    }
   
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHome_action(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func btnAdd_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .general, controller: AddToolBoxVC()) as! AddToolBoxVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

extension ToolBoxTalkVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlansTableViewCell", for: indexPath) as! PlansTableViewCell
        let item = myList[indexPath.row]
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        cell.lblPlanHeading.text = item.name
        
        cell.lblPlanDescription.text = item.topicOfDiscussion
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: item.createdDate ?? "")!
        dateFormatter.dateFormat = "EE, MMM d"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        cell.lblDate.text = dateString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ScreenManager.getController(storyboard: .general, controller: ToolBoxTalkDetailVC()) as! ToolBoxTalkDetailVC
        vc.tbID = myList[indexPath.row].id
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
        tblList.register(UINib(nibName: "PlansTableViewCell", bundle: nil), forCellReuseIdentifier: "PlansTableViewCell")
    }
}
