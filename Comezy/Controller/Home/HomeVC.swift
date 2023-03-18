//
//  HomeVC.swift
//  Comezy
//
//  Created by archie on 12/07/21.
//

import UIKit
import FirebaseFirestore


enum ProjectType: String, Mappable, Hashable {
    case inProgress
    case completed
    case archived
    case paused
}

var usrProfileImage: UIImage?
var isFromNotifOnSlideMenu = false
var isFromArchivOnSlideMenu = false
var isFromDeleteOnSlideMenu = false
var isFromLeaveOnSlideMenu = false
var isFromInviteOnSlideMenu = false
var isFromAccountInfo = false

class HomeVC: UIViewController{
    var db = Firestore.firestore()
   
    
    @IBOutlet weak var leadingBtnSubscribe: NSLayoutConstraint!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var tblProjects: UITableView!
    @IBOutlet weak fileprivate var segmentCntrl: CSegmentControl!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var lblNoProject: UILabel!
    @IBOutlet weak var addProjectButton: UIButton!
    var IS_SUBSCRIPTION:String=""
    
    @IBOutlet weak var btnSubsribeAction: UIButton!
    var projectType: ProjectType!
    let objSignupViewModel = SignupViewModel()
    var myProjectList = [ProjectResult]()
    var userDetails: UserBasicDetails?
    var tabledata = [String]()
    var loggedInUserOccupation: String?
    var objProjStatusVM = ProjectStatusViewModel()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setWindowLevel()
 
        print(searchBar.frame.width, "<=============== search bar width")
        
       
        
//        self.db.collection("app_status").getDocuments(){ (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialLoad()
      FRPush.push.subscribeTopic(true)
        getProjectsList(selectedtype: "in_progress")
        projectType = .inProgress
         searchBar.delegate = self
        searchBar.attributedPlaceholder = NSAttributedString(string: "Search Projects", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 466972)])
         userName.text = "Hi" + "," + "\(String(describing: kUserData?.first_name ?? ""))" 
         userEmail.text = kUserData?.email ?? ""
        if(kUserData?.user_type == UserType.kOwner){
            objSignupViewModel.profileDetail(){ [self] success, response, message in
        if success {
            self.IS_SUBSCRIPTION = response?.isSubscription ?? ""
                if(response?.isSubscription == AppConstant.TRIAL){
                    if(DateFromStringDate(inputFormat: DateTimeFormat.kTrailEndedTimeFormat, date:response!.trialEnded).millisecondsSince1970 >= Date().millisecondsSince1970){
                        self.db.collection("app_status").document("wTBmkujMo3Fp4ipQ6ebu")
                            .addSnapshotListener { (snapshot,error) in
                                if let error = error {
                                    print("error in firebase storage app status variable")
                                    self.btnSubsribeAction.isHidden = false
                    self.btnSubsribeAction.setTitle("", for: .normal)
                    self.btnSubsribeAction.setImage(UIImage(named: "free-trial"), for: .normal)
                    self.btnSubsribeAction.isEnabled = false
                                    self.addProjectButton.isHidden = false
                                }else{
                                    var a = snapshot?.data()!["isLive"]
                                    if(a as! Int != 0 ){
                                        self.btnSubsribeAction.isHidden = false
                        self.btnSubsribeAction.setTitle("", for: .normal)
                        self.btnSubsribeAction.setImage(UIImage(named: "free-trial"), for: .normal)
                        self.btnSubsribeAction.isEnabled = false
                                        self.addProjectButton.isHidden = false
                                    }
                                    else{
                                        self.btnSubsribeAction.setTitle("", for: .normal)
                                        self.btnSubsribeAction.isEnabled = false
                                        self.btnSubsribeAction.isHidden = true
                                        self.addProjectButton.isHidden = false
                                    }
                                }
                    }
                    }
                        else {
                        self.db.collection("app_status").document("wTBmkujMo3Fp4ipQ6ebu")
                            .addSnapshotListener { (snapshot,error) in
                                if let error = error {
                                    print("error in firebase storage app status variable")
                                    self.btnSubsribeAction.isHidden = false
                                self.btnSubsribeAction.setTitle("", for: .normal)
                                self.btnSubsribeAction.setImage(UIImage(named: "ic_subscribe"), for: .normal)
                                    self.addProjectButton.isHidden = true
                                }
                                else{
                                var a = snapshot?.data()!["isLive"]
                                print("ISLIVE",a)
                                    //Firestore variable isLive is checking here
                                    if(a as! Int != 0 ){
                                        self.btnSubsribeAction.isHidden = false
                                    self.btnSubsribeAction.setTitle("", for: .normal)
                                    self.btnSubsribeAction.setImage(UIImage(named: "ic_subscribe"), for: .normal)
                                        self.addProjectButton.isHidden = true
                                    }
                                    else{
                                        self.btnSubsribeAction.setTitle("", for: .normal)
                                        self.btnSubsribeAction.isEnabled = false
                                        self.btnSubsribeAction.isHidden = true
                                        self.addProjectButton.isHidden = false
                                    }
                                }
                            }
                       
//                        self.btnSubsribeAction.setTitle("", for: .normal)
//                        self.btnSubsribeAction.setImage(UIImage(named: "ic_subscribe"), for: .normal)
                        //self.btnSubsribeAction.contentMode = .scaleAspectFill
                        
                        
                    }
               
               
            }else if(response?.isSubscription == AppConstant.NO_ACTIVE_PLAN){
                self.addProjectButton.isHidden = true
                self.db.collection(Constants.FirestoreCollection).document(Constants.FirestoreAppStatusId)
                    .addSnapshotListener { (snapshot,error) in
                        if let error = error {
                            self.btnSubsribeAction.isHidden = false
                            self.btnSubsribeAction.setTitle("", for: .normal)
                            self.btnSubsribeAction.setImage(UIImage(named: "ic_subscribe"), for: .normal)
                        }
                        else{
                        var a = snapshot?.data()![Constants.DocumentField]
                        print(Constants.DocumentField,a)
                        //Firestore variable isLive is checking here

                        if(a as! Int != 0 ){
                            self.btnSubsribeAction.isHidden = false
                            self.btnSubsribeAction.setTitle("", for: .normal)
                            self.btnSubsribeAction.setImage(UIImage(named: "ic_subscribe"), for: .normal)
                        }
                        else{
                            self.btnSubsribeAction.setTitle("", for: .normal)
                            self.btnSubsribeAction.isEnabled = false
                            self.btnSubsribeAction.isHidden = true
                        }
                    }
                    }
                
                //self.btnSubsribeAction.contentMode = .scaleAspectFill
                
            }
            else{
                self.btnSubsribeAction.isHidden = true

                self.btnSubsribeAction.setTitle("", for: .normal)
                self.btnSubsribeAction.isEnabled = false
                self.addProjectButton.isHidden = false



            }
            

        }
        else{
            print(message)
            self.showToast(message: message ?? "")
        }
        }
        }else{
            self.btnSubsribeAction.isHidden = true
            self.addProjectButton.isHidden = true

        }
        

        loggedInUserOccupation = kUserData?.user_type ?? ""
        
        
         self.hideNavBar()
        

    }
    
    var keyWindow:UIWindow?{
        if #available(iOS 13, *) {
            return UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        }else{
            return UIApplication.shared.keyWindow
        }
        
    }
    
    private func setWindowLevel() {
        if let window  =  self.keyWindow{
            window.windowLevel = UIWindow.Level.normal
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isFromNotifOnSlideMenu {
            isFromNotifOnSlideMenu = false
            let vc = ScreenManager.getController(storyboard: .main, controller: NotificationListVC()) as! NotificationListVC
            navigationController?.pushViewController(vc, animated: false)
        }
        
        if isFromArchivOnSlideMenu {
            isFromArchivOnSlideMenu = false
            let vc = ScreenManager.getController(storyboard: .projectStatus, controller: ArchiveJobVC()) as! ArchiveJobVC
            navigationController?.pushViewController(vc, animated: false)
        }
        
        if isFromDeleteOnSlideMenu {
            isFromDeleteOnSlideMenu = false
            let vc = ScreenManager.getController(storyboard: .projectStatus, controller: DeleteJobVC()) as! DeleteJobVC
            navigationController?.pushViewController(vc, animated: false)
        }
        
        if isFromLeaveOnSlideMenu {
            isFromLeaveOnSlideMenu = false
            let vc = ScreenManager.getController(storyboard: .projectStatus, controller: LeaveJobVC()) as! LeaveJobVC
            navigationController?.pushViewController(vc, animated: false)
        }
        
        if isFromInviteOnSlideMenu {
            isFromInviteOnSlideMenu = false
            let vc = ScreenManager.getController(storyboard: .projectStatus, controller: InvitationListVC()) as! InvitationListVC
            navigationController?.pushViewController(vc, animated: false)
        }
        if isFromAccountInfo {
            isFromAccountInfo = false
            let vc = ScreenManager.getController(storyboard: .projectStatus, controller: AccountInfoVC()) as! AccountInfoVC
            navigationController?.pushViewController(vc, animated: false)
        }
        
        
        
        if let url = URL(string: (kUserData?.profile_picture ?? "")){
            userImg.kf.setImage(with: url)
        }
        
        print("rootViewController ->", self.navigationController?.rootViewController?.className)
        print("ViewControllers on Home ->",self.navigationController?.viewControllers)
        print("windows ->",    UIApplication.shared.windows)

    }
    
    
    @IBAction func addProject_action(_ sender: Any) {
                
        let vc = ScreenManager.getController(storyboard: .main, controller: AddProjectVC()) as! AddProjectVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Action Methods
    @IBAction func btnSubscribeAction(_ sender: UIButton) {
        let vc = ScreenManager.getController(storyboard: .projectStatus, controller: SubscribeVC()) as! SubscribeVC
        vc.IS_SUBSCRIPTION = self.IS_SUBSCRIPTION ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func segmentValueChanged(_ sender: Any) {
        if segmentCntrl.selectedSegmentIndex == 0
        {
            getProjectsList(selectedtype: "in_progress")
            projectType = .inProgress
            
        } else if segmentCntrl.selectedSegmentIndex == 1 {
            getProjectsList(selectedtype: "completed")
            projectType = .completed
            tblProjects.isHidden = true
            lblNoProject.isHidden = false
            
        } else if segmentCntrl.selectedSegmentIndex == 2 {
            getProjectsList(selectedtype: "archive")
            projectType = .archived
            tblProjects.isHidden = true
            lblNoProject.isHidden = false
            
        } else if segmentCntrl.selectedSegmentIndex == 3 {
            getProjectsList(selectedtype: "paused")
            projectType = .paused
            tblProjects.isHidden = true
            lblNoProject.isHidden = false
        }
       
    }
    
    func noProject() {
        if myProjectList.count == 0 {
            lblNoProject.isHidden = false
            tblProjects.isHidden = true
        } else {
            lblNoProject.isHidden = true
            tblProjects.isHidden = false
        }
    }

    
    @IBAction func logoutBtn_action(_ sender: Any) {
        kUserData = nil
        let vc = ScreenManager.getController(storyboard: .main, controller: LandingVC()) as! LandingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK:- Custom functions -

extension HomeVC {
    func initialLoad() {
        configureTableView()
       // self.navigationBarTitle(headerTitle: "Projects", backTitle: "")
       // self.navigationItem.leftBarButtonItem = nil
        segmentCntrl.selectedSegmentIndex = 0
        
    }
    
    func configureTableView() {
        tblProjects.delegate = self
        tblProjects.dataSource = self
        tblProjects.register(UINib(nibName: "ProjectsTableViewCell", bundle: nil), forCellReuseIdentifier: "ProjectsTableViewCellReuse")
        tblProjects.register(UINib(nibName: "ResumeProjectCell", bundle: nil), forCellReuseIdentifier: "ResumeProjectCell")
    }
    
    func getProjectsList(selectedtype: String, strSearch: String = "") {
        self.objSignupViewModel.getListProjects(searchProject: strSearch, type: selectedtype) { (success, projectList, error) in
                if success {
                    self.myProjectList = projectList ?? [ProjectResult]()
                    self.noProject()
                    DispatchQueue.main.async {
                        self.tblProjects.reloadData()
                    }
                } else {
                    self.showAlert(message: error)
                }
            }
        }
    }
    


extension HomeVC : UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("789789789")
        if textField == searchBar{
            print("111")
            var strSearch = (searchBar.text ?? "") + string
            if string == "" {
                strSearch = String(strSearch.dropLast())
                print("222")
            }
            if strSearch.count ?? 0 >= 3 {
                print("333")
                self.getProjectsList(selectedtype: "in_progress", strSearch: strSearch)
                DispatchQueue.main.async {
                    self.tblProjects.reloadData()
                }
            }else if strSearch.count == 0{
                print("444")
                self.getProjectsList(selectedtype: "in_progress", strSearch: strSearch)
                DispatchQueue.main.async {
                    self.tblProjects.reloadData()
                }
            }
        }
        print("0000")
        return true
    }
    
    
      
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myProjectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item = myProjectList[indexPath.row]

        if segmentCntrl.selectedSegmentIndex == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResumeProjectCell", for: indexPath) as! ResumeProjectCell
            cell.lblTitle.text = item.name
            cell.lblDescription.text = item.resultDescription
            let dateFormatter = DateFormatter()
            let tempLocale = dateFormatter.locale // save locale temporarily
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: item.createdDate ?? "")!
            dateFormatter.dateFormat = "EE, MMM d"
            dateFormatter.locale = tempLocale // reset the locale
            let dateString = dateFormatter.string(from: date)
            cell.lblDate.text = dateString
            cell.resumeCallback = {
                self.objProjStatusVM.changeProjectStatus(type: "resume", projectId: item.id ?? 0) { success, projectList, errorMsg in
                    if success {
                        self.getProjectsList(selectedtype: "paused")
                        self.showToast(message: SuccessMessage.kResumeSuccess)
                    }
                }
            }
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectsTableViewCellReuse", for: indexPath) as! ProjectsTableViewCell
          
            cell.titleLbl?.text = item.name
            cell.descriptionLbl?.text = item.resultDescription
            let dateFormatter = DateFormatter()
            let tempLocale = dateFormatter.locale // save locale temporarily
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: item.createdDate ?? "")!
            dateFormatter.dateFormat = "EE, MMM d"
            dateFormatter.locale = tempLocale // reset the locale
            let dateString = dateFormatter.string(from: date)
            print("EXACT_DATE : \(dateString)")
            cell.dateLbl?.text = dateString
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(kUserData?.user_type==UserType.kOwner && kUserData?.is_subscription==AppConstant.REGULAR || kUserData?.is_subscription==AppConstant.TRIAL){
        let item = myProjectList[indexPath.row]
        let vc = ScreenManager.getController(storyboard: .main, controller: ProjectDetailVC()) as! ProjectDetailVC
        vc.ProjectId = item.id
        vc.projectType = self.projectType!.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
}
