//
//  IncidentReportDetailVC.swift
//  Comezy
//
//  Created by aakarshit on 30/06/22.
//

import UIKit
import Kingfisher

class IncidentReportDetailVC: UIViewController {

    //Variables
    var objIncidentDetails: IncidentResult?
    var objIncidentListVM = IncidentReportListViewModel()
    var incidentId: Int?
    var myCommentList = [CommentResult]()
    let objCommentListViewModel = CommentListViewModel()
    var variationResponseStatus: String?
    var loggedInUserId: Int?
    var variationDocsArray: [String?]?
    var loggedInUserOcc: String?
    var projectId: Int?
    var didEdit = true
    
    //MARK: - IB outlet
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var dateOfIncident: UILabel!
    @IBOutlet weak var timeOfIncident: UILabel!
    @IBOutlet weak var descriptionOfIncident: UILabel!
    @IBOutlet weak var varSenderNameLabel: UILabel!
    @IBOutlet weak var varSenderEmailLabel: UILabel!
    @IBOutlet weak var noCommentsLabel: UILabel!
    @IBOutlet weak var senderDetailView: UIView!
    @IBOutlet weak var senderImageView: UIImageView!
    @IBOutlet weak var variationCommentTableView: VariationCommentTableView!
    @IBOutlet weak var variationDocsCollView: VariationDocsCollView!
    @IBOutlet weak var noDocStackVertConstraint: NSLayoutConstraint!
    @IBOutlet weak var docsStackView: UIStackView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblWitnessToIncident: UILabel!
    @IBOutlet weak var lblWitnessContact: UILabel!
    @IBOutlet weak var witnessImageView: UIImageView!
    @IBOutlet weak var lblDateOfIncidentReported: UILabel!
    @IBOutlet weak var lblTimeOfIncidentReported: UILabel!
    @IBOutlet weak var lblPreventiveActionTaken: UILabel!
    
    //MARK: - View controller Life cycler
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        variationCommentTableView.contentInsetAdjustmentBehavior = .never
        loggedInUserId = UserDefaults.getInteger(forKey: "userId")
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(didEdit)
        if didEdit == true {
            objIncidentListVM.getList(size: "1000", page: 1, project_id: projectId ?? 0) { success, resp, errorMsg in
                if success {
                    let detail = resp?.results.first(where: { result in
                        result.id == self.incidentId
                    })

                    self.objIncidentDetails = detail
                    
                    DispatchQueue.main.async {
                        self.updateUI()
                    }
                }
            }
        }

    }
    
    override func viewDidLayoutSubviews() {
        self.btnDelete.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        self.btnDelete.clipsToBounds = true
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
    //MARK: Initial Load
    func initialLoad() {
        print(loggedInUserId)
        updateUI()
        variationCommentTableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        objCommentListViewModel.getCommentList(module: "incident_report", module_id: incidentId ?? 34, size: 1000, page: 1) { success, comments, msg in
            if success {
                
                guard let safeComments = comments else { return }
                self.myCommentList = safeComments.reversed()
                self.variationCommentTableView.reloadData()
                print(self.myCommentList)
                self.toggleCommentLabel()

            } else {
                self.showAlert(message: msg)
            }
        }
        
        
        
        
        
        
    }
    
    //MARK: Update UI
    func updateUI() {
        let ref = objIncidentDetails
        variationDocsArray = ref?.files
        if variationDocsArray?.count ?? 0 < 1 {
             noDocStackVertConstraint.constant = 20
            docsStackView.isHidden = true
        } else {
            docsStackView.isHidden = false
            noDocStackVertConstraint.constant = 150
        }
        
        variationDocsCollView.reloadData()
        senderImageView.layer.cornerRadius = senderImageView.height / 2
        senderImageView.layer.borderWidth = 3
        senderImageView.layer.borderColor = UIColor(named: colorString.AppBrightGreenColor)?.cgColor
        witnessImageView.layer.cornerRadius = senderImageView.height / 2
        witnessImageView.layer.borderWidth = 3
        witnessImageView.layer.borderColor = UIColor(named: colorString.AppBrightGreenColor)?.cgColor
        senderDetailView.layer.cornerRadius = 20
        
        dateOfIncident.text = ref?.dateOfIncident
        timeOfIncident.text = ref?.timeOfIncident

        descriptionOfIncident.text = ref?.descriptionOfIncident
        lblPreventiveActionTaken.text = ref?.preventativeActionTaken
        lblTimeOfIncidentReported.text = ref?.timeOfIncidentReported
        lblDateOfIncidentReported.text = ref?.dateOfIncidentReported
        lblWitnessContact.text = ref?.witnessOfIncident?.phone
        //MARK: Manage who can delete and edit
        if(ref?.witnessOfIncident?.firstName != nil && ref?.witnessOfIncident?.firstName != ""){
            if let firstName = ref?.witnessOfIncident?.firstName, let lastName = ref?.witnessOfIncident?.lastName {
                lblWitnessToIncident.text =  firstName + " " + lastName
            }
        }else{
            witnessImageView.isHidden = true
            lblWitnessToIncident.text =  ref?.visitor_witness
            lblWitnessContact.text = ref?.visitor_witness_phone
        }
        
        if let firstName = ref?.personCompletingForm?.firstName, let lastName = ref?.personCompletingForm?.lastName {
            varSenderNameLabel.text =  firstName + " " + lastName
        }
        if let url = URL(string: (ref?.personCompletingForm?.profilePicture)!){
            senderImageView.kf.setImage(with: url)
            senderImageView.contentMode = .scaleAspectFill
        }
        if (ref?.witnessOfIncident?.profilePicture != "" && ref?.witnessOfIncident?.profilePicture != nil) {
            let url = URL(string: (ref?.witnessOfIncident?.profilePicture!)!)
            witnessImageView.kf.setImage(with: url)
            witnessImageView.contentMode = .scaleAspectFill
        }
        
        varSenderEmailLabel.text = ref?.personCompletingForm?.phone
        

        
    }
    
    //Method to toggle comment label
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
        let vc = ScreenManager.getController(storyboard: .safety, controller: EditIncidentReportVC()) as! EditIncidentReportVC
        vc.objIncidentDetails = self.objIncidentDetails
        vc.incidentId = self.incidentId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBack_action(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDelete_action(_ sender: Any) {
        showAppAlert(title: "Delete Incident Report", message: "Do you want to delete this incident report?") {
            self.objIncidentListVM.deleteIncidentReport(id: self.incidentId ?? 0) { success, response, msg in
                if success {
                    DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        self.showToast(message: "Variation Deleted Successfully")
                        }
                    }
                }
            }
        }
    


    @IBAction func btnAddComment_action(_ sender: Any) {
        let vc = AddCommentViewController()
        vc.show()
        vc.callback = {
            
            if vc.commentTextField.text == commmentSectionMessage.writeComment || vc.commentTextField.text == "" || vc.commentTextField.text == commmentSectionMessage.cantPostEmptyComment {
                vc.commentTextField.text = commmentSectionMessage.cantPostEmptyComment
            } else {
                self.objCommentListViewModel.getAddComment(controller: self, module: "incident_report", comment: vc.commentTextField.text!, moduleId: self.incidentId ?? 0) { success, addTaskList, errorMsg in
                    
                    if success {
                        self.showToast(message: SuccessMessage.kCommentSuccess, font: .boldSystemFont(ofSize: 14.0))

                        self.objCommentListViewModel.getCommentList(module: "incident_report", module_id: self.incidentId ?? 0, size: 1000, page: 1) { success, allCommments, msg in
                            if success {
                                guard let safeComments = allCommments else {return}
                                
                                self.myCommentList = safeComments.reversed()
                                
                                DispatchQueue.main.async {
                                    self.variationCommentTableView.reloadData()
                                    self.toggleCommentLabel()

                                }
                                
                            } else {
                        
                            }
                      
                        }
                        
                    }
                }
                vc.dismiss(animated: true)

            }

        }
    }

}

//MARK: - Extension Incident Report DetailVC
extension IncidentReportDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == variationCommentTableView {
            return 1
        } else {
            return 0
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
                if let url = URL(string: (myCommentList[indexPath.row].user?.profilePicture!)!){
                    cell.imgUser.kf.setImage(with: url)

                }

                let dateFormatter = DateFormatter()
                let tempLocale = dateFormatter.locale // save locale temporarily
                dateFormatter.locale = Locale(identifier: localeIdentifier.en_USA) // set locale to reliable US_POSIX
                dateFormatter.dateFormat = DateTimeFormat.kDateTimeFormat
                let date = dateFormatter.date(from: myCommentList[indexPath.row].createdTime ?? "")!
                dateFormatter.dateFormat = DateTimeFormat.kEE_MMM_d
                dateFormatter.locale = tempLocale // reset the locale
                let dateString = dateFormatter.string(from: date)
                print("EXACT_DATE : \(dateString)")
                cell.dateLabel?.text = dateString
                return cell
            } else {
                return UITableViewCell()
            }
        } else { return UITableViewCell() }
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

extension IncidentReportDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
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

