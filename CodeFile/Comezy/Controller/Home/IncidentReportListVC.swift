//
//  IncidentReportListVC.swift
//  Comezy
//
//  Created by aakarshit on 30/06/22.
//

import UIKit

class IncidentReportListVC: UIViewController {

    
    
    var loggedInUserOcc: String?
    var ProjectId: Int?
    let objVM = IncidentReportListViewModel()
    var myList = [IncidentResult]()
    var callback: ((IncidentResult)->Void)?
    @IBOutlet weak var lblNoROI: UILabel!
    @IBOutlet weak var tblROIs: UITableView!
    @IBOutlet weak var addButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()

        PeopleListViewModel.shared.getPeopleListInBackground(size: "1000", page: 1, project_id: ProjectId ?? 0) { status, peopleList, errorMsg in


        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(ProjectId as Any, "Printing project ID from <============== ROI VC")
        PeopleListViewModel.shared.getPeopleListInBackground(size: "1000", page: 1, project_id: ProjectId ?? 0) { status, peopleList, errorMsg in

            
        }
        getDocsListDetails()
        
        loggedInUserOcc = kUserData?.user_type ?? ""
        
//        if loggedInUserOcc == UserType.kOwner {
        self.addButton.isHidden = false
//        } else {
//            addButton.isHidden = true
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        NotificationsViewModel.shared.clearBadgeCount(projectId: ProjectId ?? 0, module: "incident_report") { success, resp, errorMsg in
            if success {
                print("Notification count cleared")
            }
        }
    }

    
    func getDocsListDetails() {
        print("Project id ---->",ProjectId)
        self.objVM.getList(size: "1000", page: 1, project_id: ProjectId ?? 0) { success, resp, errorMsg in
            if success {
                self.myList = resp?.results ?? []
                self.NoDocs()
                DispatchQueue.main.async {
                    self.tblROIs.reloadData()
                }
            } else {
                self.showAlert(message: errorMsg)
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
        let vc = ScreenManager.getController(storyboard: .safety, controller: AddIncidentReportVC()) as! AddIncidentReportVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

extension IncidentReportListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentReportListCell", for: indexPath) as! IncidentReportListCell
        let item = myList[indexPath.row]
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        cell.lblIncidentDescription.text = item.descriptionOfIncident
        
        cell.lblIncidentType.text = item.typeOfIncident?.name
        cell.lblIncidentDate.text = item.dateOfIncident
        cell.lblIncidentReportedDate.text = item.dateOfIncidentReported
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ScreenManager.getController(storyboard: .safety, controller: IncidentReportDetailVC()) as! IncidentReportDetailVC
        vc.incidentId = myList[indexPath.row].id
        vc.objIncidentDetails = myList[indexPath.row]
        vc.projectId = ProjectId
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
        tblROIs.register(UINib(nibName: "IncidentReportListCell", bundle: nil), forCellReuseIdentifier: "IncidentReportListCell")
    }

}
