//
//  EditVariationsVC.swift
//  Comezy
//
//  Created by aakarshit on 06/06/22.
//

import UIKit
import MobileCoreServices
import MaterialComponents.MaterialChips
import MaterialComponents
import iOSPhotoEditor

class EditVariationsVC: UIViewController {
    var variationId: Int?
    let objAddVariations = AddVariationsViewModel.shared
    let objPeopleListViewModel = PeopleListViewModel.shared
    var objVariationDetailData: VariationDetailModel?
    var objEditVariationViewModel = EditVariationsViewModel()
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
    var recievers: [ReceiverResponse]?
    var uploadUrls = [URL]()
    var imgName:String?
    var imageName: String?
    var previousRef: VariationDetailVC?

    
    @IBOutlet weak var AddDocStackView: UIStackView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var txtVariationSummary: UITextView!
    @IBOutlet weak var txtVariationPrice: UITextField!
    @IBOutlet weak var gstSegment: UISegmentedControl!
    @IBOutlet weak var txtTotalPrice: UITextField!
    @IBOutlet weak var addFileBtn: UIButton!
    @IBOutlet weak var btnAddTo: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var editVariationFileColView: UICollectionView!
    @IBOutlet weak var receiverCollectionView: ReceiverCollectionView!
    @IBOutlet weak var toBackgroundView: UIView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtVariationTotalPrice: UITextField!
    
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
        txtVariationPrice.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                  for: .editingChanged)
        print(ProjectId)
        initailLoad()
        txtFrom.delegate = self
        txtVariationPrice.keyboardType = .numberPad
        
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
        guard let ref = objVariationDetailData else {return}
        recievers = ref.receiver
        txtTitle.text = ref.name
        txtFrom.text = "\(ref.sender.firstName) \(ref.sender.lastName)"
        txtFrom.textColor = .systemGray
        txtVariationSummary.text = ref.summary
        if ref.gst {
            gstSegment.selectedSegmentIndex = 0
        } else {
            gstSegment.selectedSegmentIndex = 1
        }
        txtVariationPrice.text = ref.price
        txtVariationTotalPrice.text = ref.totalPrice
        arrayOfAddedVariationsURL = ref.file
        arrayOfAddedVariations = ref.file.map({ str in
            if let url = URL(string: str) {
                return url.lastPathComponent
            } else {
                return "Error"
            }
        })
        print(arrayOfAddedVariations, "$@#$@#$@!#$%@#$%#@$%@#$%@#$@#$@ A R R A Y    O F    A D D E D    V A R I A T I O N S #%@#$%@#$@#%$$^%#$%#$&$^#$%@$%@#$")
        receiverCollectionView.reloadData()
        editVariationFileColView.reloadData()
        self.collectionViewHeightConstraint.constant = CGFloat(60 * self.arrayOfAddedVariations.count)

        
    }
    
    //MARK: Button Actions
    
    @IBAction func btnBack_action(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDone_action(_ sender: UIButton) {
    }
    
    @IBAction func btnAddTo_action(_ sender: UIButton) {
        
        handleTap()

    }
    
    @IBAction func btnUpdate_action(_ sender: Any) {
        
        let ref = self.objEditVariationViewModel
        ref.updateVariation(name: self.txtTitle.text!, price: self.txtVariationPrice.text!, totalPrice: self.txtVariationTotalPrice.text!, summary: self.txtVariationSummary.text!, file: self.arrayOfAddedVariationsURL, gst: self.isGSTApplied, variationId: self.variationId ?? 0) { success, editVariationResp , errorMsg in
            if success {
                self.previousRef?.didEdit = true
                self.navigationController?.popViewController(animated: true)
                self.showToast(message: "Variation Updated successfully", font: .boldSystemFont(ofSize: 14.0))
                
            }
            else{
                self.showAlert(message: errorMsg)
            }
        }
        
        
        
        
//        let ref = objEditVariationViewModel
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
        showImagePickerOption(delegate:self)
    }
    
    
    //MARK: Initial Load
    func initailLoad(){
        toBackgroundView.layer.cornerRadius = 4
        self.btnUpdate.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        self.btnUpdate.clipsToBounds = true
        txtTotalPrice.isUserInteractionEnabled = false
        txtTotalPrice.keyboardType = .numberPad
    }
    
    //MARK: GST Segment
    @IBAction func getSegment_action(_ sender: UISegmentedControl!) {
        if sender.selectedSegmentIndex == 0 {
            
            let priceInt: Int? = Int(txtVariationPrice.text!)
            if let price = priceInt {
                txtTotalPrice.text = String(Int(Double(price) + Double(price) * 0.1))
                isGSTApplied = true
            }
        } else if sender.selectedSegmentIndex == 1 {
            txtTotalPrice.text = txtVariationPrice.text
            isGSTApplied = false
        }
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
//MARK: - Extension EditVariationsVC For Image Picker Controller
extension EditVariationsVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, PhotoEditorDelegate {
    
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
//MARK: Document Picker

extension EditVariationsVC: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        uploadFile(urls:urls[0])
        
    }


func uploadFile(urls:URL){
    if arrayOfAddedVariations.count < 10 || selectedIndex != nil{
      
        showProgressHUD(message: "")
        print("urls[0]", urls)
        arrayPath = urls
        AWSS3Manager.shared.uploadImageFile(fileUrl: urls, fileName: "\(AWSFileDirectory.PUBLIC)\(AWSFileDirectory.VARIATION_FOLDER)\(AWSFileDirectory.VARIATION_FILE)\(arrayPath!.lastPathComponent)") { (progress) in

            print(progress)
        } completion: { (resp, error) in
            if error == nil {
                self.hideProgressHUD()
                let file = resp as! String
                self.arrayOfAddedVariationsURL.append(file)
              
                self.arrayOfAddedVariations.append(urls.lastPathComponent)

                print(self.arrayOfAddedVariations, "@#$@#$%@#$%#$%#$ A R R A Y  ADDED $#%@#$%@#$%@#$")
                print(self.arrayOfAddedVariationsURL, "@#$@#$%@#$%#$%#$ A R R A Y  ADDED $#%@#$%@#$%@#$")
                self.collectionViewHeightConstraint.constant = CGFloat(60 * self.arrayOfAddedVariations.count)
                self.editVariationFileColView.reloadData()

                if self.arrayOfAddedVariations.count == 10 {
                    DispatchQueue.main.async {
                        self.addFileBtn.isHidden = true
                    }
                }
                self.view.layoutIfNeeded()
            } else {
                self.showAlert(message: error?.localizedDescription ?? "")
            }
        }
    }
}
}

extension EditVariationsVC: UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
            chipView.setBackgroundColor(UIColor(red: 204,  green: 204, blue: 204), for: .normal)
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
        if textField == txtVariationPrice {
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtVariationPrice {
            
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == txtVariationPrice {
            if txtVariationPrice.text == "" {
                txtTotalPrice.text = ""
            }
            if isGSTApplied {
                let priceInt: Int? = Int(txtVariationPrice.text!)
                if let price = priceInt {
                    txtTotalPrice.text = String(Int(Double(price) + Double(price) * 0.1))
                }
            } else {
                txtTotalPrice.text = txtVariationPrice.text
            }
        }
    }
}

