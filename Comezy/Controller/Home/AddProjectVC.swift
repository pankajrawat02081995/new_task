//
//  AddProjectVC.swift
//  Comezy
//
//  Created by archie on 13/07/21.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import MobileCoreServices
import Foundation
import iOSPhotoEditor


class AddProjectVC: UIViewController, CLLocationManagerDelegate {
    //MARK: - Variables
    ///Variable
    let locationManager = CLLocationManager()
    var selectedIndex: Int?
    var fileName =  ""
    var fileSize : UInt64 = 0
    var arrayPath : URL?
    var imgName:String?
    var latitude:Double?
    var longitude:Double?
    var addressName:String?
    var addProjectData = [AddProjectModel]()
    var arrayOfAddedFiles = [String]()
    var arrayOfAreaActivity = [String]()
    var arrayOfAddedFilesURL = [String]()
    var arrayOfAreaActivityURL = [String]()
    var action = "ppt"
    //Add Project Model reference
    let objAddProjectModel = AddProjectViewModel.shared
    private var placesClient: GMSPlacesClient!
  
    //MARK: IBOutlets
    @IBOutlet weak var clientStack: UIStackView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtClientName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddProjectDetial: UITextView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var docsTxt: UITextField!
    @IBOutlet weak var btnAddFile: UIButton!
    @IBOutlet weak var btnAddFile2: UIButton!
    @IBOutlet weak var btnAddSOWFile: UIButton!
    @IBOutlet weak var collectionViewA: CustomCollectionViewA!
    @IBOutlet weak var collectionViewB: CustomCollectionViewB!
    @IBOutlet weak var collectionViewC: CustomCollectionSOW!
    @IBOutlet weak var btnNewSOWFile: UIButton!
    @IBOutlet weak var addressStackView: UIStackView!
    @IBOutlet weak var docsTxtHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var scopeOfWorkTextHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeightConstraint : NSLayoutConstraint!
   
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        self.objAddProjectModel.objCResult?.first_name =  " "
        self.objAddProjectModel.objCResult?.last_name = " "
        self.objAddProjectModel.objCResult?.phone = " "
        self.objAddProjectModel.objCResult?.email = " "
        
        txtClientName.delegate = self
        collectionViewA.delegate = self
        collectionViewB.delegate = self
        collectionViewA.dataSource = self
        collectionViewB.dataSource = self
        collectionViewA.reloadData()
        collectionViewB.reloadData()
        txtAddress.delegate = self
        placesClient = GMSPlacesClient.shared()
        txtAddress.isUserInteractionEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        addressStackView.addGestureRecognizer(tap)
        

        
    }
    
    //MARK: ViewDidLayoutSubs
    override func viewDidLayoutSubviews() {
  
    }
    
    //MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.txtClientName.text = self.objAddProjectModel.objCResult?.first_name
        print(self.objAddProjectModel.objCResult?.phone)
        self.txtPhoneNumber.text = self.objAddProjectModel.objCResult?.phone
        self.txtEmail.text = self.objAddProjectModel.objCResult?.email
    }
    
    
    //MARK: btnBack
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        present(placePickerController, animated: true, completion: nil)
    }
    //MARK: btnAddFile
    @IBAction func btnAddFile_action(_ sender: Any) {

        action = "ppt"
        
        selectedIndex = nil
        showImagePickerOption(delegate: self)
       
    }
    
    //MARK: btnAddClient
    @IBAction func btnAddClient_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .main, controller: ClientListVC()) as! ClientListVC
        self.navigationController?.pushViewController(vc, animated: true)
        txtClientName.endEditing(true)
    }
    
    @IBAction func btnAddScopeOfWork(_ sender: UIButton) {
        action = "SOW"
        
        selectedIndex = nil
        showImagePickerOption(delegate: self)


    }
    
    //MARK: btnApplicableToAreaAct
    //This is the Scope of work add file button action
    @IBAction func btnApplicableToAreaActivity_action(_ sender: Any) {
        action = "SOW"
        showImagePickerOption(delegate: self)
    }
    
    //MARK: btnNextAction
    @IBAction func btnNext_action(_ sender: Any) {
        var quotionValue:[String] = []

        
        //This code has no use
        var scopeValue = ""
        
        for i in arrayOfAreaActivityURL {
            scopeValue.append("\(i)")
        }
        print(quotionValue)
        print("scopeval"    ,scopeValue)
        
        //Same for this
        let qValue:[String] = []
        let Countdata:Int = arrayOfAddedFiles.count
        print(Countdata)

            print(qValue, "<===============#$%@#$#$^%#$^%@#$%@#============ q Value")
            print(scopeValue, "<=================#@$%@#$%@#$%#$^#$^%#============ scopeValue")
        self.objAddProjectModel.addProject(controller: self, name: txtName.text ?? "", address: addressName!, longitude:longitude ?? 0 ,latitude: latitude ?? 0 , client: self.objAddProjectModel.objCResult?.id ?? 0, add_project_detail: txtAddProjectDetial.text ?? "", quotation_presentation_pdf: self.arrayOfAddedFilesURL, scope_of_work: self.arrayOfAreaActivityURL)    { (success, message, type, project) in
            if success {
                
                //Pop up that takes to add people screen
                
                let vc = ConfirmViewController()
                vc.show()
                vc.btnYes.isHidden = true
                vc.btnNo.setTitle("Go", for: .normal)
                vc.confirmHeadingLabel.text = FieldValidation.kAddPeople
                vc.confirmDescriptionLabel.text = SuccessMessage.kProjectAddedWorker
                vc.noCallBack = {
                    
                    print("Added Project Id->", project?.id )
                    let vc = ScreenManager.getController(storyboard: .main, controller: PeopleVC()) as! PeopleVC
                    vc.ProjectId = project?.id
                    vc.isFromAddProject = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.showToast(message: SuccessMessage.kProjectAdded, font: .boldSystemFont(ofSize: 14.0))
                }
            } else {
                self.showAlert(message: FailureMessage.kErrorOccured)
            }
        }
    }
//    //Method to Picker Image
//    func imagePicker(sourceType: UIImagePickerController.SourceType)->UIImagePickerController{
//        let imagePicker = UIImagePickerController()
//        imagePicker.sourceType = sourceType
//        return imagePicker
//    }
//    //Method to Show Image Picker Option
//    func showImagePickerOption(){
//        let alertVC = UIAlertController(title:fileUploadPopUp.kUploadFile,message: fileUploadPopUp.kChooseAOption, preferredStyle: .actionSheet)
//        let cameraAction = UIAlertAction(title: fileUploadPopUp.kTakeAPhoto, style: .default){
//            [weak self] (action) in
//            guard let self = self else {
//                return
//            }
//
//            let cameraImagePicker = self.imagePicker(sourceType: .camera)
//            cameraImagePicker.delegate=self
//
//            self.present(cameraImagePicker, animated: true){
//        }
//    }
//        let libraryAction = UIAlertAction(title: fileUploadPopUp.kChooseFromGallery, style: .default){
//        [weak self] (action) in
//        guard let self = self else {
//            return
//        }
//
//        let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
//        libraryImagePicker.delegate=self
//        self.present(libraryImagePicker, animated: true){
//    }
//    }
//        let docuemntAction = UIAlertAction(title: fileUploadPopUp.kChooseADocument, style: .default){
//            [weak self] (action) in
//            guard let self = self else {
//                return
//            }
//            self.imgName = String("IMG_\(Date().millisecondsSince1970).png")
//                    let documentPicker = UIDocumentPickerViewController(documentTypes:  [String(kUTTypePDF),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)],  in: .import)
//
//                    documentPicker.delegate = self
//            self.present(documentPicker, animated: true){
//
//            }
//        }
//    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertVC.addAction(docuemntAction)
//        alertVC.addAction(cameraAction)
//        alertVC.addAction(libraryAction)
//        alertVC.addAction(cancelAction)
//        self.present(alertVC,animated: true,completion: nil)
//
//    }

}
//MARK: - Extension AddProjectVC For Image Picker Controller
extension AddProjectVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate,PhotoEditorDelegate{
    func canceledEditing() {
        print("Canceled")
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)

        var uploadUrls = [URL]()


                  let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage


                   imgName = String("IMG_\(Date().millisecondsSince1970).png")
                  print("Image_NAME------>",imgName)
                  let imgName = String("IMG_\(Date().millisecondsSince1970).png")

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
        if let safeImageName = imgName {
            let localPath = documentDirectory.appending(safeImageName)
            
            
            
            let data = image.jpegData(compressionQuality: 0.3)! as NSData
            
            data.write(toFile: localPath, atomically: true)
            
            let photoURL = URL.init(fileURLWithPath: localPath)
            
            var uploadUrls = [URL]()
            
            
           uploadUrls.append(photoURL)
            
            uploadFile(urls: uploadUrls[0])
        }
        
    }
}


//MARK: Custom Funcs
extension AddProjectVC: UITextFieldDelegate, UIDocumentPickerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    
    //MARK: InitialLoad
    @objc func handleTap(){
        let vc = ScreenManager.getController(storyboard: .main, controller: ClientListVC()) as! ClientListVC
        self.navigationController?.pushViewController(vc, animated: true)
        txtClientName.endEditing(true)
    }
    func initialLoad() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        txtClientName.isUserInteractionEnabled = false
        clientStack.addGestureRecognizer(tap)
        //self.navigationBarTitle(headerTitle: "Add Project", backTitle: "")
        txtName.attributedPlaceholder = NSAttributedString(string: "Enter project name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 9808306)])
        
        txtPhoneNumber.isUserInteractionEnabled = false
        
        txtEmail.isUserInteractionEnabled = false
        
        
        txtAddress.attributedPlaceholder = NSAttributedString(string: "Enter project address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 9808306)])
        
        
        txtClientName.attributedPlaceholder = NSAttributedString(string: "Eg: John Doe", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 9808306)])

//        
        self.btnNext.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        self.btnNext.clipsToBounds = true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtClientName {

        }
        if textField == txtAddress {

        }
                
        
    }
    
    //MARK: DocumentPicker
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        uploadFile(urls: urls[0])
        
    }
    //Upload File
    func uploadFile(urls:URL){
        //MARK: Quotation Mulit upload
        if action == "ppt"{
            if arrayOfAddedFiles.count < 10 || selectedIndex != nil{
                print(selectedIndex)
                let date = Date()
                let format = DateFormatter()
                format.dateFormat = DateTimeFormat.kDateTimeFormat
                let timestamp = format.string(from: date)
                showProgressHUD(message: "")
               // print("urls[0]", urls[0])
                arrayPath = urls
                AWSS3Manager.shared.uploadImageFile(fileUrl: urls, fileName: "\(AWSFileDirectory.PUBLIC)\(AWSFileDirectory.QUOTATION_FOLDER)\(AWSFileDirectory.QUOTATION_FILE)/\(arrayPath!.lastPathComponent)") { (progress) in
                    print(progress)
                } completion: { (resp, error) in
                    if error == nil {
                        self.hideProgressHUD()
                        let file = resp as! String
                        print(file)
                        self.arrayOfAddedFilesURL.append(file)
                        print(self.arrayOfAddedFilesURL)
                        self.arrayOfAddedFiles.append(self.arrayPath!.lastPathComponent)
                        if self.arrayOfAddedFiles.count == 10 {
                            DispatchQueue.main.async {
                                self.btnAddFile.isHidden = true
                            }
                        }
                        self.stackViewHeightConstraint.constant = CGFloat(60 * self.arrayOfAddedFiles.count)
                        self.view.layoutIfNeeded()
                        self.collectionViewA.reloadData()
                    } else {
                        self.showAlert(message: error?.localizedDescription ?? "")
                    }
                }
                
            } else {
                btnAddFile.isHidden = true
            }
        }
        //MARK: SOW Multi Upload
        //Create SOW multi upload
        else if (action == "SOW") {
            if arrayOfAreaActivity.count < 10 || selectedIndex != nil {
                let date = Date()
                let format = DateFormatter()
                format.dateFormat = DateTimeFormat.kDateTimeFormat
                let timestamp = format.string(from: date)
                showProgressHUD(message: "")
                print("urls[0]", urls)
                arrayPath = urls
                AWSS3Manager.shared.uploadImageFile(fileUrl: urls, fileName: "\(AWSFileDirectory.PUBLIC)\(AWSFileDirectory.SOW_FOLDER)/\(AWSFileDirectory.SOW_FILE)/\(arrayPath?.lastPathComponent ?? timestamp)") { progress in
                    print(progress)
                } completion: { response, error in
                    if error == nil {
                        self.hideProgressHUD()
                        let file = response as! String
                        print(file)
                        self.arrayOfAreaActivityURL.append(file)
                        print(self.arrayOfAreaActivityURL)
                        self.arrayOfAreaActivity.append(self.arrayPath!.lastPathComponent)
                        if self.arrayOfAreaActivity.count == 10 {
                            DispatchQueue.main.async {
                                self.btnAddSOWFile.isHidden = true
                            }
                        }
                        self.scopeOfWorkTextHeightConstraint.constant = CGFloat(60 * self.arrayOfAreaActivity.count)
                        self.view.layoutIfNeeded()
                        DispatchQueue.main.async {
                            self.collectionViewB.reloadData()
                        }
                    } else {
                        self.showAlert(message: error?.localizedDescription ?? "An error occured, please try again later")
                    }
                }

            } else {
                btnAddSOWFile.isHidden = true
            }
        }
        print("9897896723412890-=3546789067890",urls)
        print(arrayOfAddedFiles)
        print(arrayOfAreaActivity)
    }
    //MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewA {
            return arrayOfAddedFiles.count
        } else {
            return arrayOfAreaActivity.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if let a = collectionView as? CustomCollectionViewA {
            let cell = a.dequeueReusableCell(withReuseIdentifier: "AddedFileCell", for: indexPath) as! AddedFileCell
            let item = arrayOfAddedFiles[indexPath.row]
            print("AddedFileCell .. ", item)
            cell.fileName?.text = item
            cell.fileName.textAlignment = .center
            print(cell.fileName?.text,cell.frame.height, "<==================== Printing AddedFileCell")
            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddedSOWFileCell", for: indexPath) as! AddedSOWFileCell
            print(cell.reuseIdentifier)
            let item = arrayOfAreaActivity[indexPath.row]
            print(item, "<==================== Printing AddedSOWFileCell item")
            cell.fileNameSOW?.text = item
            print(type(of: cell))
            print("AddedSOWFileCell .. ", item)
            cell.fileNameSOW?.text = item
            cell.fileNameSOW?.textAlignment = .center
            print(cell.fileNameSOW?.text,cell.frame.height, cell.fileNameSOW?.frame.height, "<==================== Printing AddedSOWFileCell.filename")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let collectionViewWidth = self.collectionViewA.bounds.size.width
            return CGSize(width: collectionViewWidth, height: 50)
        }
    
}

extension AddProjectVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)

    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)

    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
       UIApplication.shared.isNetworkActivityIndicatorVisible = true
     }

     func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
       UIApplication.shared.isNetworkActivityIndicatorVisible = false
     }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        print("\(place.coordinate.latitude)")
        
        self.txtAddress.text = place.name
        self.addressName = place.name ?? ""
        self.latitude = place.coordinate.latitude
        self.longitude = place.coordinate.longitude
        dismiss(animated: true, completion: nil)
//        navigationController?.popViewController(animated: true)
    }
}



