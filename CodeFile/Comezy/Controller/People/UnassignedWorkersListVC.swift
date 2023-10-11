//
//  UnassignedWorkersListVC.swift
//  Comezy
//
//  Created by shiphul on 16/12/21.
//

import UIKit

class UnassignedWorkersListVC: UIViewController {
    
    var ProjectId: Int?
    var loggedInUserOcc: String?
    
    @IBOutlet weak var tblWorkers: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnAddWorker: UIButton!
    
    var objWorkerListViewModel = WorkerListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getWorkersList()
        

        loggedInUserOcc = kUserData?.user_type ?? ""

        if loggedInUserOcc == UserType.kOwner {
            btnAddWorker.isHidden = false
        } else {
            btnAddWorker.isHidden = true
        }

    }
    func getWorkersList(searchParam: String = ""){
        self.objWorkerListViewModel.getWorkersList(searchParam: searchParam, unassigned_workers: 1, size: "1000", page: 1, project_id: ProjectId ?? 0) { (success, peopleList, error) in
                if success {
                    
                    DispatchQueue.main.async {
                        self.tblWorkers.reloadData()
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
    func configureTableView() {
        tblWorkers.register(UINib(nibName: "PeopleTableViewCell", bundle: nil), forCellReuseIdentifier: "PeopleTableViewCell")
        
    }
    
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAddWorker_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .main, controller: InviteWorkerVC()) as! InviteWorkerVC
        vc.projectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension UnassignedWorkersListVC: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtSearch{
            var strSearch = (textField.text ?? "") + string
            if string == ""{
                strSearch = String(strSearch.dropLast())
            }
            if strSearch.count ?? 0 >= 3 {
                self.getWorkersList(searchParam: strSearch)
                DispatchQueue.main.async {
                    self.tblWorkers.reloadData()
                }
            }else if strSearch.count == 0{
                self.getWorkersList()
                DispatchQueue.main.async {
                    self.tblWorkers.reloadData()
                }
            }
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objWorkerListViewModel.workerListDataDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblWorkers.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        cell.btnRemove.isHidden = true
        cell.item2 = objWorkerListViewModel.workerListDataDetail[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var WorkerId = objWorkerListViewModel.workerListDataDetail[indexPath.row].id
        self.showAlertCustomMessage(title: "Confirm Worker Assingment", message: "Do you want to assign this worker to the project?") {
            
            self.objWorkerListViewModel.getAddWorkerList(project_id: self.ProjectId ?? 0 , worker_id: WorkerId ?? 0){ (success, workerList, error) in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }else {
                    self.showAlert(message: error)
                }
            }
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
