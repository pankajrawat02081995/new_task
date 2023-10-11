//
//  EditProductInformationVC.swift
//  Comezy
//
//  Created by amandeepsingh on 07/07/22.
//

import UIKit
import MobileCoreServices
import iOSPhotoEditor

class EditProductInformationVC: UIViewController {
    //MARK: - Variables
    var specificaitonId: Int?
    let objDocsViewModel = DocsListViewModel()
    var objSpecificationDetail: DocsListModelResult?
    var arrayOfAddedFiles = [String]()
    var arrayOfAddedFilesUrl = Array<[String:String]>()

    var fileSize : UInt64 = 0
    var fileName = ""
    var ProjectId: Int?
    var isFileUploaded = false
    var arrayPath : URL?
    var previousRef: SpecificationAndProductInformationDetailVC?
    var imageName: String?
    
    @IBOutlet weak var labelSupplierDetail: UITextView!
    @IBOutlet weak var labelDescription: UITextView!
    @IBOutlet weak var AddDocStackView: UIStackView!
    @IBOutlet weak var editProductInfoCollectionView: UICollectionView!
    @IBOutlet weak var labelName: UITextField!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var addFileButton: UIButton!
    
  //MARK: - View Controller Lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        editProductInfoCollectionView.delegate = self
        editProductInfoCollectionView.dataSource = self
        print("View Did Load")
        editProductInfoCollectionView.reloadData()
        print(ProjectId)
        initailLoad()
        loadInformation()
        // Do any additional setup after loading the view.
    }
  
      override func viewDidLayoutSubviews() {
          self.btnUpdate.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
          self.btnUpdate.clipsToBounds = true
      }

  
    
    //MARK: - On Click Action Method
    @IBAction func btnAddFile_Action(_ sender: Any) {
        showImagePickerOption(delegate:self)
       
    }
    
    @IBAction func btnUpdate_Action(_ sender: Any) {
        print(arrayOfAddedFilesUrl)
        let vc = ConfirmViewController()
        vc.show()
        vc.confirmHeadingLabel.text = "Update Product Information"
        vc.confirmDescriptionLabel.text = "Do you want to update the product information?"
        vc.callback = {
            let ref = self.objDocsViewModel
            
            
            ref.updateDocs(name: self.labelName.text ?? "" , description: self.labelDescription.text ?? "", file: self.arrayOfAddedFilesUrl,supplierDetails: self.labelSupplierDetail.text ?? "", safetyId: self.specificaitonId ?? 0) { success, eror, response in
                if success {
                    self.showToast(message: "Product Information updated successfully", font: .boldSystemFont(ofSize: 14.0))
                    self.previousRef?.didEdit = true
                    self.navigationController?.popViewController(animated: true)

                }else{
                    self.showToast(message: eror!)
                    
                }
            }
            
          
        }

        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }
    @IBAction func btnHome(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    //MARK: User Defined Function
    func initailLoad() {
        self.btnUpdate.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        self.btnUpdate.clipsToBounds = true
        
    }
    func loadInformation() {
        guard let ref = objSpecificationDetail else {return}
        labelName.text = ref.name
        labelDescription.text = ref.resultDescription
        labelSupplierDetail.text = ref.resultDescription
        labelSupplierDetail.text = ref.supplierDetails


      //  arrayOfAddedFilesUrl = ref.filesList
        var count = 0
        arrayOfAddedFiles = ref.filesList.map({ str in
            let arrayOfAddedUrl:Array<[String : String]> = [["file_name" : str.fileName as! String,"file_size" : String(str.fileSize)]]
            self.arrayOfAddedFilesUrl.append(arrayOfAddedUrl)
            if let url = URL(string: str.fileName) {
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
        editProductInfoCollectionView.reloadData()
        self.collectionViewHeightConstraint.constant = CGFloat(60 * self.arrayOfAddedFiles.count)

        
    }
  

    func uploadFile(urls:[URL]){
        if arrayOfAddedFiles.count < 10 {
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
                    self.arrayOfAddedFilesUrl.append(arrayOfAddedUrl)
                    //self.arrayOfAddedFilesUrl.append(file)
                  
                    self.arrayOfAddedFiles.append(urls[0].lastPathComponent)
                    print(self.arrayOfAddedFiles, "@#$@#$%@#$%#$%#$ A R R A Y  ADDED $#%@#$%@#$%@#$")
                    print(self.arrayOfAddedFilesUrl, "@#$@#$%@#$%#$%#$ A R R A Y  ADDED $#%@#$%@#$%@#$")
                    self.collectionViewHeightConstraint.constant = CGFloat(60 * self.arrayOfAddedFiles.count)
                    self.editProductInfoCollectionView.reloadData()

                    if self.arrayOfAddedFiles.count == 10 {
                        DispatchQueue.main.async {
                            self.addFileButton.isHidden = true
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

//MARK: - Extension AddSpecificationAndProductInfoVC For Document Picker

extension EditProductInformationVC: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        uploadFile(urls: urls)
    }
    
}
//MARK: - Extension AddSpecificationAndProductInfoVC For Image Picker Controller
extension EditProductInformationVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, PhotoEditorDelegate {
    
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


extension EditProductInformationVC: UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(arrayOfAddedFiles.count, "@#$!@#!@#$!@#$!@#$!@# C O L L E C T I O N V I E W $!@#$!@#$!@#$!@#$")
        
        return arrayOfAddedFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = self.editProductInfoCollectionView.bounds.size.width
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
