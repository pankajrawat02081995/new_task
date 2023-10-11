//
//  VariationDetailVC.swift
//  Comezy
//
//  Created by aakarshit on 28/05/22.
//
import UIKit
import Alamofire
import SwiftUI

class VariationDetailVC: UIViewController {
    var didEdit: Bool?
    var variationId: Int?
    let objVariationDetailVM = VariationDetailViewModel()
    let objDeleteVariationVM = DeleteVariationViewModel()
    var objVariationDetailData: VariationDetailModel?
    let objVariationResponseVM = VariationResponseViewModel()
//    let objVariationResponseData: VariationResponseModel?
//    let objVariationResponseData: BaseResponse<VariationResponseDataModel>? = nil
    var myCommentList = [CommentResult]()
    let objCommentListViewModel = CommentListViewModel()
    var variationResponseStatus: String?
    var loggedInUserId: Int?
    var variationDocsArray: [String]?
    var loggedInUserOcc: String?

    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var variationTitleLabel: UILabel!
    @IBOutlet weak var variationSummaryLabel: UILabel!
    @IBOutlet weak var variationPriceLabel: UILabel!
    @IBOutlet weak var variationGSTLabel: UILabel!
    @IBOutlet weak var variationTotalPriceLabel: UILabel!
    @IBOutlet weak var varSenderNameLabel: UILabel!
    @IBOutlet weak var varSenderEmailLabel: UILabel!
    @IBOutlet weak var varProfileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noCommentsLabel: UILabel!
    @IBOutlet weak var senderDetailView: UIView!
    @IBOutlet weak var senderImageView: UIImageView!
    @IBOutlet weak var variationCommentTableView: VariationCommentTableView!
    @IBOutlet weak var variationDocsCollView: VariationDocsCollView!
    @IBOutlet weak var summaryToPriceConstraint: NSLayoutConstraint!
    @IBOutlet weak var docsStackView: UIStackView!
    @IBOutlet weak var btnDelete: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        variationCommentTableView.contentInsetAdjustmentBehavior = .never
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
        print(variationId)
        
        
        variationCommentTableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        objVariationDetailVM.getVariationDetail(variation_id: variationId ?? 0 ) { success, variationDetailResp, errorMsg in
           
            if success {
                self.objVariationDetailData = variationDetailResp
                self.variationDocsArray = variationDetailResp?.file
                if let receivers = variationDetailResp?.receiver {
                    for i in receivers {
                        if i.id == self.loggedInUserId {
                            self.variationResponseStatus = i.action
                            print(i.action)
                        }
                }
                    
                }
                
                DispatchQueue.main.async {
                    self.updateUI()
                }
            }
        }
        
        objCommentListViewModel.getCommentList(module: "variation_id", module_id: variationId ?? 34, size: 1000, page: 1) { success, comments, msg in
            if success {
                
                guard let safeComments = comments else { return }
                self.myCommentList = safeComments.reversed()
                self.variationCommentTableView.reloadData()
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
            summaryToPriceConstraint.constant = 20
            docsStackView.isHidden = true
        } else {
            docsStackView.isHidden = false
            summaryToPriceConstraint.constant = 150
        }
        
        variationDocsCollView.reloadData()
        senderImageView.layer.cornerRadius = senderImageView.height / 2
        senderImageView.layer.borderWidth = 3
        senderImageView.layer.borderColor = UIColor(named: "AppBrightGreenColor")?.cgColor
        senderDetailView.layer.cornerRadius = 20
        let ref = objVariationDetailData
        variationTitleLabel.text = ref?.name
        variationSummaryLabel.text = ref?.summary
        self.manageUI(id: ref?.sender.id)
        if let url = URL(string: (ref!.sender.profilePicture)){
            senderImageView.kf.setImage(with: url)
            senderImageView.contentMode = .scaleAspectFill
        }
        print(ref?.gst)
        if ref?.gst == true {
            variationGSTLabel.text = "Yes"
        } else {
            variationGSTLabel.text = "No"
        }
        
        variationPriceLabel.text = ref?.price
        variationTotalPriceLabel.text = ref?.totalPrice
        if let firstName = ref?.sender.firstName, let lastName = ref?.sender.lastName {
            varSenderNameLabel.text =  firstName + " " + lastName
        }
        
        varSenderEmailLabel.text = ref?.sender.email
        let nib = UINib(nibName: "VariationReceiversCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "VariationReceiverCell")
        
        DispatchQueue.main.async {
            self.tableViewHeightConstraint.constant = self.tableView.contentSize.height + CGFloat((15 * (self.objVariationDetailData?.receiver.count ?? 0)))
        }
        print(tableViewHeightConstraint.constant)
        tableView.reloadData()

        
    }
    
    func toggleCommentLabel() {
        if myCommentList.count == 0 {
            variationCommentTableView.isHidden = true
            noCommentsLabel.isHidden = false
        } else {
            variationCommentTableView.isHidden = false
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
        let vc = ScreenManager.getController(storyboard: .editVariation, controller: EditVariationsVC()) as! EditVariationsVC
        vc.objVariationDetailData = self.objVariationDetailData
       
        vc.previousRef = self
    
        vc.variationId = self.variationId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBack_action(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDelete_action(_ sender: Any) {
        showAppAlert(title: "Delete Variation", message: "Do you want to delete this variation?") {
            self.objDeleteVariationVM.deleteVariation(variation_id: self.variationId ?? 0) { success, response, msg in
                if success {
                    DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        self.showToast(message: "Variation deleted successfully")
                        }
                    }
                else{
                    self.showAlert(message: msg)
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
                self.objCommentListViewModel.getAddComment(controller: self, module: "variation", comment: vc.commentTextField.text!, moduleId: self.variationId ?? 0) { success, addTaskList, errorMsg in
                    
                    if success {
                        self.showToast(message: "Comment added successfully")

                        self.objCommentListViewModel.getCommentList(module: "variation_id", module_id: self.variationId ?? 0, size: 1000, page: 1) { success, allCommments, msg in
                            if success {
                                guard let safeComments = allCommments else {return}
                                
                                self.myCommentList = safeComments.reversed()
                                
                                DispatchQueue.main.async {
                                    self.variationCommentTableView.reloadData()
                                    self.toggleCommentLabel()

                                }
                                
                            } else {
                                self.showAlert(message: msg)
                            }
                      
                        }
                        
                    }
                }
                vc.dismiss(animated: true)

            }

        }
    }
    
}

//MARK: TableView Delegates
extension VariationDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == variationCommentTableView {
            return 1
            
        } else {
            return objVariationDetailData?.receiver.count ?? 0
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == variationCommentTableView {
            return myCommentList.count
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == variationCommentTableView {
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
        
        if tableView == self.variationCommentTableView {
            if let firstName = myCommentList[indexPath.row].user?.firstName, let lastName = myCommentList[indexPath.row].user?.lastName {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
                cell.lblComment.text = myCommentList[indexPath.row].comment
                cell.lblUserName.text = firstName + " " + lastName
              
                if let url = URL(string: ((myCommentList[indexPath.row].user?.profilePicture)!)!){
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
            let ref = objVariationDetailData
            let cell = tableView.dequeueReusableCell(withIdentifier: "VariationReceiverCell", for: indexPath) as! VariationReceiversCell
            cell.receiverName.text = ref?.receiver[indexPath.section].firstName
            cell.receiverEmail.text = ref?.receiver[indexPath.section].email
            if let url = URL(string: ((ref?.receiver[indexPath.section].profilePicture)!)!){
            let data = try? Data(contentsOf: url)

            if let imageData = data {
            
                cell.receiverImage.image = UIImage(data: imageData)
            }
            }
            
            cell.layer.cornerRadius = 20
            
            
            
            if ref?.receiver[indexPath.section].id as? Int == loggedInUserId {
                if self.variationResponseStatus == "pending" {
                    cell.xMark.isHidden = false
                    cell.checkMark.isHidden = false
                    cell.responseStatusLabel.isHidden = true
                    cell.xMarkCallback = {
                        
                        self.showAppAlert(title: "Reject Variation", message: "Do you want to reject the variation") {
                            self.objVariationResponseVM.getVariationResponse(variation_id: self.variationId ?? 0, accepted: "reject") { success, variationDetailResp, errorMsg in
                                if success {
                                    self.showToast(message: "Variation rejected succcessfully")

                                    print("Variation rejected succcessfully")
                                    self.objVariationDetailVM.getVariationDetail(variation_id: self.variationId ?? 0 ) { success, variationDetailResp, errorMsg in
                                       
                                        if success {
                                            self.objVariationDetailData = variationDetailResp
                                            if let receivers = variationDetailResp?.receiver {
                                                for i in receivers {
                                                    if i.id == self.loggedInUserId {
                                                        self.variationResponseStatus = i.action
                                                        print(i.action)
                                                    }
                                            }
                                                
                                            }
                                            DispatchQueue.main.async {
                                                self.tableView.reloadData()

                                            }
                                        }
                                    }
                                }
    //                            else {
    //                                self.showAlert(message: errorMsg)
    //                            }
                            }
                        }
    
                        print(cell.receiverName.text)
                    }
                    
                    cell.checkMarkCallback = {
                        
                        self.showAppAlert(title: "Accept Variation", message: "Do you want to accept the variation?") {
                            self.objVariationResponseVM.getVariationResponse(variation_id: self.variationId ?? 0, accepted: "accept") { success, variationDetailResp, errorMsg in
                                if success {
                                    self.showToast(message: "Variation accepted succcessfully")

                                    self.objVariationDetailVM.getVariationDetail(variation_id: self.variationId ?? 0 ) { success, variationDetailResp, errorMsg in
                                       
                                        if success {
                                            self.objVariationDetailData = variationDetailResp
                                            if let receivers = variationDetailResp?.receiver {
                                                for i in receivers {
                                                    if i.id == self.loggedInUserId {
                                                        self.variationResponseStatus = i.action
                                                        print(i.action)
                                                    }
                                                    DispatchQueue.main.async {
                                                        self.tableView.reloadData()

                                                    }
                                            }
                                                
                                            }
                                            self.tableView.reloadData()
                                        }
                                    }
                                    print("Variation accepted succcessfully")
                                }
    //                            else {
    //                                self.showAlert(message: errorMsg)
    //                            }
                            }
                        }

                        print(cell.receiverEmail.text)
                    }
                } else {
                    cell.xMark.isHidden = true
                    cell.checkMark.isHidden = true
                    cell.responseStatusLabel.isHidden = false
                    cell.responseStatusLabel.text = ref?.receiver[indexPath.section].action.capitalized
                }
                
            } else {
                cell.xMark.isHidden = true
                cell.checkMark.isHidden = true
                cell.responseStatusLabel.isHidden = false
                cell.responseStatusLabel.text = ref?.receiver[indexPath.section].action.capitalized
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

extension VariationDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
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
