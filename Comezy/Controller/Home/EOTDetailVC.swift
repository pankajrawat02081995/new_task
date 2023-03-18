//
//  EOTDetailVC.swift
//  Comezy
//
//  Created by aakarshit on 22/06/22.
//

import UIKit

class EOTDetailVC: UIViewController {
    
    
    var eotId: Int?
    let objEOTDetailViewModel = EOTDetailViewModel()
    var objEOTDetailModel: EOTDetailModel?
    let objROISubmissionViewModel = ROISubmissionViewModel()
    //    let objVariationResponseData: VariationResponseModel?
    //    let objVariationResponseData: BaseResponse<VariationResponseDataModel>? = nil
    var myCommentList = [CommentResult]()
    let objCommentListViewModel = CommentListViewModel()
    var responseStatus: String?
    var loggedInUserId: Int?
    var loggedInUserOcc:String?
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var eotTitle: UILabel!
    @IBOutlet weak var lblReasonForDelay: UILabel!
    @IBOutlet weak var lblNumberOfDays: UILabel!
    @IBOutlet weak var lblContractExtendedFrom: UILabel!
    @IBOutlet weak var lblContractExtendedTo: UILabel!
    @IBOutlet weak var varSenderNameLabel: UILabel!
    @IBOutlet weak var varSenderEmailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noCommentsLabel: UILabel!
    @IBOutlet weak var senderDetailView: UIView!
    @IBOutlet weak var senderImageView: UIImageView!
    @IBOutlet weak var roiCommentTableView: VariationCommentTableView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roiCommentTableView.contentInsetAdjustmentBehavior = .never
        loggedInUserId = UserDefaults.getInteger(forKey: "userId")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialLoad()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        self.btnDelete.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        self.btnDelete.clipsToBounds = true
    }
    
    
    //MARK: Initial Load
    func initialLoad() {
        print(loggedInUserId)
        print(eotId)
        
        
        roiCommentTableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        objEOTDetailViewModel.getDetail(eotId: eotId ?? 0 ) { success, variationDetailResp, errorMsg in
            
            if success {
                self.objEOTDetailModel = variationDetailResp
                if let receivers = variationDetailResp?.receiver {
                    for i in receivers {
                        if i.id == self.loggedInUserId {
                            self.responseStatus = i.action
                            print(i.action)
                        }
                    }
   

                }
                DispatchQueue.main.async {
                    self.updateUI()
                }
                
            }
        }
        
        objCommentListViewModel.getCommentList(module: "eot_id", module_id: eotId ?? 34, size: 1000, page: 1) { success, comments, msg in
            if success {
                
                guard let safeComments = comments else { return }
                self.myCommentList = safeComments.reversed()
                self.roiCommentTableView.reloadData()
                print("@#$@#$!@#$!@#!@#$!@#$    S U C C E S S  !@#$!@#$!@#$@#%@#$%@#$%@#$%^@#$")
                print(self.myCommentList)
                self.toggleCommentLabel()
                
            } else {
                print("@#$@#$!@#$!@#!@#$!@#$     E R R O R     !@#$!@#$!@#$@#%@#$%@#$%@#$%^@#$")
            }
        }
    }
    
    func ajDateFormat(string: String) -> String {
        print(string)
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale.current // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "EE, MMM d"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date ?? Date())
        
        return dateString
    }
    //MARK: - Manage UI
    func manageUI(id:Int!){
        loggedInUserOcc = kUserData?.user_type ?? ""
        if (loggedInUserOcc == UserType.kOwner || loggedInUserId == id ) {
            btnDelete.isHidden = false
            editButton.isHidden=false
        } else {
            btnDelete.isHidden = true
            editButton.isHidden=true

        }
    }
    //MARK: Update UI
    func updateUI() {
        
        senderImageView.layer.cornerRadius = senderImageView.height / 2
        senderImageView.layer.borderWidth = 3
        senderImageView.layer.borderColor = UIColor(named: "AppBrightGreenColor")?.cgColor
        senderDetailView.layer.cornerRadius = 20
        let ref = objEOTDetailModel
        eotTitle.text = ref?.name
        self.manageUI(id: ref?.sender.id)

        
        lblReasonForDelay.text = ref?.reasonForDelay
        lblNumberOfDays.text = ref?.numberOfDays
        print(ref?.extendDateTo)
        print(ref?.extendDateFrom)
        lblContractExtendedTo.text = ajDateFormat(string: ref?.extendDateTo ?? "")
        lblContractExtendedFrom.text = ajDateFormat(string: ref?.extendDateFrom ?? "")
        print(lblContractExtendedTo.text)
        print(lblContractExtendedFrom.text)
      
        if let url = URL(string: (ref!.sender.profilePicture)){
            senderImageView.kf.setImage(with: url)
            senderImageView.contentMode = .scaleAspectFill
        }

        if let firstName = ref?.sender.firstName, let lastName = ref?.sender.lastName {
            varSenderNameLabel.text =  firstName + " " + lastName
        }
        
        varSenderEmailLabel.text = ref?.sender.email
        let nib = UINib(nibName: "VariationReceiversCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "VariationReceiverCell")
        
        DispatchQueue.main.async {
            self.tableViewHeightConstraint.constant = self.tableView.contentSize.height + CGFloat((15 * (self.objEOTDetailModel?.receiver.count ?? 0)))
        }
        print(tableViewHeightConstraint.constant)
        tableView.reloadData()
        
        
    }
    
   
    
    func toggleCommentLabel() {
        if myCommentList.count == 0 {
            roiCommentTableView.isHidden = true
            noCommentsLabel.isHidden = false
        } else {
            roiCommentTableView.isHidden = false
            noCommentsLabel.isHidden = true
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
    
    //MARK: Button Actions
    @IBAction func btnEdit_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .general, controller: EOTEditVC()) as! EOTEditVC
        vc.objEOTDetailModel = self.objEOTDetailModel
        vc.eotId = self.eotId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBack_action(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDelete_action(_ sender: Any) {
        self.showAppAlert(title: "Delete Extension of Time?", message: "Do you want to delete this Extension of Time") {
            self.objEOTDetailViewModel.deleteEot(eotId: self.eotId ?? 0) { success, response, msg in
                if success {
                    DispatchQueue.main.async {
                       
                        
                        self.navigationController?.popViewController(animated: true)
                        self.showToast(message: "Extension of Time deleted successfully")
                    }
                }
            }
        }
   
    }
    
    @IBAction func btnAddComment_action(_ sender: Any) {
        let vc = AddCommentViewController()
        vc.show()
        vc.callback = {
            
            if vc.commentTextField.text == "Write a comment here" || vc.commentTextField.text == "" || vc.commentTextField.text == "Cannot post an empty comment" {
                vc.commentTextField.text = "Cannot post an empty comment"
            } else {
                print(self.eotId)
                self.objCommentListViewModel.getAddComment(controller: self, module: "eot", comment: vc.commentTextField.text!, moduleId: self.eotId ?? 0) { success, addTaskList, errorMsg in
                    
                    if success {
                        self.showToast(message: "Comment added successfully", font: .boldSystemFont(ofSize: 14.0))

                        self.objCommentListViewModel.getCommentList(module: "eot_id", module_id: self.eotId ?? 0, size: 1000, page: 1) { success, allCommments, msg in
                            if success {
                                guard let safeComments = allCommments else {return}
                                
                                self.myCommentList = safeComments.reversed()
                                
                                DispatchQueue.main.async {
                                    self.roiCommentTableView.reloadData()
                                    self.toggleCommentLabel()
                                

                                }

                            } else {
                                
                            }
                        }
                        
                    }
                    self.dismiss(animated: true)
                }
            }
            

        }
    }
}

//MARK: TableView Delegates
extension EOTDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == roiCommentTableView {
            return 1
        } else {
            return objEOTDetailModel?.receiver.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == roiCommentTableView {
            return myCommentList.count
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == roiCommentTableView {
            return CGFloat(0.01)
            
        } else {
            return CGFloat(5)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.roiCommentTableView {
            if let firstName = myCommentList[indexPath.row].user?.firstName, let lastName = myCommentList[indexPath.row].user?.lastName {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
                cell.lblComment.text = myCommentList[indexPath.row].comment
                cell.lblUserName.text = firstName + " " + lastName
                
                if let url = URL(string:  (myCommentList[indexPath.row].user?.profilePicture!)!){
                    cell.imgUser.kf.setImage(with: url)
                    cell.imgUser.contentMode = .scaleAspectFill
                }
                let dateFormatter = DateFormatter()
                let tempLocale = dateFormatter.locale // save locale temporarily
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = dateFormatter.date(from: myCommentList[indexPath.row].createdTime ?? "")!
                dateFormatter.dateFormat = "EE, MMM d"
                dateFormatter.locale = tempLocale // reset the locale
                let dateString = dateFormatter.string(from: date)
                print("EXACT_DATE : \(dateString)")
                cell.dateLabel?.text = dateString
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            let ref = objEOTDetailModel
            let cell = tableView.dequeueReusableCell(withIdentifier: "VariationReceiverCell", for: indexPath) as! VariationReceiversCell
            cell.receiverName.text = ref?.receiver[indexPath.section].firstName
            cell.receiverEmail.text = ref?.receiver[indexPath.section].email
            if let url = URL(string: (ref?.receiver[indexPath.section].profilePicture)!){
            let data = try? Data(contentsOf: url)

            if let imageData = data {
            
                cell.receiverImage.image = UIImage(data: imageData)
            }
            }
            if let url = URL(string:  (ref?.receiver[indexPath.section].profilePicture)!){
                cell.receiverImage.kf.setImage(with: url)
                cell.receiverImage.contentMode = .scaleAspectFill
            }
            cell.layer.cornerRadius = 20
                
            print()
            
            if ref?.receiver[indexPath.section].id as? Int == loggedInUserId {
                if self.responseStatus == "pending" {
                    cell.xMark.isHidden = true
                    cell.checkMark.isHidden = false
                    cell.checkMark.image = UIImage(systemName: "signature")
                    cell.checkMark.tintColor = UIColor(named: "AppColor")
                    cell.responseStatusLabel.isHidden = true
                    
                    cell.checkMarkCallback = {
                        
                        
                        let vc = EOTSignatureView(nibName: "EOTSignatureView", bundle: nil)
                        vc.modalPresentationStyle = .overCurrentContext
                              vc.modalTransitionStyle = .crossDissolve
                        // Present View "Modally"
                        self.present(vc, animated: true, completion: nil)
                        vc.callback = { url in
                            self.objEOTDetailViewModel.submitEOTResponse(eotId: self.eotId ?? 0, imageURL: url) { success, resp, errorMsg in
                                if success {
                                    self.showToast(message: "Response added successfully")

                                    self.objEOTDetailViewModel.getDetail(eotId: self.eotId ?? 0) { success, response, errorMsg in
                                        if success {
                                            if let receivers = response?.receiver {
                                                for i in receivers {
                                                    if i.id == self.loggedInUserId {
                                                        self.responseStatus = i.action
                                                        print(i.action)
                                                    }
                                                    DispatchQueue.main.async {
                                                        self.tableView.reloadData()
                                                        
                                                    }
                                                }

                                            }
                                        }
                                    }                        
                                }
                            }
                            vc.dismiss(animated: true)

                        }
                   
                        print(cell.receiverEmail.text)
                    }
                } else {
                    cell.xMark.isHidden = true
                    cell.checkMark.isHidden = true
                    cell.responseStatusLabel.isHidden = false
                    cell.responseStatusLabel.text = "View"
                    cell.statusLabelCallback = {
                        
                        //Need to add image here
                    
//                        self.showMessageWithOk(title: "Response", message: ref?.receiver[indexPath.section] ?? "Error occured, try again later")
                        print(ref?.receiver[indexPath.section].signature)
                        let vc = ScreenManager.getController(storyboard: .main, controller: WebViewVC()) as! WebViewVC
                        vc.docURL = ref?.receiver[indexPath.section].signature ?? "https://www.google.com"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
                
            } else {
                cell.xMark.isHidden = true
                cell.checkMark.isHidden = true
                cell.responseStatusLabel.isHidden = false
                cell.responseStatusLabel.text = ref?.receiver[indexPath.section].action.capitalized
                cell.statusLabelCallback = {
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        if tableView == VariationCommentTableView {
    //            return
    //        }
    //    }
    
    
}

