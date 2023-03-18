//
//  PeopleVC.swift
//  Comezy
//
//  Created by archie on 04/08/21.
//

import UIKit

class PeopleVC: UIViewController {
    let objAddTaskModel = TaskListViewModel.shared
    let objPeopleListViewModel = PeopleListViewModel.shared
    var ProjectId: Int?
    var WorkerId: Int?
    var didSelect: ((Bool) -> Void)?
    var fromPeopleId: Int?
    var btnBackActionMod: (() -> Void)?
    var isFromAddProject = false
    @IBOutlet weak var clientProfile: UIImageView!
    @IBOutlet weak var lblListCount: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblNoPeople: UILabel!
    @IBOutlet weak var addPeopleBtn: UIButton!
    @IBOutlet weak var tblPeople: UITableView!
    @IBOutlet weak var tableViewToSafeAreaConstraint: NSLayoutConstraint!
    
    var fromViewController:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        if isFromAddProject {
            isFromAddProject = false
            btnBackActionMod = {
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            btnBackActionMod = {
                self.navigationController?.popViewController(animated: true)
            }
        }
        manageView()
  
        print("Project Bt last Contrller ","\(ProjectId)")
//        updateValues()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if fromViewController == "daily" {
            
        } else {
            
        }
        getPeopleListDetails()
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let obj = NotificationsViewModel.shared
        obj.clearBadgeCount(projectId: ProjectId ?? 0, module: "people") { success, resp, errorMsg in
            if success {
                print("Notification count cleared")
            }
        }
    }
    
    //Method to manage view
    func manageView(){
        //Manage add btn view according to usertype
        if kUserData?.user_type == UserType.kOwner{
            addPeopleBtn.isHidden = false
        }else{
            addPeopleBtn.isHidden = true

        }
    }
    func getPeopleListDetails() {
        self.objPeopleListViewModel.getPeopleList(size: "1000", page: 1, project_id: ProjectId ?? 0) { [self] (success, peopleList, error) in
                if success {
                    
                    self.txtName.text = "\(String(describing: self.objPeopleListViewModel.clientListDataDetail.firstName!)) \(String(describing: objPeopleListViewModel.clientListDataDetail.lastName!))"
                    
                    self.lblListCount.text = "Workers" + "(\(self.objPeopleListViewModel.peopleListDataDetail.count))"
                    if let url = URL(string:(self.objPeopleListViewModel.clientListDataDetail.profilePicture)!){
                        clientProfile.kf.setImage(with: url)
                        clientProfile.contentMode = .scaleAspectFill
                    }
                    self.noPeople()
                    DispatchQueue.main.async {
                        self.tblPeople.reloadData()
                    }
                }else {
                    self.showAlert(message: error)
                }
            }
        }
    
    func noPeople(){
        if objPeopleListViewModel.peopleListDataDetail.count == 0{
            lblNoPeople.isHidden = false
            tblPeople.isHidden = true
        } else {
            lblNoPeople.isHidden = true
            tblPeople.isHidden = false
        }
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        btnBackActionMod?()
    }
    @IBAction func btnHome_action(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func btnAddFile_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .main, controller: UnassignedWorkersListVC()) as! UnassignedWorkersListVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK:- Custom functions -

extension PeopleVC {
    
    func configureTableView() {
        tblPeople.delegate = self
        tblPeople.dataSource = self
        tblPeople.register(UINib(nibName: "PeopleTableViewCell", bundle: nil), forCellReuseIdentifier: "PeopleTableViewCell")
    }
}

extension PeopleVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objPeopleListViewModel.peopleListDataDetail.count
    }
     func phone(phoneNum: String) {
        if let url = URL(string: "tel://\(phoneNum)") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblPeople.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        cell.item = objPeopleListViewModel.peopleListDataDetail[indexPath.row]
        cell.removeWorkerCallback = {
            self.showAppAlert(title:"Worker UnAssignment", message: "Do you want to unassign the worker from the project"){ [self] in
                objPeopleListViewModel.unAssignedWorker(assignedWorkerId: self.objPeopleListViewModel.peopleListDataDetail[indexPath.row].id!, project_id: self.ProjectId!){status,unAssignedWorkerModel,errorMsg in
                    if status{
                        showToast(message: "Worker UnAssigned successfully")

                        objPeopleListViewModel.peopleListDataDetail.remove(at: indexPath.row)
                        DispatchQueue.main.async {
                            
                            self.tblPeople.reloadData()

                        }
                    }else{
                        showToast(message: errorMsg!)
                    }
                    
                }
            }
        }
        cell.phoneNumberCallback = {
            if let url = URL(string: "tel://\( self.objPeopleListViewModel.peopleListDataDetail[indexPath.row].phone!)") {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url as URL)
                }
            }
        }
        cell.inductionResponseCallback = {
            let vc = ScreenManager.getController(storyboard: .main, controller: CompletedInductionVC()) as! CompletedInductionVC
            vc.ProjectId = self.ProjectId
            vc.userId = self.objPeopleListViewModel.peopleListDataDetail[indexPath.row].id!
            vc.workerDetails = self.objPeopleListViewModel.peopleListDataDetail[indexPath.row]

            self.navigationController?.pushViewController(vc, animated: true)
        }
       return cell
    }
    
    //MARK: DidSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            objPeopleListViewModel.clientListDataDetail = objPeopleListViewModel.peopleListDataDetail[indexPath.row]
            didSelect?(true)
            self.navigationController?.popViewController(animated: true)
            
            if fromViewController == "daily" {
                
            self.navigationController?.popViewController(animated: true)
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
           return 140

    

    }
    
}

