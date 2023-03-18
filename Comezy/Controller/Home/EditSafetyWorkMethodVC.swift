//
//  EditSafetyWorkMethodVC.swift
//  Comezy
//
//  Created by aakarshit on 28/06/22.
//

import UIKit
import MobileCoreServices
import iOSPhotoEditor


class EditSafetyWorkMethodVC: UIViewController {

    var safetyId: Int?
    let objSafetyViewModel = SafetyListViewModel.shared
    var objSafetyDetail: SafetyListResult?
    var arrayOfAddedFiles = [String]()
    var arrayOfAddedFilesUrl = [String]()
    var fileSize : UInt64 = 0
    var fileName = ""
    var ProjectId: Int?
    var isFileUploaded = false
    var arrayPath : URL?
    var previousRef: SafetyWorkMethodDetailVC?
    var imageName: String?
    
    @IBOutlet weak var AddDocStackView: UIStackView!
    @IBOutlet weak var txtTitle: UITextField!

    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var addFileBtn: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var editVariationFileColView: UICollectionView!
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var selectedFile = ""
    var selectedFromPersonId: Int?
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        
        editVariationFileColView.delegate = self
        editVariationFileColView.dataSource = self
        
        print("View Did Load")
        editVariationFileColView.reloadData()
        print(ProjectId)
        initailLoad()

        loadInformation()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.btnUpdate.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        self.btnUpdate.clipsToBounds = true
    }
    
    //MARK: DisableUserInteraction

    
    //MARK: Load Info
    func loadInformation() {
        guard let ref = objSafetyDetail else {return}
        txtTitle.text = ref.name
        txtDescription.text = ref.resultDescription


        arrayOfAddedFilesUrl = ref.file
        var count = 0
        arrayOfAddedFiles = ref.file.map({ str in
            if let url = URL(string: str) {
                if url.lastPathComponent == "" {
                    count += 1
                    return "file\(count)"
                }
                return url.lastPathComponent
            } else {
                return "Error"
            }
        })
        print(arrayOfAddedFiles, "$@#$@#$@!#$%@#$%#@$%@#$%@#$@#$@ A R R A Y    O F    A D D E D    V A R I A T I O N S #%@#$%@#$@#%$$^%#$%#$&$^#$%@$%@#$")
        editVariationFileColView.reloadData()
        self.collectionViewHeightConstraint.constant = CGFloat(60 * self.arrayOfAddedFiles.count)

        
    }
    
    //MARK: Button Actions
    
    @IBAction func btnBack_action(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

    @IBAction func btnUpdate_action(_ sender: Any) {
        print(arrayOfAddedFilesUrl)
        let vc = ConfirmViewController()
        vc.show()
        vc.confirmHeadingLabel.text = "Update Safety Work Method?"
        vc.confirmDescriptionLabel.text = "Do you want to update the Safety Work Method?"
        vc.callback = {
            let ref = self.objSafetyViewModel
            
            
            ref.updateSafety(name: self.txtTitle.text ?? "" , description: self.txtDescription.text ?? "", file: self.arrayOfAddedFilesUrl, safetyId: self.safetyId ?? 0) { success, eror, response in
                if success {
                    self.showToast(message: SuccessMessage.kSafetyWorkUpdated, font: .boldSystemFont(ofSize: 14.0))
                    self.previousRef?.didEdit = true
                    self.navigationController?.popViewController(animated: true)

                }
            }
            
          
        }

        
    }
    @IBAction func btnHome_action(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func btnAddFile_action(_ sender: Any) {
        showImagePickerOption(delegate:self)
    }
    
    
    //MARK: User Defined Function
    func initailLoad() {
        self.btnUpdate.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        self.btnUpdate.clipsToBounds = true
        
    }
    

}
//MARK: - Extension EditVariationsVC For Image Picker Controller
extension EditSafetyWorkMethodVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, PhotoEditorDelegate {
    
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
extension EditSafetyWorkMethodVC: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        uploadFile(urls: urls)
    }
    func uploadFile(urls:[URL]){
        if arrayOfAddedFiles.count < 10 {
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = DateTimeFormat.kDateTimeFormat
            let timestamp = format.string(from: date)
            showProgressHUD(message: "")
            print("urls[0]", urls[0])
            arrayPath = urls[0]
            AWSS3Manager.shared.uploadImageFile(fileUrl: urls[0], fileName: "\(AWSFileDirectory.PUBLIC)\(AWSFileDirectory.SAFETY_WORK_METHOD_FOLDER)safetyWorkMethod_\(arrayPath!.lastPathComponent)") { (progress) in

                print(progress)
            } completion: { (resp, error) in
                if error == nil {
                    self.hideProgressHUD()
                    
                    let file = resp as! String
//                        if self.selectedIndex == nil{
//                            self.selectedIndex = nil
//                        self.arrayOfAddedFilesURL.append(file)
//                        } else {
//                            self.arrayOfAddedFiles.remove(at: self.selectedIndex!)
//                            self.arrayOfAddedFilesURL.insert(file, at: self.selectedIndex!)
//                        }
                        
                    self.arrayOfAddedFilesUrl.append(file)
                  
                    self.arrayOfAddedFiles.append(urls[0].lastPathComponent)
                    print(self.arrayOfAddedFiles, "@#$@#$%@#$%#$%#$ A R R A Y  ADDED $#%@#$%@#$%@#$")
                    print(self.arrayOfAddedFilesUrl, "@#$@#$%@#$%#$%#$ A R R A Y  ADDED $#%@#$%@#$%@#$")
                    self.collectionViewHeightConstraint.constant = CGFloat(60 * self.arrayOfAddedFiles.count)
                    self.editVariationFileColView.reloadData()

                    if self.arrayOfAddedFiles.count == 10 {
                        DispatchQueue.main.async {
                            self.addFileBtn.isHidden = true
                        }
                    }
//                    self.stackViewHeightConstraint.constant = CGFloat(70 * self.arrayOfAddedVariations.count)
                    self.showToast(message: SuccessMessage.kFileUpload, font: .boldSystemFont(ofSize: 14.0))

                    self.view.layoutIfNeeded()
                } else {
                    self.showAlert(message: error?.localizedDescription ?? "")
                }
            }
        }
    }
}


extension EditSafetyWorkMethodVC: UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(arrayOfAddedFiles.count, "@#$!@#!@#$!@#$!@#$!@# C O L L E C T I O N V I E W $!@#$!@#$!@#$!@#$")
        
        return arrayOfAddedFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = self.editVariationFileColView.bounds.size.width
        return CGSize(width: collectionViewWidth, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddVariationDocCell", for: indexPath) as! AddVariationDocCell
            let item = arrayOfAddedFiles[indexPath.row]
            print("AddedFileCell  .. ", item)
            cell.VariationFileLabel.text = item
            
            cell.VariationFileLabel.textAlignment = .center
            print(cell.VariationFileLabel, "@#$!@#!@#$!@#$!@#$!@#$!@# F I L E N A M E $!@#$!@#$!@#$!@#$")
            
            return cell
    }
}
