//
//  AddPlanVC.swift
//  Comezy
//
//  Created by amandeepsingh on 28/07/22.
//

import UIKit
import MobileCoreServices

import iOSPhotoEditor

class AddPlanVC: UIViewController {
    
    //MARK: - Variables
    let objPlan = AddPlansViewModel()
    var arrayOfAddedVariations = [String]()
    var arrayOfAddedVariationsURL = [String]()
    var fileSize : UInt64 = 0
    var fileName = ""
    var ProjectId: Int?
    var isFileUploaded = false
    var arrayPath : URL?

    var imageName: String?
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var addFileBtn: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var planFileCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var selectedFile = ""
    
    //MARK: ViewDidLoad Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
//        hideKeyboardWhenTappedAround()
        
        planFileCollectionView.delegate = self
        planFileCollectionView.dataSource = self
        print("View Did Load")
        planFileCollectionView.reloadData()
        print(ProjectId)
        initailLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
     
        super.viewWillAppear(true)

    }
    
    //MARK: Button back
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnHome_action(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: Add File
    @IBAction func btnAddFile_action(_ sender: Any) {
        showImagePickerOption(delegate:self)
        
    }
    

    
    //MARK: BTN DONE
    @IBAction func btnDone_action(_ sender: Any) {
        
//        self.objPlan.addSafety(name: txtName.text ?? "", description: txtDescription.text ?? "", file: arrayOfAddedVariationsURL, project: ProjectId ?? 0, type: "safe_work_method_statement") { success, eror, type in
//            if success {
//                self.navigationController?.popViewController(animated: true)
//
//                self.showToast(message: "Safety Work Method added successfully", font: .boldSystemFont(ofSize: 14.0))
//
//            } else {
//                self.showAlert(message: eror)
//            }
//        }
        self.objPlan.addPlan(controller: self, name: txtName.text!, description: txtDescription.text!, file: self.arrayOfAddedVariationsURL, project: ProjectId!){ success, eror, type in
            if success {
                self.navigationController?.popViewController(animated: true)

                self.showToast(message: "Plan added successfully", font: .boldSystemFont(ofSize: 14.0))

            } else {
                self.showAlert(message: eror)
            }
        }
    }
    
    //MARK: User Defined Function
    func initailLoad(){
        self.btnDone.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        self.btnDone.clipsToBounds = true
    }

}
//MARK: - Extension AddSafetyWorkMethodVC For Image Picker Controller

extension AddPlanVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, PhotoEditorDelegate {
    
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
extension AddPlanVC: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        uploadFile(urls: urls)
        
    }
    func uploadFile(urls:[URL]){
        if arrayOfAddedVariations.count < 10 {
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = DateTimeFormat.kDateTimeFormat
            let timestamp = format.string(from: date)
            showProgressHUD(message: "")
            print("urls[0]", urls[0])
            arrayPath = urls[0]
            AWSS3Manager.shared.uploadImageFile(fileUrl: urls[0], fileName: "\(AWSFileDirectory.PUBLIC)\(AWSFileDirectory.PLAN_FOLDER)\(AWSFileDirectory.PLAN_FILE)\(arrayPath!.lastPathComponent)") { (progress) in
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
                        
                    self.arrayOfAddedVariationsURL.append(file)
                  
                    self.arrayOfAddedVariations.append(urls[0].lastPathComponent)
                    print(self.arrayOfAddedVariations, "@#$@#$%@#$%#$%#$ A R R A Y  ADDED $#%@#$%@#$%@#$")
                    print(self.arrayOfAddedVariationsURL, "@#$@#$%@#$%#$%#$ A R R A Y  ADDED $#%@#$%@#$%@#$")
                    self.collectionViewHeightConstraint.constant = CGFloat(60 * self.arrayOfAddedVariations.count)
                    self.planFileCollectionView.reloadData()

                    if self.arrayOfAddedVariations.count == 10 {
                        DispatchQueue.main.async {
                            self.addFileBtn.isHidden = true
                        }
                    }
//                    self.stackViewHeightConstraint.constant = CGFloat(70 * self.arrayOfAddedVariations.count)
                    self.showToast(message: "file uploaded successfully", font: .boldSystemFont(ofSize: 14.0))

                    self.view.layoutIfNeeded()
                } else {
                    self.showAlert(message: error?.localizedDescription ?? "")
                }
            }
        }
    }
}

extension AddPlanVC: UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(arrayOfAddedVariations.count, "@#$!@#!@#$!@#$!@#$!@# C O L L E C T I O N V I E W $!@#$!@#$!@#$!@#$")
        
        return arrayOfAddedVariations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let collectionViewWidth = self.planFileCollectionView.bounds.size.width
            return CGSize(width: collectionViewWidth, height: 50)
        }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddVariationDocCell", for: indexPath) as! AddVariationDocCell
            let item = arrayOfAddedVariations[indexPath.row]
            print("AddedFileCell  .. ", item)
            cell.VariationFileLabel.text = item
            
            cell.VariationFileLabel.textAlignment = .center
            print(cell.VariationFileLabel, "@#$!@#!@#$!@#$!@#$!@#$!@# F I L E N A M E $!@#$!@#$!@#$!@#$")
            
            return cell

    }
}

