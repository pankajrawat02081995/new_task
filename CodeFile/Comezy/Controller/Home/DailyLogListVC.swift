//
//  DailyListVC.swift
//  Comezy
//
//  Created by shiphul on 22/12/21.
//

import UIKit

class DailyLogListVC: UIViewController {
    var ProjectId: Int?
    var objDailyLogListViewModel = DailyLogListViewModel()
    var myDailyLogList = [DailyLogResult]()
    var editDocumentURL = [String]()
    var arrayPath:URL?
    @IBOutlet weak var noDailyTaskLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tblDailyLogs: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        noDailyTaskLabel.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getDailyLogListDetails()
        manageView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let obj = NotificationsViewModel.shared
        obj.clearBadgeCount(projectId: ProjectId ?? 0, module: "daily_work_report") { success, resp, errorMsg in
            if success {
                print("Notification count cleared")
            }
        }
    }
    
    func noDailyLog() {
        if myDailyLogList.count == 0 {
            noDailyTaskLabel.isHidden = false
            tblDailyLogs.isHidden = true
        } else {
            noDailyTaskLabel.isHidden = true
            tblDailyLogs.isHidden = false
        }
    }
    func manageView(){
        let loggedInUserOcc = kUserData?.user_type ?? ""
        if loggedInUserOcc == UserType.kOwner || loggedInUserOcc == UserType.kWorker  {
            addButton.isHidden = false
        } else {
            addButton.isHidden = true
        }
    }
    
    func getDailyLogListDetails() {
        self.objDailyLogListViewModel.getDailyLogList(size: 1000, page: 1, project_id: ProjectId ?? 0) { (success, dailyLogList, error) in
                if success {
                    self.myDailyLogList = dailyLogList ?? [DailyLogResult]()
                    
                    
                    DispatchQueue.main.async {
                        self.noDailyLog()
                    
                        self.tblDailyLogs.reloadData()
                        
                    }
                } else {
                    self.showAlert(message: error)
                }
            }
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHome_action(_ sender: Any) {
        //For going to edit
//        let vc = ScreenManager.getController(storyboard: .main, controller: EditDailyLogVC()) as! EditDailyLogVC
//        vc.ProjectId = ProjectId
//        vc.editDocumentsURL = editDocumentURL
//        self.navigationController?.pushViewController(vc, animated: true)
        let vc = ScreenManager.getController(storyboard: .main, controller: HomeVC()) as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnAddDailyLog_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .main, controller: AddDailyLogVC()) as! AddDailyLogVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DailyLogListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDailyLogList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyLogCell", for: indexPath) as! DailyLogCell
        cell.item = myDailyLogList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = myDailyLogList[indexPath.row]
        let vc = ScreenManager.getController(storyboard: .main, controller: DailyLogDetailVC()) as! DailyLogDetailVC
        vc.itemDailyLogResult = item
        vc.DailyLogId = item.id
        vc.ProjectId = ProjectId
        vc.arrayPath = arrayPath
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func configureTableView() {
        tblDailyLogs.delegate = self
        tblDailyLogs.dataSource = self
        tblDailyLogs.register(UINib(nibName: "DailyLogCell", bundle: nil), forCellReuseIdentifier: "DailyLogCell")
    }
    
    
}
