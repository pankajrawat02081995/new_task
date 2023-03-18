//  AddSiteRiskVC.swift
//  Comezy
//  Created by aakarshit on 06/07/22.

import UIKit
import MobileCoreServices
import DropDown
import iOSPhotoEditor

class AddSiteRiskVC: UIViewController {
    
    var loggedInUserOcc: String?
    var ProjectId: Int?
    let objVM = AddSiteRiskViewModel()
    var myList = [QuestionResult]()
    var arrayOfAddedVariations = [String]()
    var arrayOfAddedVariationsURL = [String]()
    var arrayPath : URL?
    var didUpdateDoc = false
    var myArrayOfSelectedQuestions = [[String: Any]]()
    var fileIndex: Int?
    var showAllPeopleCallBack: (()->Void)?
    var personSelected = false
    var peopleList = PeopleListViewModel.shared.peopleListDataDetail
    var imageName: String?
    
    
    
    @IBOutlet weak var lblNoROI: UILabel!
    @IBOutlet weak var tblROIs: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        loggedInUserOcc = kUserData?.user_type ?? ""
        // tblROIs.register(UINib(nibName: "AddSiteRiskCell", bundle: nil), forCellReuseIdentifier: "AddSiteRiskCell")
        if !personSelected {
            getDocsListDetails()
        } else {
            personSelected = false
        }
        configureTableView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    func showAllPeople(cellIndex: Int, txtAssign: UITextField) {
        
        let dropDown = DropDown()
        let dropDownValues = peopleList.map { worker in
            "\(worker.firstName ?? "FirstName") \(worker.lastName ?? "LastName")"
        }
        let dropDownValuesId = peopleList.map { worker in
            worker.id ?? 0
        }
        dropDown.anchorView = txtAssign
        if dropDownValues.count > 0 {
            dropDown.dataSource = dropDownValues
        } else {
            dropDown.dataSource = ["No people on project yet"]
        }
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if dropDownValues.count > 0 {
                self.myList[cellIndex].personName = dropDownValues[index]
                self.myList[cellIndex].person = dropDownValuesId[index]
                self.arrayOfAddedVariations = []
                self.arrayOfAddedVariationsURL = []
                self.tblROIs.reloadData()
            } else {
                
            }
        }
    }
    
    func getDocsListDetails() {
        
        objVM.getList(size: "1000", page: 1, project_id: ProjectId ?? 0) { success, resp, errorMsg in
            if success {
                self.myList = resp!.results
                self.NoDocs()
                DispatchQueue.main.async {
                    self.tblROIs.reloadData()
                }
            } else {
                self.showAlert(message: errorMsg)
            }
        }
        
        
    }
    
    func NoDocs() {
        if myList.count == 0{
            lblNoROI.isHidden = false
            tblROIs.isHidden = true
        } else {
            lblNoROI.isHidden = true
            tblROIs.isHidden = false
        }
    }
    
    //MARK: Button Done
    @IBAction func btnDone_action(_ sender: Any) {
        
        myArrayOfSelectedQuestions = []
        print(myList)
        
        let filteredList = myList.filter { question in
            if(question.builderResponse == "" || question.builderResponse == SiteRiskListConst.statusNo ){
                return question.person != -1
                
            }else{
                    return true
                }
        }
        
        print(filteredList)
        for question in filteredList {
            if question.builderResponse == SiteRiskListConst.statusYes {
                let questionDictionary: [String: Any] = ["file": question.fileUrl ?? "",
                                                         "project": ProjectId ?? 1 as Any,
                                                         "question": question.id ?? 1 as Any,
                                                         "status_option": question.builderResponse as Any
                ]
                myArrayOfSelectedQuestions.append(questionDictionary)
            }else if question.builderResponse == SiteRiskListConst.statusNo{
              //  if question.person == nil{
                  //  print("Please add worker")
                //}else{
                    
                    let questionDictionary: [String: Any] = ["file": question.fileUrl ?? "",
                                                             "project": ProjectId as Any,
                                                             "question": question.id ?? 1 as Any,
                                                             "assigned_to": question.person ?? 1 as Any,
                                                             "status_option": question.builderResponse as Any
                    ]
                    myArrayOfSelectedQuestions.append(questionDictionary)
                }
     
        }
        print(myArrayOfSelectedQuestions)

                if myArrayOfSelectedQuestions.count == 0 {
                    //self.showToast(message: "Please ")
                    Toast.show(message: FieldValidation.kAddOneQuestion, controller: self)
                } else {
                    self.objVM.createSiteRisk(dict: myArrayOfSelectedQuestions) { success, variationModel, errorMsg in
                        if success {
                            self.navigationController?.popViewController(animated: true)
                            self.showToast(message: SuccessMessage.kSiteRiskAdded)
        
                        } else {
                            self.showToast(message:errorMsg ?? FailureMessage.kErrorOccured)
                        }
        
                }
                }
        
    }

    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHome_action(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    


}
//MARK: TableView
extension AddSiteRiskVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(myList.count)
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddSiteRiskCell", for: indexPath) as! AddSiteRiskCell
        let item = myList[indexPath.row]
        print(item)
        cell.lblQuestion.text = item.question
        cell.ProjectId = ProjectId
        cell.viewRef = self
        cell.callback = {
            self.fileIndex = indexPath.row
            self.showImagePickerOption(delegate: self)
//            let documentPicker = UIDocumentPickerViewController(documentTypes:  [String(kUTTypePDF),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)],  in: .import)
//
//            documentPicker.delegate = self
//            self.present(documentPicker, animated: true)
        }
        if(item.builderResponse != "" ){
            cell.builderResponse.isHidden = false
            cell.builderResponse.text = item.builderResponse
            cell.builderResponseStack.isHidden = true
            if(item.builderResponse == SiteRiskListConst.statusNo){
                cell.selectPersonStack.isHidden = false
                cell.btnAddFile.isHidden = false
                cell.btnAddFileHeight.constant = 35
                cell.lbFile.isHidden = false
                cell.lblFileHeight.constant = 21
                cell.selectPersonStackHeightConstaint.constant = 71

            }else{
                cell.selectPersonStack.isHidden = true
                cell.btnAddFile.isHidden = false
                cell.btnAddFileHeight.constant = 35
                cell.lbFile.isHidden = false
                cell.lblFileHeight.constant = 21
                cell.selectPersonStackHeightConstaint.constant = 0


            }
        }else{
            cell.builderResponse.isHidden = true
            cell.builderResponse.text = item.builderResponse
            cell.builderResponseStack.isHidden = false
            cell.selectPersonStack.isHidden = true
            cell.btnAddFile.isHidden = true
            cell.btnAddFileHeight.constant = 0
            cell.lbFile.isHidden = true
            cell.lblFileHeight.constant = 0
            cell.selectPersonStackHeightConstaint.constant = 0


        }
        cell.rejectCallback = {
            self.myList[indexPath.row].builderResponse = SiteRiskListConst.statusNo
            self.tblROIs.reloadData()
        }
        cell.acceptCallback = {
            self.myList[indexPath.row].builderResponse = SiteRiskListConst.statusYes
            self.tblROIs.reloadData()

        }
        cell.currentCellIndex = indexPath.row

        
        if let fileName = myList[indexPath.row].file {
            cell.btnAddFile.setTitle(fileName, for: .normal)
            cell.btnAddFile.isUserInteractionEnabled = false
        } else {
            cell.btnAddFile.setTitle("+ Add File", for: .normal)
            cell.btnAddFile.isUserInteractionEnabled = true
        }
        cell.personSelectedCallBack = { id in
            
            self.myList[indexPath.row].person = id
            
        }
        
        
            cell.txtAssign.text = myList[indexPath.row].personName
       // }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let fileName = myList[indexPath.row].file
        print(fileName)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
        }

        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

            return cellSize.size

        }
    
    func configureTableView() {
        tblROIs.register(UINib(nibName: "AddSiteRiskCell", bundle: nil), forCellReuseIdentifier: "AddSiteRiskCell")
    }
    

    
}
//MARK: - Extension EditVariationsVC For Image Picker Controller
extension AddSiteRiskVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, PhotoEditorDelegate {
    
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
extension AddSiteRiskVC: UIDocumentPickerDelegate {
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
                        
                        if let i = self.fileIndex {
                            self.myList[i].file = self.arrayPath?.lastPathComponent ?? "DailyLogDocument\(timestamp)"

                            self.myList[i].fileUrl = file

                            self.fileIndex = nil
                            self.tblROIs.reloadData()
                        }
                        self.didUpdateDoc = true
                        } else {
                            self.showAlert(message: error?.localizedDescription ?? "")
                        }
                    }
    }
    
}

