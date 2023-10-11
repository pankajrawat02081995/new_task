//
//  SiteRiskDetailVC.swift
//  Comezy
//
//  Created by aakarshit on 11/07/22.
//

import UIKit
import iOSPhotoEditor
import MobileCoreServices
import MaterialComponents.MaterialChips
import MaterialComponents
import iOSPhotoEditor

class SiteRiskDetailVC: UIViewController {
    
    var objSiteRiskDetail: SiteRiskAssessmentBannerList?
    var objResponseVM = SiteRiskResponseViewModel()
    var safetyId: Int?
    var size:Int = 1000
    
    //    let objVariationResponseData: VariationResponseModel?
    //    let objVariationResponseData: BaseResponse<VariationResponseDataModel>? = nil
    var myCommentList = [CommentResult]()
    let objCommentListViewModel = CommentListViewModel()
    var variationResponseStatus: String?
    var loggedInUserId: Int?
    var doc: String?
    var workerUploaded: String?
    var createdBy:Int?

    var loggedInUserOcc: String?
    var projectId: Int?
    var didEdit = true
    var arrayPath : URL?
    var arrayOfAddedVariations = [String]()
    var arrayOfAddedVariationsURL = [String]()

    @IBOutlet weak var lblProofFile: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var noWorkerResponse: NSLayoutConstraint!
    
    @IBOutlet weak var noProofFile: NSLayoutConstraint!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblAssignedTo: UILabel!
    @IBOutlet weak var noCommentsLabel: UILabel!
    @IBOutlet weak var variationCommentTableView: VariationCommentTableView!
    @IBOutlet weak var variationDocsCollView: VariationDocsCollView!
    @IBOutlet weak var noDocStackVertConstraint: NSLayoutConstraint!
    @IBOutlet weak var docsStackView: UIStackView!
    @IBOutlet weak var lblSiteRiskStatus: UILabel!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var lblWorkerResponse: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    var imageName: String?
    @IBOutlet weak var builderResponseStatus: UILabel!
    
    @IBOutlet weak var btnAddFile: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loggedInUserId = UserDefaults.getInteger(forKey: "userId")
        initialLoad()
        variationCommentTableView.contentInsetAdjustmentBehavior = .never
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
//    @IBAction func btnReject_action(_ sender: Any) {
//        if(arrayOfAddedVariationsURL.isEmpty){
//            showToast(message: "Please add proof before submission")
//        }else{
//
//            if let obj = objSiteRiskDetail, let projId = projectId {
//                print(obj.response)
////                objResponseVM.putSiteRiskResponse(siteRiskId:  1, response: "no", createdById: obj.createdBy.id ?? 1
////                                                  , assignedToId: obj.assignedTo.id ?? 1, projectId: projId, questionId: obj.question.id ?? 1,upload_file: self.arrayOfAddedVariationsURL[0] ?? "") { success, variationDetailResp, errorMsg in
////                    if success {
////                        self.navigationController?.popViewController(animated: true)
////                        self.showToast(message: "Response submitted succesfully")
////
////                    print("Success")
////                    } else {
////                        self.showToast(message:errorMsg ?? "Oops! An error occured!")
////                    }
//                //}
//            }
//        }
//
//    }
    @IBAction func btnReject_action(_ sender: Any) {
        if(arrayOfAddedVariationsURL.isEmpty){
            showToast(message: "Please add proof before submission")
        }else{

            if let obj = objSiteRiskDetail, let projId = projectId {
                print(obj.response)
                objResponseVM.putSiteRiskResponse(siteRiskId: obj.id ?? 1, response: SiteRiskListConst.statusNo, createdById: createdBy ?? 1
                                                  , assignedToId: obj.assignedTo.id ?? 1, projectId: projId, questionId: obj.question.id ?? 1,upload_file: self.arrayOfAddedVariationsURL[0] ?? "") { success, variationDetailResp, errorMsg in
                    if success {
                        self.backTwo()
                        self.showToast(message: SuccessMessage.kResponseSubmitted)

                    print("Success")
                    } else {
                        self.showToast(message:errorMsg ?? FailureMessage.kErrorOccured)
                    }
                }
            }
        }

    }
    
    
    @IBAction func btnAddFile(_ sender: Any) {
        showImagePickerOption(delegate:self)
    }
    @IBAction func btnAccept_action(_ sender: Any) {
        if(arrayOfAddedVariationsURL.isEmpty){
            showToast(message: FieldValidation.kAddProof)
        }else{
            if let obj = objSiteRiskDetail, let projId = projectId {
                print(obj.response)
                objResponseVM.putSiteRiskResponse(siteRiskId: obj.id ?? 1, response: SiteRiskListConst.statusYes, createdById: createdBy ?? 1
                                                  , assignedToId: obj.assignedTo.id ?? 1, projectId: projId, questionId: obj.question.id ?? 1,upload_file: self.arrayOfAddedVariationsURL[0] ?? "") { success, variationDetailResp, errorMsg in
                    if success {
                        self.backTwo()
                        self.showToast(message: SuccessMessage.kResponseSubmitted)

                    } else {
                        self.showToast(message:errorMsg ?? FailureMessage.kErrorOccured)
                    }
                }
            }
        }
        
    }
    
    //MARK: - Manage UI
    
    func manageUI(id:Int!){

    }
    //MARK: Initial Load
    func initialLoad() {
        print(loggedInUserId)
        updateUI()
        
        variationCommentTableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        
        objCommentListViewModel.getCommentList(module: "site_risk_assessment", module_id: safetyId ?? 34, size: size, page: 1) { success, comments, msg in
            if success {
                
                guard let safeComments = comments else { return }
                self.myCommentList = safeComments.reversed()
                self.variationCommentTableView.reloadData()
                print(self.myCommentList)
                self.toggleCommentLabel()
                
            } else {
            }
        }
        
        
        
        
        
        
    }
    
    //MARK: Update UI
    func updateUI() {
        let ref = objSiteRiskDetail
    
        if ref?.statusOption == "" {
            self.builderResponseStatus.text = SiteRiskListConst.statusPending
            self.builderResponseStatus.textColor = .systemYellow
        } else if ref?.statusOption == SiteRiskListConst.statusYes {
            self.lblWorkerResponse.isHidden = true
            self.lblSiteRiskStatus.isHidden = true
            self.lblProofFile.isHidden = true
            self.btnAddFile.isHidden = true
            self.noWorkerResponse.constant = 0
            self.builderResponseStatus.text = SiteRiskListConst.statusYes.capitalized
            self.builderResponseStatus.textColor = .systemGreen
        } else if ref?.statusOption == SiteRiskListConst.statusNo {
            self.lblWorkerResponse.isHidden = false
            self.lblSiteRiskStatus.isHidden = false
            
            self.builderResponseStatus.text = SiteRiskListConst.statusNo.capitalized
            self.builderResponseStatus.textColor = .systemRed
        }
       
        
        doc = ref?.file
        if doc == nil || doc == "" {
            noDocStackVertConstraint.constant = 10
            docsStackView.isHidden = true
        } else {
            docsStackView.isHidden = false
             noDocStackVertConstraint.constant = 150
        }
        
        variationDocsCollView.reloadData()
        
        lblQuestion.text = ref?.question.question
        if let firstName = ref?.assignedTo.firstName, let lastName = ref?.assignedTo.lastName {
            lblAssignedTo.text = firstName + " " + lastName
            
        }
        toggleResponseLabel()
        
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
    
    func toggleResponseLabel() {
        let id = objSiteRiskDetail?.assignedTo.id
            if loggedInUserId == id
                 {
                if objSiteRiskDetail?.response == "" {
                    lblSiteRiskStatus.text = SiteRiskListConst.statusPending
                    lblSiteRiskStatus.isHidden = true
                    btnNo.isHidden = false
                    btnYes.isHidden = false
                                    self.lblProofFile.isHidden = false
                                    self.btnAddFile.isHidden = false
                    lblSiteRiskStatus.textColor = .systemYellow
                } else if objSiteRiskDetail?.response == SiteRiskListConst.statusYes {
                    btnNo.isHidden = true
                    btnYes.isHidden = true
                    self.lblProofFile.isHidden = true
                    self.btnAddFile.isHidden = true
                    self.noProofFile.constant = 10
                    lblSiteRiskStatus.text = SiteRiskListConst.statusYes.capitalized
                    lblSiteRiskStatus.isHidden = false
                    lblSiteRiskStatus.textColor = .systemGreen
                } else if objSiteRiskDetail?.response == SiteRiskListConst.statusNo {
                    btnNo.isHidden = true
                    btnYes.isHidden = true
                    self.noProofFile.constant = 10
                    self.lblProofFile.isHidden = true
                    self.btnAddFile.isHidden = true
                    lblSiteRiskStatus.isHidden = false

                    lblSiteRiskStatus.text = SiteRiskListConst.statusNo.capitalized
                    lblSiteRiskStatus.textColor = .systemRed
                }
               
//                self.lblProofFile.isHidden = false
//                self.btnAddFile.isHidden = false
                } else {
                   // lblSiteRiskStatus.isHidden = false
                    if objSiteRiskDetail?.response == "" {
                        lblSiteRiskStatus.text = SiteRiskListConst.statusPending
                        lblSiteRiskStatus.textColor = .systemYellow
                    } else if objSiteRiskDetail?.response == SiteRiskListConst.statusYes {
                        btnNo.isHidden = true
                        btnYes.isHidden = true
                        lblSiteRiskStatus.text = SiteRiskListConst.statusYes.capitalized
                        lblSiteRiskStatus.isHidden = false
                        lblSiteRiskStatus.textColor = .systemGreen
                    } else if objSiteRiskDetail?.response == SiteRiskListConst.statusNo {
                        btnNo.isHidden = true
                        btnYes.isHidden = true
                        lblSiteRiskStatus.isHidden = false

                        lblSiteRiskStatus.text = SiteRiskListConst.statusNo.capitalized
                        lblSiteRiskStatus.textColor = .systemRed
                    }
                    btnNo.isHidden = true
                    btnYes.isHidden = true
                    self.lblProofFile.isHidden = true
                    self.btnAddFile.isHidden = true
                    self.noProofFile.constant = 10
                }
    }
        
    //MARK: Button Actions
    @IBAction func btnEdit_action(_ sender: Any) {
    }
    @IBAction func btnBack_action(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDelete_action(_ sender: Any) {
        }
    


    @IBAction func btnAddComment_action(_ sender: Any) {
        let vc = AddCommentViewController()
        vc.show()
        vc.callback = {
            
            if vc.commentTextField.text == commmentSectionMessage.writeComment || vc.commentTextField.text == "" || vc.commentTextField.text == commmentSectionMessage.cantPostEmptyComment {
                vc.commentTextField.text = commmentSectionMessage.cantPostEmptyComment
            } else {
                self.objCommentListViewModel.getAddComment(controller: self, module: "site_risk_assessment", comment: vc.commentTextField.text!, moduleId: self.safetyId ?? 0) { success, addTaskList, errorMsg in
                    
                    if success {
                        self.showToast(message: SuccessMessage.kCommentSuccess, font: .boldSystemFont(ofSize: 14.0))

                        self.objCommentListViewModel.getCommentList(module: "site_risk_assessment", module_id: self.safetyId ?? 0, size: self.size, page: 1) { success, allCommments, msg in
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
    
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
}

extension SiteRiskDetailVC: UITableViewDelegate, UITableViewDataSource {
    
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
                let data = try? Data(contentsOf: url)

                if let imageData = data {
                
                    cell.imgUser.image = UIImage(data: imageData)
                }
                }

                let dateFormatter = DateFormatter()
                let tempLocale = dateFormatter.locale // save locale temporarily
                dateFormatter.locale = Locale(identifier: localeIdentifier.en_USA) // set locale to reliable US_POSIX
                dateFormatter.dateFormat = DateTimeFormat.kDateTimeFormat
                let date = dateFormatter.date(from: myCommentList[indexPath.row].createdTime ?? "")!
                dateFormatter.dateFormat = DateTimeFormat.kEE_MMM_d
                dateFormatter.locale = tempLocale // reset the locale
                let dateString = dateFormatter.string(from: date)
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
    
    
}

extension SiteRiskDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = variationDocsCollView.dequeueReusableCell(withReuseIdentifier: "VariationDocsCollCell", for: indexPath) as! VariationDocsCollCell
        let item = doc
        let itemAsURL = URL(string: item ?? "Work in progress")
        print("url ->", item)
        if let safeItemAsURL = itemAsURL {
            let fileName = safeItemAsURL.lastPathComponent
            cell.fileImageView.image = checkFileType(FileName: fileName)

        }
        print(item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ScreenManager.getController(storyboard: .main, controller: WebViewVC()) as! WebViewVC
        vc.docURL = doc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

}

//MARK: - Extension Site Risk Detail VC For Image Picker Controller
extension SiteRiskDetailVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, PhotoEditorDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        
        var uploadUrls = [URL]()
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        let imgName = "IMG_\(String(Date().millisecondsSince1970)).png"
        
        imageName = imgName
        
        let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
        
        //PhotoEditorDelegate
        photoEditor.photoEditorDelegate = self
        
        //The image to be edited
        photoEditor.image = image
        
        //Stickers that the user will choose from to add on the image
        //        photoEditor.stickers.append(UIImage(named: "sticker" )!)
        
        //Optional: To hide controls - array of enum control
        photoEditor.hiddenControls = [.share, .save, .sticker, .crop]
        
        //Optional: Colors for drawing and Text, If not set default values will be used
        photoEditor.colors = [.red, .yellow, .orange, .green, .brown, .magenta, .gray, .cyan, .blue, .lightGray, .purple, .systemIndigo, .systemPink, .systemTeal]
        
        //Present the View Controller
        photoEditor.modalPresentationStyle = .fullScreen
        navigationController?.present(photoEditor, animated: true, completion: nil)
    }
    
    func doneEditing(image: UIImage) {
        
        let documentDirectory = NSTemporaryDirectory()
        if let safeImageName = imageName {
            let localPath = documentDirectory.appending(safeImageName)
            
            
            
            let data = image.jpegData(compressionQuality: 0.3)! as NSData
            
            data.write(toFile: localPath, atomically: true)
            
            let photoURL = URL.init(fileURLWithPath: localPath)
            
            var uploadUrls = [URL]()
            
            
            uploadUrls.append(photoURL)
            
            uploadFile(urls: uploadUrls)
        }
        
    }
    
    func canceledEditing() {
        print("Canceled")
    }
    
}

//MARK: Document Picker
extension SiteRiskDetailVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        uploadFile(urls: urls)
        }
    
    func uploadFile(urls:[URL]){
        
                let date = Date()
                let format = DateFormatter()
        format.dateFormat = DateTimeFormat.kDateTimeFormat
                let timestamp = format.string(from: date)
                showProgressHUD(message: "")
                print("urls[0]", urls[0])
                arrayPath = urls[0]
                AWSS3Manager.shared.uploadImageFile(fileUrl: urls[0], fileName: "\(AWSFileDirectory.PUBLIC)siteRiskDocumentFiles/\(arrayPath?.lastPathComponent ?? "SiteRiskDocument\(timestamp)")") { (progress) in
                    print(progress)
                } completion: { (resp, error) in
                    if error == nil {
                        self.hideProgressHUD()
                        let file = resp as! String
                        self.view.layoutIfNeeded()
                        self.arrayOfAddedVariationsURL.append(file)
                        
                        
                        self.arrayOfAddedVariations.append(urls[0].lastPathComponent)
                        self.btnAddFile.setTitle(self.arrayOfAddedVariations[0], for: .normal)
                                                
                    }else{
                        
                    }
                }
    }
    
}

