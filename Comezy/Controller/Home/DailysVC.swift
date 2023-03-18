//
//  DailysVC.swift
//  Comezy
//
//  Created by shiphul on 17/12/21.
//

// This is launched after tapping Daily which comes after tapping next on the project screen tableView of with big cells holding the icon of Task, Timesheets, Schedule, And Daily Work Report.

import UIKit

class DailysVC: UIViewController {
    var ProjectId:Int?
    var arrayOfItems : [DailysItem]=[DailysItem]()
    var objBadgeCountModel: NotificationBadgeCountModel?
    
    @IBOutlet weak var tblDailys: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfItems = DailyItemApiClient().getData1()
        configureTableView()
        // Do any additional setup after loading the view.
        
        print("Project Bt last Contrller ","\(ProjectId)")
    }
    
    func loadBadgeCount() {
        let obj = NotificationsViewModel.shared
        objBadgeCountModel = obj.objBadgeCount
        tblDailys.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadBadgeCount()
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
    navigationController?.popToRootViewController(animated: true)
    }
    
}
extension DailysVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DocsCell") as? DocsCell {
            cell.configureCellDaily(item2: arrayOfItems[indexPath.row])
            //if(kUserData?.user_type != UserType.kOwner){
            print("P_>P",objBadgeCountModel?.allCount.daily)

            if let obj = objBadgeCountModel?.allCount.daily {
                print(indexPath.row,obj.task)
                
                if(kUserData?.user_type != UserType.kClient){
                    if indexPath.row == 0 {
                        if obj.task > 0{
                            cell.lblCount.isHidden = false
                            cell.lblCount.text = "\(obj.task)"
                        }else{
                            cell.lblCount.isHidden = true
                            
                        }
                    }
                    
                    if indexPath.row == 1 {
                        cell.lblCount.isHidden = true
                    }
                    
                    if indexPath.row == 2 {
                        if obj.schedule > 0{
                            cell.lblCount.isHidden = false
                            cell.lblCount.text = "\(obj.schedule)"
                        }else{
                            cell.lblCount.isHidden = true
                            
                        }
                    }
                    
                    if indexPath.row == 3 {
                        if obj.dailyWorkReport > 0 {
                            cell.lblCount.isHidden = false
                            cell.lblCount.text = "\(obj.dailyWorkReport)"
                        }else{
                            cell.lblCount.isHidden = true
                        }
                    }
                }else{
                    if indexPath.row == 0 {
                        if obj.schedule > 0{
                            cell.lblCount.isHidden = false
                            cell.lblCount.text = "\(obj.schedule)"
                        }else{
                            cell.lblCount.isHidden = true
                            
                        }
                    }
                    
                    if indexPath.row == 1 {
                        if obj.dailyWorkReport > 0 {
                            cell.lblCount.isHidden = false
                            cell.lblCount.text = "\(obj.dailyWorkReport)"
                        }else{
                            cell.lblCount.isHidden = true
                        }
                    }
                }
            }
           // }else{
          //      cell.lblCount.isHidden = true
          //  }
            return cell
            
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(kUserData?.user_type != UserType.kClient){
            
            if indexPath.row == 0 {
                let vc = ScreenManager.getController(storyboard: .main, controller: TaskListVC()) as! TaskListVC
                vc.ProjectId = ProjectId
                self.navigationController?.pushViewController(vc, animated: true)
            } else
            if indexPath.row == 1 {
                let vc = ScreenManager.getController(storyboard: .main, controller: TimeSheetVC()) as! TimeSheetVC
                vc.ProjectId = ProjectId
                self.navigationController?.pushViewController(vc, animated: true)
            }else
            if indexPath.row == 2 {
                let vc = ScreenManager.getController(storyboard: .schedule, controller: ScheduleVC()) as! ScheduleVC
                vc.projectId = ProjectId
                self.navigationController?.pushViewController(vc, animated: true)
//                self.showToast(message: "Schedule work is in progress")

            } else
            if indexPath.row == 3 {
                let vc = ScreenManager.getController(storyboard: .main, controller: DailyLogListVC()) as! DailyLogListVC
                vc.ProjectId = ProjectId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if indexPath.row == 0 {
//                let vc = ScreenManager.getController(storyboard: .schedule, controller: ScheduleVC()) as! ScheduleVC
//                vc.projectId = ProjectId
//                self.navigationController?.pushViewController(vc, animated: true)
                self.showToast(message: "Schedule work is in progress")
            } else
            if indexPath.row == 1 {
                let vc = ScreenManager.getController(storyboard: .main, controller: DailyLogListVC()) as! DailyLogListVC
                vc.ProjectId = ProjectId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func configureTableView() {
        tblDailys.register(UINib(nibName: "DocsCell", bundle: nil), forCellReuseIdentifier: "DocsCell")
    }
    
}
