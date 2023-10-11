//
//  PunchListDetailVC.swift
//  Comezy
//
//  Created by aakarshit on 17/06/22.
//

import UIKit

class PunchDetailVC: UIViewController {
    var punchId: Int?
    let objPunchDetailVM = PunchListDetailViewModel()
    let objDeleteROIVM = DeleteVariationViewModel()
    var objPunchDetailData: PunchDetailModel?
    let objROISubmissionViewModel = ROISubmissionViewModel()
    //    let objVariationResponseData: VariationResponseModel?
    //    let objVariationResponseData: BaseResponse<VariationResponseDataModel>? = nil
    var myCommentList = [CommentResult]()
    let objCommentListViewModel = CommentListViewModel()
    var variationResponseStatus: String?
    var loggedInUserId: Int?
    var variationDocsArray: [String]?
    var allReceiverIds: [Int]?
    @IBOutlet weak var editButton: UIButton!
    var loggedInUserOcc:String?
    
    @IBOutlet weak var roiTitleLabel: UILabel!
    @IBOutlet weak var roiInformationRequiredLabel: UILabel!
    @IBOutlet weak var varSenderNameLabel: UILabel!
    @IBOutlet weak var varSenderEmailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noCommentsLabel: UILabel!
    @IBOutlet weak var senderDetailView: UIView!
    @IBOutlet weak var senderImageView: UIImageView!
    @IBOutlet weak var roiCommentTableView: VariationCommentTableView!
    @IBOutlet weak var variationDocsCollView: VariationDocsCollView!
    @IBOutlet weak var informationRequiredToViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var docsStackView: UIStackView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var checkListTableView: PunchCheckListTableView!
    @IBOutlet weak var checkListTableHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInsetAdjustmentBehavior = .never
        
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
        print(punchId)
        
        
        roiCommentTableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        checkListTableView.register(UINib(nibName: "PunchCheckListTableViewCell", bundle: nil), forCellReuseIdentifier: "PunchCheckListCell")

        objPunchDetailVM.getPunchDetail(punch_id: punchId ?? 0 ) { success, variationDetailResp, errorMsg in
            
            if success {
                self.allReceiverIds = []
                self.objPunchDetailData = variationDetailResp
                self.variationDocsArray = variationDetailResp?.file
                if let receivers = variationDetailResp?.receiver {
                    for i in receivers {
                        self.allReceiverIds?.append(i.id)
                    }
                    
                }
                print(self.allReceiverIds)
                DispatchQueue.main.async {
                    self.updateUI()
                    self.checkListTableView.reloadData()

                }
            }
        }
        
        objCommentListViewModel.getCommentList(module: "punchlist_id", module_id: punchId ?? 34, size: 1000, page: 1) { success, comments, msg in
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
        
        if variationDocsArray?.count ?? 0 < 1 {
            informationRequiredToViewBottomConstraint.constant = 20
            docsStackView.isHidden = true
        } else {
            docsStackView.isHidden = false
            informationRequiredToViewBottomConstraint.constant = 150
        }
        checkListTableView.allowsSelection = false
        variationDocsCollView.reloadData()
        senderImageView.layer.cornerRadius = senderImageView.height / 2
        senderImageView.layer.borderWidth = 3
        senderImageView.layer.borderColor = UIColor(named: "AppBrightGreenColor")?.cgColor
        senderDetailView.layer.cornerRadius = 20
        let ref = objPunchDetailData
        roiTitleLabel.text = ref?.name
        roiInformationRequiredLabel.text = ref?.welcomeDescription
        manageUI(id: ref?.sender.id)
        
        
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
            self.tableViewHeightConstraint.constant = self.tableView.contentSize.height + CGFloat((16 * (self.objPunchDetailData?.receiver.count ?? 0)))
            self.checkListTableHeightConstraint.constant = CGFloat(70 * (self.objPunchDetailData?.checklist.count ?? 0))
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
        let vc = ScreenManager.getController(storyboard: .general, controller: EditPunchVC()) as! EditPunchVC
        vc.objPunchDetailData = self.objPunchDetailData
        vc.variationId = self.punchId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBack_action(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: DeletePunch
    @IBAction func btnDelete_action(_ sender: Any) {
        self.showAppAlert(title: "Delete Punch?", message: "Do you want to delete this Punch") {
            self.objPunchDetailVM.deletePunch(punchId: self.punchId ?? 0) { success, response, msg in
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                        self.showToast(message: "Punch deleted successfully")
                    }
                } else {
                    self.showAlert(message: msg)
                }
            }
        }
    }
    
    //MARK: Add Comment
    
    @IBAction func btnAddComment_action(_ sender: Any) {
        let vc = AddCommentViewController()
        vc.show()
        vc.callback = {
            
            if vc.commentTextField.text == "Write a comment here" || vc.commentTextField.text == "" || vc.commentTextField.text == "Cannot post an empty comment" {
                vc.commentTextField.text = "Cannot post an empty comment"
            } else {
                self.objCommentListViewModel.getAddComment(controller: self, module: "punchlist", comment: vc.commentTextField.text!, moduleId: self.punchId ?? 0) { success, addTaskList, errorMsg in
                    
                    if success {
                        self.showToast(message: "Comment added successfully", font: .boldSystemFont(ofSize: 14.0))

                        self.objCommentListViewModel.getCommentList(module: "punchlist_id", module_id: self.punchId ?? 0, size: 1000, page: 1) { success, allCommments, msg in
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
extension PunchDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == roiCommentTableView {
            return 1
        } else if tableView == checkListTableView {
            return objPunchDetailData?.checklist.count ?? 0
        }else {
            return objPunchDetailData?.receiver.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == roiCommentTableView {
            return myCommentList.count
        } else if tableView == checkListTableView {
            return 1
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == roiCommentTableView {
            return CGFloat(0.01)
        } else if tableView == checkListTableView {
            return CGFloat(0.01)
        } else {
            return CGFloat(0)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame:
                                CGRect(x: 0, y: 0,
                                       width: tableView.frame.width,
                                       height: CGFloat.leastNormalMagnitude))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MARK: Comment View
        if tableView == self.roiCommentTableView {
            if let firstName = myCommentList[indexPath.row].user?.firstName, let lastName = myCommentList[indexPath.row].user?.lastName {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
                cell.lblComment.text = myCommentList[indexPath.row].comment
                cell.lblUserName.text = firstName + " " + lastName
                  if let url = URL(string: (myCommentList[indexPath.row].user?.profilePicture!)!){
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
        } else if tableView == self.checkListTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PunchCheckListCell", for: indexPath) as! PunchCheckListTableViewCell
            cell.punchLabel.text = objPunchDetailData?.checklist[indexPath.section].name ?? ""
            
            cell.layer.cornerRadius = 20
            cell.clipsToBounds = true
            cell.layer.masksToBounds = true
            
            
            if let contains = allReceiverIds?.contains(loggedInUserId ?? 0) {
                print(self.loggedInUserId)
                print(self.allReceiverIds)
                if contains == true {
                    if objPunchDetailData?.checklist[indexPath.section].status == "true" {
                        cell.btnUnComplete.setTitle("", for: .normal)
                        cell.btnUnComplete.setImage(UIImage(systemName: "checkmark"), for: .normal)
                        cell.btnUnComplete.tintColor = UIColor(named: "AppGreenColor")
                        
                        cell.callback = {
                            let currentCheckListId = self.objPunchDetailData?.checklist[indexPath.section].id
                            self.objPunchDetailVM.markCompletion(punch_id: currentCheckListId ?? 0, completion: "uncompleted") { success, emptydata, err in
                                if success {
                                   
                                    self.objPunchDetailVM.getPunchDetail(punch_id: self.punchId ?? 0) { success, detailResp, errorMsg in
                                        if success {
                                            self.allReceiverIds = []
                                            self.objPunchDetailData = detailResp
                                            self.variationDocsArray = detailResp?.file
                                            if let receivers = detailResp?.receiver {
                                                for i in receivers {
                                                    self.allReceiverIds?.append(i.id)
                                                }
                                                
                                            }
                                            DispatchQueue.main.async {
                                                self.checkListTableView.reloadData()
                                            }
                                        }
                                    }
                                }
                            }
                            
                            print(self.loggedInUserId)
                            print(self.allReceiverIds)
                        }
                    } else {
                            cell.btnUnComplete.setTitle("", for: .normal)
                            cell.btnUnComplete.setImage(UIImage(systemName: "xmark"), for: .normal)
                        cell.btnUnComplete.tintColor = .red
                            cell.callback = {
                                let currentCheckListId = self.objPunchDetailData?.checklist[indexPath.section].id
                                self.objPunchDetailVM.markCompletion(punch_id: currentCheckListId ?? 0, completion: "completed") { success, emptydata, err in
                                    if success {
                                        self.objPunchDetailVM.getPunchDetail(punch_id: self.punchId ?? 0) { success, detailResp, errorMsg in
                                            if success {
                                                self.allReceiverIds = []
                                                self.objPunchDetailData = detailResp
                                                self.variationDocsArray = detailResp?.file
                                                if let receivers = detailResp?.receiver {
                                                    for i in receivers {
                                                        self.allReceiverIds?.append(i.id)
                                                    }
                                                }
                                                DispatchQueue.main.async {
                                                    self.checkListTableView.reloadData()
                                                }
                                            }
                                        }
                                    }
                                }
                                print(self.loggedInUserId)
                                print(self.allReceiverIds)
                            }
                    }
              
                } else {
                    if objPunchDetailData?.checklist[indexPath.section].status == "true" {
                        cell.btnUnComplete.setTitle("Completed", for: .normal)
                        cell.btnUnComplete.imageView?.image = nil
                        cell.btnUnComplete.isEnabled = false
                    cell.callback = {
                        print(self.loggedInUserId)
                        print(self.allReceiverIds)
                    }
                    } else {
                       
                        cell.btnUnComplete.setTitle("Uncompleted", for: .normal)
                        cell.btnUnComplete.imageView?.image = nil
                        cell.btnUnComplete.isEnabled = false
                    }
                   
        
           
                }
                
            }
            
            return cell
        } else {
            
            //MARK: Receiver View
            
            let ref = objPunchDetailData
            let cell = tableView.dequeueReusableCell(withIdentifier: "VariationReceiverCell", for: indexPath) as! VariationReceiversCell
            cell.receiverName.text = ref?.receiver[indexPath.section].firstName
            cell.receiverEmail.text = ref?.receiver[indexPath.section].email
            if let url = URL(string: (ref?.receiver[indexPath.section].profilePicture)!){
                cell.receiverImage.kf.setImage(with: url)
                cell.receiverImage.contentMode = .scaleAspectFill
            }
            cell.layer.cornerRadius = 20
        
                cell.xMark.isHidden = true
                cell.checkMark.isHidden = true
                cell.responseStatusLabel.isHidden = true
                cell.statusLabelCallback = {
                    
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

extension PunchDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return variationDocsArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = variationDocsCollView.dequeueReusableCell(withReuseIdentifier: "VariationDocsCollCell", for: indexPath) as! VariationDocsCollCell
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


