//
//  SiteRiskListVC.swift
//  Comezy
//
//  Created by aakarshit on 05/07/22.
//

import UIKit

class SiteRiskListVC: UIViewController {

    //Variables
    var loggedInUserOcc: String?
    var ProjectId: Int?
    let objVM = SiteRiskViewModel()
    var myList = [SiteRiskAssessmentBannerList]()
    var createdBy:Int?
    //IB Outlet of storyboard view
    @IBOutlet weak var lblNoROI: UILabel!
    @IBOutlet weak var tblROIs: UITableView!
    @IBOutlet weak var addButton: UIButton!

    //MARK: - View Controller Lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        tblROIs.register(UINib(nibName: "SiteRiskTblCell", bundle: nil), forCellReuseIdentifier: "SiteRiskTblCell")
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if(!myList.isEmpty){
            self.NoDocs()
            DispatchQueue.main.async {
                self.tblROIs.reloadData()
            }
        }
        loggedInUserOcc = kUserData?.user_type ?? ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let obj = NotificationsViewModel.shared
        obj.clearBadgeCount(projectId: ProjectId ?? 0, module: "site_risk_assessment") { success, resp, errorMsg in
            if success {
                print("Notification count cleared")
            }
        }
        
        PeopleListViewModel.shared.getPeopleListInBackground(size: "1000", page: 1, project_id: ProjectId ?? 0) { status, peopleList, errorMsg in
            
        }
    }
    //MARK: - IBAction Methods
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHome_action(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func btnAddROI_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .safety, controller: AddSiteRiskVC()) as! AddSiteRiskVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - General Methods

    
    func NoDocs(){
        if myList.count == 0{
            lblNoROI.isHidden = false
            tblROIs.isHidden = true
        }else{
            lblNoROI.isHidden = true
            tblROIs.isHidden = false
        }
    }
}

//MARK: - UITableViewDelegate Methods
extension SiteRiskListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(myList.count)
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SiteRiskTblCell", for: indexPath) as! SiteRiskTblCell
        let item = myList[indexPath.row]
        print(item)
        cell.lblSiteRiskQuestion.text = item.question.question
        print(item.response)
        print(item.statusOption,item.uploadFile,item.response)
        
        //Managing ui on worker response
        if item.response == "" {
            cell.workerResponse.text = SiteRiskListConst.statusPending
            cell.workerResponse.textColor = .systemYellow
            
        } else if item.response == SiteRiskListConst.statusYes {

            cell.workerResponse.text = SiteRiskListConst.statusYes.capitalized
            cell.workerResponse.textColor = .systemGreen
        } else if item.response == SiteRiskListConst.statusNo {
            cell.workerResponse.text = SiteRiskListConst.statusNo.capitalized
            cell.workerResponse.textColor = .systemRed
        }
        
        //Managing ui on builder response
        if item.statusOption == "" {
            cell.lblResponse.text = SiteRiskListConst.statusPending
            cell.lblResponse.textColor = .systemYellow
        } else if item.statusOption == SiteRiskListConst.statusYes {
            cell.assignedToStack.isHidden = true
            cell.workerResponseStack.isHidden = true
            cell.workerProofStack.isHidden = true
            cell.lblResponse.text = SiteRiskListConst.statusYes.capitalized
            cell.lblResponse.textColor = .systemGreen
        } else if item.statusOption == SiteRiskListConst.statusNo {
            cell.assignedToStack.isHidden = false
            cell.workerResponseStack.isHidden = false
            cell.workerProofStack.isHidden = false
            cell.assignedToStack.isHidden = true
            cell.lblResponse.text = SiteRiskListConst.statusNo.capitalized
            cell.lblResponse.textColor = .systemRed
        }
        
        //Showing Assigned To user name
        if(item.assignedTo.firstName == "" || item.assignedTo.firstName == nil){
            cell.assignedToStack.isHidden = true
        }else{
            cell.assignedToStack.isHidden = false
            cell.lblAssignedTo.text = "\(item.assignedTo.firstName ?? "") \(item.assignedTo.lastName ?? "" )"
        }
        
        //managing ui of Worker Proof File
        let workerProofUrl = URL(string: item.uploadFile ?? "")
        if(item.uploadFile == ""){
            cell.workerProofStack.isHidden = true
        }else{
            cell.workerProofStack.isHidden = false
        }
        
        //Changing image of proof file according file type
        if let workerProofFileUrl = workerProofUrl {
            let fileName = workerProofFileUrl.lastPathComponent
            cell.proofFile.image = checkFileType(FileName: fileName)
            
        }
        print(item.file)
        
        //managing ui of Builder uploaded File
        let docUrl = item.file
        
        let itemAsURL = URL(string: docUrl ?? "")
        if item.file == "" {
            cell.noFile()
        } else {
            cell.yesFile()
        }
        
        //Changing image of builder uploaded file according file type
        if let safeItemAsURL = itemAsURL {
            let fileName = safeItemAsURL.lastPathComponent
            cell.fileImageView.image = checkFileType(FileName: fileName)
        }
        cell.callback = {
            let vc = ScreenManager.getController(storyboard: .main, controller: WebViewVC()) as! WebViewVC
            vc.docURL = item.file
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.callbackproof = {
            let vc = ScreenManager.getController(storyboard: .main, controller: WebViewVC()) as! WebViewVC
            vc.docURL = item.uploadFile
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ScreenManager.getController(storyboard: .safety, controller: SiteRiskDetailVC()) as! SiteRiskDetailVC
//        vc.safetyId = myList[indexPath.row]
        vc.objSiteRiskDetail = myList[indexPath.row]
        vc.projectId = ProjectId
        let item = myList[indexPath.row]
        vc.createdBy = createdBy

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
        }

//        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//
//            return 250
//
//        }
    
    func configureTableView() {
        tblROIs.register(UINib(nibName: "SiteRiskTblCell", bundle: nil), forCellReuseIdentifier: "SiteRiskTblCell")
    }


}
