//
//  ProjectDetailVC.swift
//  Comezy
//
//  Created by MAC on 15/07/21.
//

import UIKit
import WebKit
import DropDown

class ProjectDetailVC: UIViewController{
    
    
    @IBOutlet weak var lblQPPDf: UILabel!
    @IBOutlet weak var lblSow: UILabel!
    let objRetrieveProjectViewModel = RetrieveProjectViewModel()
    var Sow: String?
    var projectListarr : [ProjectResult] = []
    var fileListarr : [RetrieveProjectModel] = []
    var objNotifVM = NotificationsViewModel.shared
    var objNotifModel: NotificationBadgeCountModel?
    var objProjStatusVM = ProjectStatusViewModel()
    var loggedInUserOccupation: String?
    
    @IBOutlet weak var txtProjectName: UITextField!
    @IBOutlet weak var imgClientProfile: UIImageView!
    @IBOutlet weak var txtClientName: UITextField!
    @IBOutlet weak var txtClientPhone: UITextField!
    @IBOutlet weak var txtClientEmail: UITextField!
    @IBOutlet weak var txtClientAddress: UITextField!
    @IBOutlet weak var projectDetailDesc: UILabel!
    @IBOutlet weak var QPPStackView: UIStackView!
    @IBOutlet weak var SOPStackView: UIStackView!
    @IBOutlet weak var btnSOW: UIButton!
    @IBOutlet weak var pdToNextHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pdToSOPHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var QPPHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var SOPHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnThreeDot: UIButton!
    
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var collectionViewQuotation: QuotationProjDetColView!
    @IBOutlet weak var collectionViewSOW: SOWProjDetColView!
    var ProjectId: Int?
    var projectType:String?
    var objPeopleListViewModel = PeopleListViewModel.shared
   
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        loggedInUserOccupation = kUserData?.user_type ?? ""
//        print(projectType!)

        if loggedInUserOccupation == UserType.kOwner{
            if(projectType ?? "in_progress" == ProjectProgressType.kCompleted){
                btnThreeDot.isHidden = true
            }
            else{
            btnThreeDot.isHidden = false
            }
        } else {
            btnThreeDot.isHidden = true
        }
        

    }
    override func viewDidAppear(_ animated: Bool) {
        if loggedInUserOccupation == UserType.kOwner{
            getPeopleListDetails()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btnNext.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        self.btnNext.clipsToBounds = true
    }
    
    
    func getPeopleListDetails() {
        self.objPeopleListViewModel.getPeopleListInBackground(size: "1000", page: 1, project_id: ProjectId ?? 0) { [self] (success, peopleList, error) in
                if success {
                    print("Project Id =>", self.ProjectId)

                    if PeopleListViewModel.shared.peopleListDataDetail.count == 0 {
                        //Pop up that takes to add people screen
                        
                        let vc = ConfirmViewController()
                        vc.show()
                        vc.btnYes.isHidden = true
                        vc.btnNo.setTitle("Go", for: .normal)
                        vc.confirmHeadingLabel.text = "Add people to the project"
                        vc.confirmDescriptionLabel.text = "There are no people on the project, let's add people to the project"
                        vc.noCallBack = {
                            
                            let vc = ScreenManager.getController(storyboard: .main, controller: PeopleVC()) as! PeopleVC
                            vc.ProjectId = self.ProjectId
                            self.navigationController?.pushViewController(vc, animated: true)
//                            self.showToast(message: "Project added successfully", font: .boldSystemFont(ofSize: 14.0))
                        }
                    }
                }else {
                    self.showAlert(message: error)
                }
            }
        }
    
    func initialLoad() {
        configureTableView()
        
        self.objRetrieveProjectViewModel.getRetrieveProjectDetail(id: ProjectId ?? 0) { (success, error) in
            if success {
                let projDetails = self.objRetrieveProjectViewModel.retrieveProjectDataDetail
        
                print(projDetails?.quotations?.count, "QPP Count")
                print(projDetails?.scope_of_work.count, "SOP Count")
                //MARK: Show collection view here

                
                            if projDetails?.quotations!.count == 0 && projDetails?.scope_of_work.count != 0 {
                                self.QPPHeightConstraint.constant = 0
                                self.SOPHeightConstraint.constant = 120
                            } else if projDetails?.scope_of_work.count == 0 && projDetails?.quotations?.count != 0 {
                                self.SOPHeightConstraint.constant = 0
                                self.QPPHeightConstraint.constant = 120
                            } else if projDetails?.quotations!.count == 0 && projDetails?.scope_of_work.count == 0 {
                                self.SOPHeightConstraint.constant = 0
                                self.QPPHeightConstraint.constant = 0
                
                            } else if projDetails?.quotations?.count != 0 && projDetails?.scope_of_work.count != 0 {
                                self.SOPHeightConstraint.constant = 120
                                self.QPPHeightConstraint.constant = 120
                            }

                self.updateValues()
            } else {
                self.showToast(message: error ?? "Oops! An error occured!")
            }
        }
        
        self.objNotifVM.getBadgeCount(projectId: self.ProjectId ?? 0) { success, resp, errorMsg in
            if success {
                self.objNotifModel = resp
            }
        }

    }
    
    func configureTableView() {
        
    }
    
    func updateValues() {
        txtProjectName.text = objRetrieveProjectViewModel.retrieveProjectDataDetail?.name
        let defaults = UserDefaults.standard
        defaults.set(objRetrieveProjectViewModel.retrieveProjectDataDetail?.address?.name, forKey: "location")
        print(UserDefaults.getString(forKey: "location"))

            if let url = URL(string: (objRetrieveProjectViewModel.retrieveProjectDataDetail?.client?.profilePicture) ?? ""){
                imgClientProfile.kf.setImage(with: url)
                imgClientProfile.contentMode = .scaleAspectFill
            }
        
        //MARK: Bug needs to be fixed
//        txtClientName.text = "\(String(describing: objRetrieveProjectViewModel.retrieveProjectDataDetail!.client!.firstName!)) \(String(describing: objRetrieveProjectViewModel.retrieveProjectDataDetail!.client!.lastName!))"
        txtClientName.text=objRetrieveProjectViewModel.retrieveProjectDataDetail?.client?.clientFullName()
        txtClientPhone.text = objRetrieveProjectViewModel.retrieveProjectDataDetail?.client?.phone
        txtClientEmail.text = objRetrieveProjectViewModel.retrieveProjectDataDetail?.client?.email
        txtClientAddress.text = objRetrieveProjectViewModel.retrieveProjectDataDetail?.address?.name
        projectDetailDesc.text = objRetrieveProjectViewModel.retrieveProjectDataDetail?.description
        collectionViewQuotation.reloadData()
        collectionViewSOW.reloadData()
    }
    
    @IBAction func btnFile_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .main, controller: WebViewVC()) as! WebViewVC
        vc.docURL = objRetrieveProjectViewModel.retrieveProjectDataDetail?.scope_of_work[0]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnNext_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .main, controller: ProjectDetailsVC()) as! ProjectDetailsVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnThreeDot_action(_ sender: Any) {
        
        if(projectType! == ProjectProgressType.kInProgress || projectType! == ProjectProgressType.kArchived){
         let menuList = ["Pause", "Complete"]
            showDropDown(menuList: menuList)

        }
        else if(projectType! == ProjectProgressType.kPaused) {
            let menuList = ["Resume"]
            showDropDown(menuList: menuList)

        }
        
    }
    func showDropDown(menuList:[String]){
        let dropDown = DropDown()
        let dropDownValues = menuList
        dropDown.anchorView = btnThreeDot
        dropDown.dataSource = dropDownValues
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.width = 200
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print(item)
            if item == "Pause" {
            objProjStatusVM.changeProjectStatus(type: "paused", projectId: ProjectId ?? 0) { success, projectList, errorMsg in
                    if success {
                        self.showToast(message: SuccessMessage.kPausedSuccess)
                    } else {
                        self.showToast(message: errorMsg ?? "An error occured please try again later")
                      }
                }
            }
            else if item == "Complete" {
                objProjStatusVM.changeProjectStatus(type: "completed", projectId: ProjectId ?? 0) { success, projectList, errorMsg in
                        if success {
                            self.showToast(message: SuccessMessage.kCompletedSuccess)
                        } else {
                            self.showToast(message: errorMsg ?? "An error occured please try again later")
                          }
                    }
                }
            else {
                objProjStatusVM.changeProjectStatus(type: "resume", projectId: ProjectId ?? 0) { success, projectList, errorMsg in
                        if success {
                            self.showToast(message: SuccessMessage.kResumeSuccess)
                        } else {
                            self.showToast(message: errorMsg ?? "An error occured please try again later")
                          }
                    }
                }
//            if index == 1 {
//                objProjStatusVM.changeProjectStatus(type: "completed", projectId: ProjectId ?? 0) { success, projectList, errorMsg in
//                    if success {
//                        self.showToast(message: "You have successfully completed the project.")
//                    } else {
//                        self.showToast(message: errorMsg ?? "An error occured please try again later")
//                      }
//                }
//            }
        }
    }
}

//MARK: Collection View

//MARK:- Tableview delegates and datasource -
extension ProjectDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return objRetrieveProjectViewModel.retrieveProjectDataDetail?.quotations!.count ?? 0
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewQuotation {
            return objRetrieveProjectViewModel.retrieveProjectDataDetail?.quotations!.count ?? 0
        } else {
          
            return objRetrieveProjectViewModel.retrieveProjectDataDetail?.scope_of_work.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let a = collectionView as? QuotationProjDetColView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuotationFilePDFCell", for: indexPath) as! QuotationFilePDFCell
        let item = objRetrieveProjectViewModel.retrieveProjectDataDetail?.quotations![indexPath.row]
        
        let itemAsURL = URL(string: item ?? "Work in progress")
        
        if let safeItemAsURL = itemAsURL {
            let fileName = safeItemAsURL.lastPathComponent
            cell.imgFile.image = checkFileType(FileName: fileName)
            
        }
        print(item)
        
        return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SOWProjDetFilePDFCell", for: indexPath) as! SOWProjDetFilePDFCell
            let item = objRetrieveProjectViewModel.retrieveProjectDataDetail?.scope_of_work[indexPath.row]
            let itemAsURL = URL(string: item ?? "Work in progress")
            
            if let safeItemAsURL = itemAsURL {
                let fileName = safeItemAsURL.lastPathComponent
                cell.imgFile.image = checkFileType(FileName: fileName)

            } else {
                cell.imgFile.image = UIImage(named: imageFile.noPath)
            }
            return cell
            
        }
        

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ScreenManager.getController(storyboard: .main, controller: WebViewVC()) as! WebViewVC
        if let a = collectionView as? QuotationProjDetColView {
            print("QUATATION" + "\(objRetrieveProjectViewModel.retrieveProjectDataDetail?.quotations?[indexPath.row])")
        vc.docURL = objRetrieveProjectViewModel.retrieveProjectDataDetail?.quotations![indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        }else{
            print("SOW" + "\(objRetrieveProjectViewModel.retrieveProjectDataDetail?.scope_of_work[indexPath.row])")
            vc.docURL = objRetrieveProjectViewModel.retrieveProjectDataDetail?.scope_of_work[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }



}

extension ProjectDetailVC: UIGestureRecognizerDelegate {
func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    if gestureRecognizer.isEqual(navigationController?.interactivePopGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    return false
}
}
