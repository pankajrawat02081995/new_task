//
//  EditToolBoxVC.swift
//  Comezy
//
//  Created by aakarshit on 25/06/22.
//

import UIKit
import MobileCoreServices
import MaterialComponents.MaterialChips
import MaterialComponents
import iOSPhotoEditor

class EditToolBoxVC: UIViewController {


    var variationId: Int?
    let objAddROIVM = AddToolBoxViewModel()
    let objPeopleListViewModel = PeopleListViewModel.shared
    var objROIDetailData: ToolBoxTalkDetailModel?
    var objEditToolBoxVM = EditToolBoxViewModel()
    var arrayOfAddedVariations = [String]()
    var arrayOfAddedVariationsURL = [String]()
    var fileSize : UInt64 = 0
    var fileName = ""
    var ProjectId: Int?
    var isFileUploaded = false
    var isGSTApplied = true
    var arrayPath : URL?
    var selectedIndex: Int?
    var selectedReceiverIdArray: [SelectedReceiver]?
    var recievers: [ToolBoxTalkPerson]?
    var imageName: String?
    @IBOutlet weak var fromStackView: UIStackView!
    
    
    @IBOutlet weak var AddDocStackView: UIStackView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var txtVariationSummary: UITextView!
    @IBOutlet weak var txtRemedies: UITextView!
    @IBOutlet weak var addFileBtn: UIButton!
    @IBOutlet weak var btnAddTo: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var editVariationFileColView: UICollectionView!
    @IBOutlet weak var receiverCollectionView: ReceiverCollectionView!
    @IBOutlet weak var toBackgroundView: UIView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var selectedFile = ""
    var selectedFromPersonId: Int?
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        receiverCollectionView.delegate = self
        receiverCollectionView.dataSource = self
        btnAddTo.setTitle("", for: .normal)
        btnAddTo.setTitle("", for: .selected)
        btnAddTo.titleLabel?.isHidden = true
        
        hideKeyboardWhenTappedAround()

        receiverCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
        let layout = MDCChipCollectionViewFlowLayout()
        receiverCollectionView.collectionViewLayout = layout
        
        editVariationFileColView.delegate = self
        editVariationFileColView.dataSource = self
        
        print("View Did Load")
        editVariationFileColView.reloadData()
        print(ProjectId)
        initailLoad()
        txtFrom.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        receiverCollectionView.addGestureRecognizer(tap)
        disableUserInteraction()


        loadInformation()
        // Do any additional setup after loading the view.
    }
    
    //MARK: DisableUserInteraction
    
    func disableUserInteraction() {
        txtFrom.isUserInteractionEnabled = false
        btnAddTo.isHidden = true
        btnAddTo.isUserInteractionEnabled = false
        toBackgroundView.isUserInteractionEnabled = false
    }
    
    //MARK: Load Info
    func loadInformation() {
        guard let ref = objROIDetailData else {return}
        recievers = ref.receiver
        txtTitle.text = ref.name
        txtFrom.text = "\(ref.sender.firstName) \(ref.sender.lastName)"
        txtFrom.textColor = .systemGray
        txtVariationSummary.text = ref.topicOfDiscussion
        txtRemedies.text = ref.remedies


        arrayOfAddedVariationsURL = ref.file
        var count = 0
        arrayOfAddedVariations = ref.file.map({ str in
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
        receiverCollectionView.reloadData()
        editVariationFileColView.reloadData()
        self.collectionViewHeightConstraint.constant = CGFloat(60 * self.arrayOfAddedVariations.count)

        
    }
    
    //MARK: Button Actions
    
    @IBAction func btnBack_action(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    
    @IBAction func btnAddTo_action(_ sender: UIButton) {
        
        handleTap()

    }
    @IBAction func btnUpdate_action(_ sender: Any) {
        let vc = ConfirmViewController()
        vc.show()
        vc.confirmHeadingLabel.text = "Update Tool Box"
        vc.confirmDescriptionLabel.text = "Do you want to update the Tool Box?"
        vc.callback = {
            let ref = self.objEditToolBoxVM
            ref.updateToolBox(name: self.txtTitle.text ?? "", topicOfDiscussion: self.txtVariationSummary.text ?? "", remedies: self.txtRemedies.text ?? "", file: self.arrayOfAddedVariationsURL, eotId: self.variationId ?? 0) { success, eror, type in
                if success {
                    self.navigationController?.popViewController(animated: true)
                    self.showToast(message: "Tool Box updated successfully", font: .boldSystemFont(ofSize: 14.0))

                }
            }
            
          
        }
        
        
        
//        let ref = objEditROIModelVM
//        print(isGSTApplied)
//        ref.updateVariation(name: txtTitle.text!, price: txtVariationPrice.text!, totalPrice: txtVariationTotalPrice.text!, summary: txtVariationSummary.text!, file: arrayOfAddedVariationsURL, gst: isGSTApplied, variationId: variationId ?? 0) { success, editVariationResp , errorMsg in
//            if success {
//                self.navigationController?.popViewController(animated: true)
//                self.showToast(message: "Variation Updated successfully", font: .boldSystemFont(ofSize: 14.0))
//
//            }
//        }
        
    }
    @IBAction func btnHome_action(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func btnAddFile_action(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes:  [String(kUTTypePDF),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)],  in: .import)
        
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    
    
    //MARK: Initial Load
    func initailLoad() {
        toBackgroundView.layer.cornerRadius = 4
        self.btnUpdate.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        self.btnUpdate.clipsToBounds = true
        
    }
    
    
    //MARK: Handle Tap
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if txtFrom.text == "" {
            showAlert(message: "Please select \"From\" before selecting \"To\"")
        } else {
            let vc = ScreenManager.getController(storyboard: .main, controller: AllPeopleVC()) as! AllPeopleVC
            vc.ProjectId = self.ProjectId
            vc.fromComponent = "btnAddTo"
            vc.selectedFromId = selectedFromPersonId
            vc.selectedRecievers = selectedReceiverIdArray ?? []
            vc.selectedToCallback = { array in
                self.selectedReceiverIdArray = array
                self.receiverCollectionView.reloadData()

            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        

    }


}
//MARK: - Extension EditToolBoxVC For Image Picker Controller
extension EditToolBoxVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, PhotoEditorDelegate {
    
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
extension EditToolBoxVC: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if arrayOfAddedVariations.count < 10 || selectedIndex != nil{
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let timestamp = format.string(from: date)
            showProgressHUD(message: "")
            print("urls[0]", urls[0])
            arrayPath = urls[0]
            AWSS3Manager.shared.uploadImageFile(fileUrl: urls[0], fileName: "\(AWSFileDirectory.PUBLIC)\(AWSFileDirectory.TOOLBOX_FOLDER)\(AWSFileDirectory.TOOLBOX_FILE)\(arrayPath!.lastPathComponent)") { (progress) in

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
                    self.editVariationFileColView.reloadData()

                    if self.arrayOfAddedVariations.count == 10 {
                        DispatchQueue.main.async {
                            self.addFileBtn.isHidden = true
                        }
                    }
//                    self.stackViewHeightConstraint.constant = CGFloat(70 * self.arrayOfAddedVariations.count)
                    self.view.layoutIfNeeded()
                } else {
                    self.showAlert(message: error?.localizedDescription ?? "")
                }
            }
        }
        
//    if arrayOfAddedVariations.count < 10 {
//        let date = Date()
//        let format = DateFormatter()
//        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let timestamp = format.string(from: date)
//        showProgressHUD(message: "")
//        print("urls[0]", urls[0])
//        AWSS3Manager.shared.uploadImageFile(fileUrl: urls[0], fileName: "\(AWSFileDirectory.PLAN_FOLDER)plan_\(timestamp)") { (progress) in
//
//        } completion: { (resp, error) in
//            if error == nil {
//                self.hideProgressHUD()
//                self.fileName = resp as! String
//                self.showAlert(message: "File uploaded successfully")
//            } else {
//                self.showAlert(message: error?.localizedDescription ?? "")
//            }
//        }
//
//        arrayOfAddedVariations.removeAll()
//        arrayOfAddedVariationsURL.append(urls)
//        arrayOfAddedVariations.append(urls[0].lastPathComponent)
//        do {
//            let attr : NSDictionary? = try FileManager.default.attributesOfItem(atPath: urls[0].path) as NSDictionary
//
//            if let _attr = attr {
//                fileSize = _attr.fileSize();
//            }
//        } catch {
//            print("Error: \(error)")
//        }
//        addFileBtn.titleLabel?.font = UIFont(name: "Poppins", size: 14)
//        addFileBtn.contentHorizontalAlignment = .center;
//        self.addFileBtn.setTitle(urls[0].lastPathComponent, for: .normal)
//
//            self.view.layoutIfNeeded()
//    }
        
    }
    func uploadFile(urls:[URL]){
        if arrayOfAddedVariations.count < 10 || selectedIndex != nil{
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = DateTimeFormat.kDateTimeFormat
            let timestamp = format.string(from: date)
            showProgressHUD(message: "")
            print("urls[0]", urls[0])
            arrayPath = urls[0]
            AWSS3Manager.shared.uploadImageFile(fileUrl: urls[0], fileName: "\(AWSFileDirectory.PUBLIC)dailyLogDocumentFiles/\(arrayPath?.lastPathComponent ?? "DailyLogDocument\(timestamp)")") { (progress) in
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
                    self.collectionViewHeightConstraint.constant = CGFloat(70 * self.arrayOfAddedVariations.count)
                    self.editVariationFileColView.reloadData()

                    if self.arrayOfAddedVariations.count == 10 {
                        DispatchQueue.main.async {
                            self.addFileBtn.isHidden = true
                        }
                    }
//                    self.stackViewHeightConstraint.constant = CGFloat(70 * self.arrayOfAddedVariations.count)
                    self.view.layoutIfNeeded()
                } else {
                    self.showAlert(message: error?.localizedDescription ?? "")
                }
            }
        }
        
    }
}


extension EditToolBoxVC: UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let a = collectionView as? ReceiverCollectionView {
            return recievers?.count ?? 0
        }
        print(arrayOfAddedVariations.count, "@#$!@#!@#$!@#$!@#$!@# C O L L E C T I O N V I E W $!@#$!@#$!@#$!@#$")
        
        return arrayOfAddedVariations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // dataArary is the managing array for your UICollectionView.
        if let a = collectionView as? ReceiverCollectionView {
            let item = recievers?[indexPath.row].firstName ?? "Hello"
            let itemSize = CGSize(width: item.size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]).width + 20, height: 44)
            return itemSize
        }
        let collectionViewWidth = self.editVariationFileColView.bounds.size.width
        return CGSize(width: collectionViewWidth, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let a = collectionView as? ReceiverCollectionView {
            print("@#$!@#!@#$!@#$!@#$!@# C O L   V I E W    called  as receiverCollectionView  $!@#$!@#$!@#$!@#$")
           let cell = a.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! MDCChipCollectionViewCell
            let chipView = cell.chipView
            
            print(selectedReceiverIdArray?[indexPath.row])
            print(indexPath.section)
            print("#$#@$@#$%#$%@$% R O W #$%#$%#$%#@$%@#$%")

            print(indexPath.row)
            chipView.titleLabel.text = recievers?[indexPath.row].firstName
            chipView.setBackgroundColor(UIColor.systemGray, for: .normal)
            chipView.titleLabel.textColor = .white
            print(chipView.frame, "@#$!@#!@#$! I N T R I N S I C@#$!@#$!@# ")
            
            cell.isUserInteractionEnabled = false
            // configure the chipView to be an action chip
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddVariationDocCell", for: indexPath) as! AddVariationDocCell
            let item = arrayOfAddedVariations[indexPath.row]
            print("AddedFileCell  .. ", item)
            cell.VariationFileLabel.text = item
            
            cell.VariationFileLabel.textAlignment = .center
            print(cell.VariationFileLabel, "@#$!@#!@#$!@#$!@#$!@#$!@# F I L E N A M E $!@#$!@#$!@#$!@#$")
            
            return cell
        }
        
  
        
     


    }
    
    //MARK: TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        
        //MARK: From
        if textField == txtFrom {
            txtFrom.inputView = UIView.init(frame: CGRect.zero)
            txtFrom.inputAccessoryView = UIView.init(frame: CGRect.zero)
            
            let vc = ScreenManager.getController(storyboard: .main, controller: AllPeopleVC()) as! AllPeopleVC
            vc.ProjectId = self.ProjectId
            vc.fromComponent = "txtFrom"
            vc.selectedFromCallback = { person in
                self.txtFrom.text = "\(person.firstName) \(person.lastName)"
                self.selectedFromPersonId = person.id
                self.selectedReceiverIdArray = []
                self.receiverCollectionView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
            txtFrom.endEditing(true)

        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {

    }
}

