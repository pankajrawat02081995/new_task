//
//  AddSpecificationAndProductInfoVC.swift
//  Comezy
//
//  Created by amandeepsingh on 30/06/22.
//

import UIKit
import MobileCoreServices
import iOSPhotoEditor

class AddSpecificationAndProductInfoVC: UIViewController {
    //MARK: - Variables
    let objDocument = AddDocumentViewModel.shared
    var arrayOfAddedVariations = [String]()
    //var arrayOfAddedVariationsURL = [FilesList]()
    var arrayOfFileURL = Array<[String : String]>()
    var fileSize : UInt64 = 0

    var fileName = ""
    var ProjectId: Int?
    var isFileUploaded = false
    var arrayPath : URL?
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var addFileBtn: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var variationFileCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblSupplierDetail: UITextView!
    var selectedFile = ""
    var imageName: String?
    
    //MARK: Life Cylce Method
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        variationFileCollectionView.delegate = self
        variationFileCollectionView.dataSource = self
        print("View Did Load")
        variationFileCollectionView.reloadData()
        print(ProjectId)
        initailLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
     
        super.viewWillAppear(true)

    }
    
    //MARK: - On Click Action Method
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnHome_action(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func btnAddFile_action(_ sender: Any) {
        showImagePickerOption(delegate:self)

        
    }

    @IBAction func btnDone_action(_ sender: Any) {
        self.objDocument.addDocs(controller: self, name: txtName.text ?? "", supplierDetail: lblSupplierDetail.text ?? "",description: txtDescription.text ?? "", file_list: self.arrayOfFileURL, type: "specifications_and_product_information", project: ProjectId ?? 0) { success, eror, type in
            if success {
                self.navigationController?.popViewController(animated: true)

                self.showToast(message: SuccessMessage.kProductAdded, font: .boldSystemFont(ofSize: 14.0))

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
//MARK: Document Picker
extension AddSpecificationAndProductInfoVC: UIDocumentPickerDelegate{
    //Method to Picker Document
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        uploadFile(urls: urls)
    }
    //Upload File Method
    func uploadFile(urls:[URL]){
        self.dismiss(animated: true,completion: nil)

        if arrayOfAddedVariations.count < 10 {
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = DateTimeFormat.kSpecificationDateFormat
            let timestamp = format.string(from: date)
            showProgressHUD(message: "")
            print("urls[0]", urls[0])
            arrayPath = urls[0]
            AWSS3Manager.shared.uploadImageFile(fileUrl: urls[0], fileName: "\(AWSFileDirectory.PUBLIC)\(AWSFileDirectory.SPECIFICATION_FOLDER)\(AWSFileDirectory.SPECIFICATION_FILE)\(arrayPath!.lastPathComponent ?? "Specification\(timestamp)")") { (progress) in
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
                    let arrayOfAddedUrl:Array<[String : String]> = [["file_name" : resp as! String,"file_size" : String(self.fileSize)]]
                    self.arrayOfFileURL.append(arrayOfAddedUrl)
//                    self.arrayOfAddedVariationsURL.append(.init(name: resp as! String, size: String(self.fileSize)))

                    self.arrayOfAddedVariations.append(urls[0].lastPathComponent)
                    do {
                                let attr : NSDictionary? = try FileManager.default.attributesOfItem(atPath: urls[0].path) as NSDictionary
                    
                                if let _attr = attr {
                                    self.fileSize = _attr.fileSize();
                                }
                            } catch {
                                print("Error: \(error)")
                            }
                    print(self.arrayOfAddedVariations, "<------A R R A Y  ADDED ------>")
                  //  print(self.arrayOfAddedVariationsURL, "@#$@#$%@#$%#$%#$ A R R A Y  ADDED $#%@#$%@#$%@#$")
                    print(self.fileSize, "<------ FILE SIZE ----->")
                    var filep = fileDetails(fileName: self.fileName,fileSize: String(self.fileSize))

                    self.collectionViewHeightConstraint.constant = CGFloat(60 * self.arrayOfAddedVariations.count)
                    self.variationFileCollectionView.reloadData()

                    if self.arrayOfAddedVariations.count == 10 {
                        DispatchQueue.main.async {
                            self.addFileBtn.isHidden = true
                        }
                    }
//                    self.stackViewHeightConstraint.constant = CGFloat(70 * self.arrayOfAddedVariations.count)
                    self.showToast(message: SuccessMessage.kFileUpload, font: .boldSystemFont(ofSize: 14.0))
                    self.view.layoutIfNeeded()
                } else {
                    self.dismiss(animated: true,completion: nil)
                    self.showAlert(message: error?.localizedDescription ?? "")
                }
            }
        }
        
    }
}
//MARK: - Extension AddSpecificationAndProductInfoVC For Image Picker Controller
extension AddSpecificationAndProductInfoVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, PhotoEditorDelegate {
    
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

//MARK: - Extension AddSpecificationAndProductInfoVC For File Collection View
extension AddSpecificationAndProductInfoVC: UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(arrayOfAddedVariations.count, "@#$!@#!@#$!@#$!@#$!@# C O L L E C T I O N V I E W $!@#$!@#$!@#$!@#$")
        
        return arrayOfAddedVariations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // dataArary is the managing array for your UICollectionView.
        let collectionViewWidth = self.variationFileCollectionView.bounds.size.width
        return CGSize(width: collectionViewWidth, height: 50)

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:StoryBoardIdentifier.kAddVariationDocCellController, for: indexPath) as! AddVariationDocCell
            let item = arrayOfAddedVariations[indexPath.row]
            print("AddedFileCell  .. ", item)
            cell.VariationFileLabel.text = item
            
            cell.VariationFileLabel.textAlignment = .center
            print(cell.VariationFileLabel, "@#$!@#!@#$!@#$!@#$!@#$!@# F I L E N A M E $!@#$!@#$!@#$!@#$")
            
            return cell

    }
}

struct fileDetails:Encodable{
    let fileName:String
    let fileSize:String
    enum CodingKeys: String, CodingKey {
        case fileName = "file_name"
        case fileSize = "file_size"
    }
}
