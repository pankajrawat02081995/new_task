//
//  TaskDetailVC.swift
//  Comezy
//
//  Created by shiphul on 08/01/22.
//

import UIKit
import Alamofire
import DropDown


class TaskDetailVC: UIViewController {
    var ProjectId: Int?
    var taskId: Int?
    let token = kUserData?.jwt_token
    let objTaskListViewModel = TaskListViewModel()
    var objTaskDetail: TaskDetailModel?
    var variationDocsArray: [String]?
    var loggedInUserId:Int? = 0
    var loggedInUserOcc = ""
    var workerStatus = ""
    var completeStatus = ""
    var workerId = 0
    
    @IBOutlet weak var lblTaskName: UILabel!
    @IBOutlet weak var lblTaskDetail: UILabel!
    @IBOutlet weak var imgWorker: UIImageView!
    @IBOutlet weak var lblWorkerName: UILabel!
    @IBOutlet weak var lblWorkerOccupation: UILabel!
    
    @IBOutlet weak var lblAddTaskDetails: UILabel!
    @IBOutlet weak var docStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noDocsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblResponseStatus: UILabel!
    @IBOutlet weak var responseStackToptoViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackResponseBtns: UIStackView!
    @IBOutlet weak var constraintBtnsStack: NSLayoutConstraint!
    @IBOutlet weak var btnMarkAccepted: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        hideKeyboardWhenTappedAround()
        //getTaskDetail()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        btnMarkAccepted.createGradLayer()
        btnAccept.createGradLayer()
    }
    
    //    func getTaskDetail(){
    //        let url = "api/task/retrieve?task_id="
    //        let headers = [
    //                    "Authorization": "JWT \(token!)",
    //                    "Content-Type": "application/X-Access-Token"
    //                ]
    //          AF.request(url + "\(taskId)" , parameters: nil, headers:)
    //            .validate()
    //            .responseDecodable(of: TaskDetailModel.self) { response in
    //              guard let taskDetail = response.value else { return }
    //                print(response)
    //
    //          }
    //    }
    
    func initialLoad(){
        loggedInUserId = kUserData?.id
        loggedInUserOcc = kUserData?.user_type ?? ""
        print(kUserData?.user_type)
        print(kUserData?.id)
        print(kUserData)
        
        self.objTaskListViewModel.getTaskDetail(task_id: taskId!) { [weak self](success) in
            guard let s = self else {return}
            s.objTaskDetail = s.objTaskListViewModel.taskDetail
            if let objDetail = s.objTaskDetail  {
                s.workerStatus = objDetail.workerAction
                s.completeStatus = objDetail.completeStatus
                s.variationDocsArray = objDetail.documents
                s.workerId = objDetail.assignedWorker.id
                
                if s.loggedInUserOcc == UserType.kOwner && s.workerStatus == "pending" {
                    s.stackResponseBtns.isHidden = true
                    s.lblResponseStatus.isHidden = false
                    s.lblResponseStatus.text = "The worker has not performed any action on this task yet"
                    s.lblResponseStatus.textColor = .systemRed
                } else if s.loggedInUserOcc == UserType.kOwner && s.workerStatus == "accepted" && s.completeStatus == "completed" {
                    s.stackResponseBtns.isHidden = true
                    s.btnMarkAccepted.isHidden = false
                    s.lblResponseStatus.isHidden = false
                    s.lblResponseStatus.text = "Worker completed this task. Please Verify"
                    s.btnMarkAccepted.setTitle("Mark Verified", for: .normal)
                    s.lblResponseStatus.textColor = .systemGreen
                } else if s.loggedInUserOcc == UserType.kOwner && s.workerStatus == "rejected" {
                    s.stackResponseBtns.isHidden = true
                    s.lblResponseStatus.isHidden = false
                    s.lblResponseStatus.text = "Worker rejected this task"
                    s.lblResponseStatus.textColor = .systemRed
                } else if s.loggedInUserOcc == UserType.kOwner && s.workerStatus == "accepted" && s.completeStatus == "pending" {
                    s.stackResponseBtns.isHidden = true
                    s.btnMarkAccepted.isHidden = true
                    s.lblResponseStatus.isHidden = false
                    s.lblResponseStatus.text = "Worker accepted this task"
                    s.lblResponseStatus.textColor = .systemGreen
                } else if s.loggedInUserOcc == UserType.kWorker && s.loggedInUserId == s.workerId && s.workerStatus == "pending" {
                    s.stackResponseBtns.isHidden = false
                    s.btnMarkAccepted.isHidden = true
                    s.lblResponseStatus.isHidden = true
                } else if s.loggedInUserOcc == UserType.kWorker && s.loggedInUserId == s.workerId && s.workerStatus == "accepted" && s.completeStatus == "pending" {
                    s.stackResponseBtns.isHidden = true
                    s.btnMarkAccepted.isHidden = false
                    s.lblResponseStatus.isHidden = false
                    s.lblResponseStatus.text = "You already accepted this task"
                    s.lblResponseStatus.textColor = .systemGreen
                    s.btnMarkAccepted.setTitle("Mark as completed", for: .normal)
                } else if s.loggedInUserOcc == UserType.kWorker && s.loggedInUserId == s.workerId && s.completeStatus == "completed" && s.workerStatus == "accepted" {
                    s.stackResponseBtns.isHidden = true
                    s.btnMarkAccepted.isHidden = true
                    s.lblResponseStatus.isHidden = false
                    s.lblResponseStatus.text = "Task completed.Verification is pending from project owner"
                    s.lblResponseStatus.textColor = .systemGreen
                }
                s.updateValues()
            }
        }
        
    }
    
    
    
    
    func updateValues(){
        lblTaskName.text = objTaskListViewModel.taskDetail?.taskName
        lblTaskDetail.text = objTaskListViewModel.taskDetail?.dataDescription
        lblWorkerName.text = objTaskListViewModel.taskDetail?.assignedWorker.firstName
        lblWorkerOccupation.text = objTaskListViewModel.taskDetail?.occupation.name
        
        if variationDocsArray?.count ?? 0 < 1 {
            noDocsHeightConstraint.constant = 20
            docStackView.isHidden = true
        } else {
            docStackView.isHidden = false
            noDocsHeightConstraint.constant = 150
        }
        collectionView.reloadData()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnHome_action(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func btnAccept_action(_ sender: Any) {
        DispatchQueue.main.async {
            self.showAppAlert(title: "Accept Task?", message: "Do you want to Accept this task?") {
                self.objTaskListViewModel.getTaskResponse(task_id: self.taskId ?? 0, response: "accept") { status in
                    if status {
                        self.objTaskListViewModel.getTaskDetail(task_id: self.taskId ?? 0) { status in
                            if status {
                                self.showToast(message: "Task accepted successfully")
                                self.initialLoad()
                            }
                        }
                    }
                }
            }
        }

    }
    @IBAction func btnReject_action(_ sender: Any) {
        DispatchQueue.main.async {
            self.showAppAlert(title: "Reject Task?", message: "Do you want to Reject this task?") {
                self.objTaskListViewModel.getTaskResponse(task_id: self.taskId ?? 0, response: "reject") { status in
                    if status {
                        self.objTaskListViewModel.getTaskDetail(task_id: self.taskId ?? 0) { status in
                            if status {
                                self.showToast(message: "Task Rejected successfully")
                                self.initialLoad()
                            }
                        }
                    }
                }
            }
        }
    }
    @IBAction func btnMarkAccepted_action(_ sender: Any) {
        
        if loggedInUserOcc == UserType.kOwner {
            DispatchQueue.main.async {
                self.showAppAlert(title: "Mark as verified?", message: "Do you want to mark this task as Verified?") {
                    self.objTaskListViewModel.getTaskResponse(task_id: self.taskId ?? 0, response: "verified") { status in
                        if status {
                            self.navigationController?.popViewController(animated: true)
                            self.showToast(message: "Marked as verified successfully")
                        }

                    }
                }

            }
            
        } else {
            DispatchQueue.main.async {
                self.showAppAlert(title: "Mark as completed?", message: "Do you want to mark the task as completed?") {
                    self.objTaskListViewModel.getTaskResponse(task_id: self.taskId ?? 0, response: "completed") { status in
                        if status {
                            self.objTaskListViewModel.getTaskDetail(task_id: self.taskId ?? 0) { status in
                                if status {
                                    self.showToast(message: "Marked as completed successfully")
                                    self.initialLoad()
                                }

                            }
                        }
                    }
                }
            }

        }
    }
    
}

extension TaskDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return variationDocsArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VariationDocsCollCell", for: indexPath) as! VariationDocsCollCell
        let item = variationDocsArray?[indexPath.row]
        
        let itemAsURL = URL(string: item ?? "Work in progress")
        
        if let safeItemAsURL = itemAsURL {
            let fileName = safeItemAsURL.lastPathComponent
            cell.fileImageView.image = checkFileType(FileName: fileName)
            
        }
        print(item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ScreenManager.getController(storyboard: .main, controller: WebViewVC()) as! WebViewVC
        vc.docURL = variationDocsArray?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
