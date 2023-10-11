//
//  TaskListVC.swift
//  Comezy
//
//  Created by shiphul on 18/12/21.
//

import UIKit

class TaskListVC: UIViewController {
    var ProjectId: Int?
    let objTaskListViewModel = TaskListViewModel()
    var myTaskList = [TaskResult]()
    @IBOutlet weak var tblTasks: UITableView!
    @IBOutlet weak var noTasksLabel: UILabel! 
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // Do any additional setup after loading the view.
        PeopleListViewModel.shared.getPeopleListInBackground(size: "1000", page: 1, project_id: ProjectId ?? 0) { status, peopleList, errorMsg in }
        print("Project Bt last Contrller ","\(ProjectId)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let loggedInUserOcc = kUserData?.user_type ?? ""
        getTaskListDeatils()
        if loggedInUserOcc == UserType.kOwner {
            addButton.isHidden = false
        } else {
            addButton.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let obj = NotificationsViewModel.shared
        obj.clearBadgeCount(projectId: ProjectId ?? 0, module: "task") { success, resp, errorMsg in
            if success {
                print("Notification count cleared")
            }
        }
    }
    
    func configureTableView() {
        tblTasks.delegate = self
        tblTasks.dataSource = self
        tblTasks.register(UINib(nibName: "TasksListCell", bundle: nil), forCellReuseIdentifier: "TasksListCell")
    }
    func getTaskListDeatils(){
        self.objTaskListViewModel.getTaskList(project_id: ProjectId ?? 0, size: 1000, page: 1) { (success, taskList, error) in
            if success {
                self.myTaskList = taskList ?? [TaskResult]()
                DispatchQueue.main.async {
                    self.tblTasks.reloadData()
                    if self.myTaskList.count == 0 {
                        self.tblTasks.isHidden = true
                        self.noTasksLabel.isHidden = false
                    } else {
                        self.noTasksLabel.isHidden = true
                        self.tblTasks.isHidden = false
                    }
                }
            } else {
                
                DispatchQueue.main.async {
                    self.tblTasks.isHidden = true
                    self.noTasksLabel.isHidden = false
                }
             
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
        let vc = ScreenManager.getController(storyboard: .main, controller: HomeVC()) as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnAdd_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .main, controller: AddTaskVC()) as! AddTaskVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension TaskListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objTaskListViewModel.taskListDataDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblTasks.dequeueReusableCell(withIdentifier: "TasksListCell", for: indexPath) as! TasksListCell
        cell.item2 = objTaskListViewModel.taskListDataDetail[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ScreenManager.getController(storyboard: .main, controller: TaskDetailVC()) as! TaskDetailVC
        let item2 = objTaskListViewModel.taskListDataDetail[indexPath.row]
        vc.ProjectId = ProjectId
        vc.taskId = item2.id
        //vc.item = item2
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    
}
