//
//  EditDailyLogVC.swift
//  Comezy
//
//  Created by shiphul on 24/12/21.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import MobileCoreServices
import iOSPhotoEditor

class EditDailyLogVC: UIViewController {
    var ProjectId: Int?
    var dailylog_Id : Int?
    var previousRef: DailyLogDetailVC?
    var editLocation : String?
    var editNotes : String?
    var editDocuments = [String]()
    var editDocumentsURL = [String]()
    let locationManager = CLLocationManager()
    var selectedIndex: Int?
    var fileName =  ""
    var item : DailyLogResult?
    var fileSize : UInt64 = 0
    var objDailyLogListViewModel = DailyLogListViewModel()
    private var placesClient: GMSPlacesClient!
    var arrayPath:URL?
    var longitude:Double?
    var latitude:Double?
    var imageName: String?
    @IBOutlet weak var stackViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtNotes: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnAddFile: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtLocation.delegate = self
        placesClient = GMSPlacesClient.shared()
        print("\(editDocuments)")
        collectionView.reloadData()
        editDocsConstraints()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        editValues()
        collectionView.reloadData()
    }
    
    func editValues(){
        txtLocation.text = item?.location?.name
        txtNotes.text = item?.notes
    }
    func editDocsConstraints() -> String{
            if editDocuments.count <= 10 {
                var file_name = NSURL(fileURLWithPath: String(describing: arrayPath)).lastPathComponent!
                self.stackViewHeightConstraint.constant = CGFloat(60 * self.editDocuments.count)
                btnAddFile.isHidden = false
                return file_name
            }else{
                btnAddFile.isHidden = true
            }
        return ""
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
  
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHome_action(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnAddFile_action(_ sender: Any) {
        selectedIndex = nil
        showImagePickerOption(delegate:self)
    }
    
    //MARK: Bug: Static lat and long passed
    @IBAction func btnUpdate_action(_ sender: Any) {
//        print("EDITED_DOCUMENT",editDocuments)
        print("Latitude ->", self.latitude)
        print("Longitude ->",self.longitude)
        self.objDailyLogListViewModel.getEditDailyLog(controller: self, project: ProjectId ?? 0 ,dailylog_id: dailylog_Id ?? 0,location: txtLocation.text ?? "",latitude: latitude ?? 0.0, longitude: longitude ?? 0.0 ,documents: editDocuments, notes: txtNotes.text ?? "") { (success, message, type) in
            if success {
                let vc = ScreenManager.getController(storyboard: .main, controller: DailyLogListVC()) as! DailyLogListVC
                vc.ProjectId = self.ProjectId
                self.previousRef?.didEdit = true

                self.navigationController?.popViewController(animated: true)
                self.showToast(message: "Daily Log updated successfully")
            } else {
                self.showToast(message: "\(message)")
            }
        }
    }
 
}
//MARK: - Extension EditDailyLogVC For Image Picker Controller
extension EditDailyLogVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, PhotoEditorDelegate {
    
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
extension EditDailyLogVC: UIDocumentPickerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, GMSAutocompleteViewControllerDelegate{
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
            print("Place address: \(place.formattedAddress)")
            print("Place attributions: \(place.attributions)")
        txtLocation.text = place.name
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
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
        if editDocuments.count < 10 || selectedIndex != nil{
                let date = Date()
                let format = DateFormatter()
            format.dateFormat = DateTimeFormat.kDateTimeFormat
                let timestamp = format.string(from: date)
                showProgressHUD(message: "")
                print("urls[0]", urls)
            arrayPath = urls
                
                AWSS3Manager.shared.uploadImageFile(fileUrl: urls, fileName:  "\(AWSFileDirectory.PUBLIC)dailyLogDocumentFiles/dailyLogDocument_\(arrayPath!.lastPathComponent)") { (progress) in

                    print(progress)
                } completion: { (resp, error) in
                    if error == nil {
                        self.hideProgressHUD()
                        let file = resp as! String
                        if self.selectedIndex == nil{
                            self.selectedIndex = nil
                          //self.editDocumentsURL.append(file)
                        } else {
                            self.editDocuments.remove(at: self.selectedIndex!)
                          // self.editDocumentsURL.insert(file, at: self.selectedIndex!)
                        }
                        
                        self.editDocuments.append(file)
                        print(self.editDocumentsURL)
                        if self.editDocuments.count == 10 {
                            DispatchQueue.main.async {
                                self.btnAddFile.isHidden = true
                            }
                        }

                        self.stackViewHeightConstraint.constant = CGFloat(60 * self.editDocuments.count)
                        self.view.layoutIfNeeded()
                        self.collectionView.reloadData()
                    } else {
                        self.showAlert(message: error?.localizedDescription ?? "")
                    }
                }
                
                
                
            }else{
                btnAddFile.isHidden = true
            }
        print("9897896723412890-=3546789067890",urls)
        print(editDocuments)
    }
    
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return editDocuments.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddedFileCell", for: indexPath) as! AddedFileCell
            let item2 = editDocuments[indexPath.row]
      
        print(editDocuments[indexPath.row])
        
        print("EDITIED_DOCUMENT",editDocumentsURL)
        
        let itemURL = URL(string: item2)
        print("FILEURL",itemURL?.lastPathComponent)
            
        cell.fileName?.text = itemURL?.lastPathComponent
        cell.fileName.textAlignment = .center
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let collectionViewWidth = self.collectionView.bounds.size.width
            return CGSize(width: collectionViewWidth, height: 50)
        }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    
    
    
}
