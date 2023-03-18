//
//  AddDailyLogVC.swift
//  Comezy
//
//  Created by shiphul on 23/12/21.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import MobileCoreServices
import iOSPhotoEditor

class AddDailyLogVC: UIViewController {
    
    //MARK: - Variables
    var editLocation: String?
    var editNotes: String?
    var editDocuments = [String]()
    var editDocumentsURL = [String]()
    var action = "added_file"
    let locationManager = CLLocationManager()
    var selectedIndex: Int?
    var selectedIndex2: Int?
    var fileName =  ""
    var fileSize : UInt64 = 0
    var objDailyLogListViewModel = DailyLogListViewModel()
    var ProjectId: Int?
    var dailylog_Id: Int?
    var arrayPath : URL?
    var imageName: String?
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtNotes: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnAddFile: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    private var placesClient: GMSPlacesClient!
    @IBOutlet weak var stackViewHeightConstraint : NSLayoutConstraint!
    var arrayOfAddedFiles = [String]()
    var arrayOfAddedFilesURL = [String]()
    var latitude:Double?
    var longitude:Double?
    
    //MARK: - LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
        txtLocation.delegate = self
        print(UserDefaults.getString(forKey: "location"))
        editLocation = UserDefaults.getString(forKey: "location")

        placesClient = GMSPlacesClient.shared()
        //editVc()
        print("\(editDocuments)")
        collectionView.reloadData()
        //editDocsConstraints()
        //show Editable values
        editValues()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    func editValues(){
        txtLocation.text = editLocation
        txtNotes.text = editNotes
        
        
    }

    //MARK: - Button Back Pressed
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Button Home Pressed
    @IBAction func btnHome_action(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    //MARK: - Button Add File Pressed
    @IBAction func btnAddFile_action(_ sender: Any) {
  
        selectedIndex = nil
        showImagePickerOption(delegate:self)
    }
    //MARK: - Button Done Pressed
    @IBAction func btnDone_action(_ sender: Any) {

        //MARK: Bug: Passed static lat and long
        self.objDailyLogListViewModel.addDailyLog(controller: self,project: String(describing: ProjectId!) ,location: txtLocation.text ?? "", latitude: self.latitude ?? 0 ,longitude: self.longitude ?? 0,documents: arrayOfAddedFilesURL, notes: txtNotes.text ?? "") { (success, message, type) in
            print(self.longitude)
            print(self.latitude)
            if success {
                let vc = ScreenManager.getController(storyboard: .main, controller: DailyLogListVC()) as! DailyLogListVC
                vc.ProjectId = self.ProjectId
                self.navigationController?.pushViewController(vc, animated: true)
                self.showAlert(message: SuccessMessage.kDailyLogAdded)
               
            } else {
                self.showAlert(message: message )
            }
        }
    }
    
    @IBAction func btnUpdateDailyLog_action(_ sender: Any) {
        
        self.objDailyLogListViewModel.getEditDailyLog(controller: self, project: ProjectId ?? 0 ,dailylog_id: dailylog_Id ?? 0,location: txtLocation.text ?? "",latitude: latitude!,longitude: longitude! ,documents: editDocumentsURL, notes: txtNotes.text ?? "") { (success, message, type) in
            if success {
                let vc = ScreenManager.getController(storyboard: .main, controller: DailyLogListVC()) as! DailyLogListVC
                //vc.ProjectId = self.ProjectId
                vc.editDocumentURL = self.arrayOfAddedFilesURL
                vc.arrayPath = self.arrayPath
                self.navigationController?.pushViewController(vc, animated: true)
                self.showAlert(message: SuccessMessage.kDailyLogUpdate)
            }else {
                self.showAlert(message: "\(message)")
            }
        }
    }

    
}
//MARK: - Extension AddDailyLogVC For Image Picker Controller
extension AddDailyLogVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, PhotoEditorDelegate {
    
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
            
            uploadFile(urls: uploadUrls[0])
        }
        
    }
    
    func canceledEditing() {
        print("Canceled")
    }
    
}
//MARK: - Extension of AddDailyLogVC UICollectionView
extension AddDailyLogVC: UICollectionViewDelegate, UICollectionViewDataSource ,UIDocumentPickerDelegate, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
            print("Place address: \(place.formattedAddress)")
            print("Place attributions: \(place.attributions)")
        print("Place latitude -> ",place.coordinate.latitude)
        txtLocation.text = place.name
        self.latitude = place.coordinate.latitude
        self.longitude = place.coordinate.longitude
        
            dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtLocation{
            let placePickerController = GMSAutocompleteViewController()
            placePickerController.delegate = self
            present(placePickerController, animated: true, completion: nil)
            
        }
    }
    
    //MARK: Document Picker
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
           
uploadFile(urls: urls[0])
    }
    func uploadFile(urls:URL){
        if arrayOfAddedFiles.count < 10 || selectedIndex != nil{
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let timestamp = format.string(from: date)
            showProgressHUD(message: "")
            print("urls[0]", urls)
            arrayPath = urls
            print(arrayPath,arrayPath?.lastPathComponent)
            AWSS3Manager.shared.uploadImageFile(fileUrl: urls, fileName: "\(AWSFileDirectory.PUBLIC)\(AWSFileDirectory.DAILY_LOG_DOCUMENT_FOLDER)/\(AWSFileDirectory.DAILY_LOG_DOCUMENT_FILE)\(arrayPath!.lastPathComponent)") { (progress) in

                print(progress)
            } completion: { (resp, error) in
                if error == nil {
                    self.hideProgressHUD()
                    
                    let file = resp as! String     
                    self.arrayOfAddedFilesURL.append(file)
                  
                    self.arrayOfAddedFiles.append(urls.lastPathComponent)
                    
                    if self.arrayOfAddedFiles.count == 10 {
                        DispatchQueue.main.async {
                            self.btnAddFile.isHidden = true
                        }
                    }
                    self.stackViewHeightConstraint.constant = CGFloat(60 * self.arrayOfAddedFiles.count)
                    self.view.layoutIfNeeded()
                    self.collectionView.reloadData()
                } else {
                    self.showAlert(message: error?.localizedDescription ?? "")
                }
            }
            
            
            
        } else {
//                btnAddFile.isHidden = true
        }
    }
    
    //MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dailylog_Id == nil{
            return arrayOfAddedFiles.count
        } else {
            return editDocuments.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddedFileCell", for: indexPath) as! AddedFileCell
        if dailylog_Id == nil {
            let item = arrayOfAddedFiles[indexPath.row]
            print("AddedFileCell  .. ", item)
            cell.fileName?.text = item
            cell.fileName?.textAlignment = .center
            cell.isUserInteractionEnabled = false
        } else if dailylog_Id != nil {
            let item2 = editDocuments[indexPath.row]
            cell.fileName?.text = item2
            cell.fileName?.textAlignment = .center
       }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        selectedIndex2 = indexPath.row
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let collectionViewWidth = self.collectionView.bounds.size.width
            return CGSize(width: collectionViewWidth, height: 50)
        }
    
    
}

