//
//  AddVariationsVC.swift
//  Comezy
//
//  Created by shiphul on 09/12/21.
//

import UIKit
import MobileCoreServices
import MaterialComponents.MaterialChips
import MaterialComponents
import iOSPhotoEditor



class AddVariationsVC: UIViewController {
    let objAddVariations = AddVariationsViewModel.shared
    let objPeopleListViewModel = PeopleListViewModel.shared
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
    var uploadUrls = [URL]()
    var imgName:String?
    var imageName: String?
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var addFileBtn: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var txtVariationPrice: UITextField!
    @IBOutlet weak var segmentGST: UISegmentedControl!
    @IBOutlet weak var txtVariationSummary: UITextView!
    @IBOutlet weak var toBackgroundView: UIView!
    @IBOutlet weak var txtTotalPrice: UITextField!
    @IBOutlet weak var variationFileCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var fromStackView: UIStackView!
    @IBOutlet weak var btnAddReceiver: UIButton!
    @IBOutlet weak var receiverCollectionView: ReceiverCollectionView!
    
    var selectedFile = ""
    var selectedFromPersonId: Int?
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        txtName.delegate = self
        txtFrom.isUserInteractionEnabled = false
        txtFrom.isEnabled = false
        
        
        receiverCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
        let layout = MDCChipCollectionViewFlowLayout()
        receiverCollectionView.collectionViewLayout = layout
        
        variationFileCollectionView.delegate = self
        variationFileCollectionView.dataSource = self
        print("View Did Load")
        variationFileCollectionView.reloadData()
        txtVariationPrice.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                  for: .editingChanged)
        print(ProjectId)
        initailLoad()
        txtFrom.delegate = self
        txtVariationPrice.keyboardType = .numberPad
        
        //Upon tapping the from stack view
        let fromTap = UITapGestureRecognizer(target: self, action: #selector(self.handleFromTapped(_:)))
        fromStackView.addGestureRecognizer(fromTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        receiverCollectionView.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
     
        super.viewWillAppear(true)
        btnAddReceiver.setTitle("", for: .normal)

    }
    
    @objc func handleFromTapped(_ sender: UITapGestureRecognizer? = nil) {
        txtName.endEditing(true)
        txtName.resignFirstResponder()
        txtFrom.inputView = UIView.init(frame: CGRect.zero)
        txtFrom.inputAccessoryView = UIView.init(frame: CGRect.zero)
        
        let vc = ScreenManager.getController(storyboard: .main, controller: AllPeopleVC()) as! AllPeopleVC
        vc.ProjectId = self.ProjectId
        vc.fromComponent = "txtFrom"
        vc.textFieldRef = txtFrom
        vc.selectedFromCallback = { person in
            self.txtFrom.text = "\(person.firstName) \(person.lastName)"
            self.selectedFromPersonId = person.id
            self.selectedReceiverIdArray = []
            self.receiverCollectionView.reloadData()
        }
        txtFrom.resignFirstResponder()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Button back
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
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
    
    
    //MARK: Button Add "To"
    @IBAction func btnAddTo(_ sender: UIButton) {
        handleTap()
        
//        if txtFrom.text == "" {
//            showAlert(message: "Please select \"From\" before selecting \"To\"")
//        } else {
//            let vc = ScreenManager.getController(storyboard: .main, controller: AllPeopleVC()) as! AllPeopleVC
//            vc.ProjectId = self.ProjectId
//            vc.fromComponent = "btnAddTo"
//            vc.selectedFromId = selectedFromPersonId
//            vc.selectedRecievers = selectedReceiverIdArray ?? []
//            vc.selectedToCallback = { array in
//                self.selectedReceiverIdArray = array
//                self.receiverCollectionView.reloadData()
//
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        

    }
    
    @IBAction func btnHome_action(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: Add File
    @IBAction func btnAddFile_action(_ sender: Any) {
        showImagePickerOption(delegate:self)
        
    }
    
    //MARK: GST Segment
    @IBAction func gstSegment_action(_ sender: UISegmentedControl!) {
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
    
    //MARK: BTN DONE
    @IBAction func btnDone_action(_ sender: Any) {
        var gstString = "True"
        if isGSTApplied {
            gstString = "True"
        } else {
            gstString = "False"
        }
        
        var receiverIdArray = [Int]()
        if let safeReceiverIdArray = selectedReceiverIdArray {
            for i in safeReceiverIdArray {
                receiverIdArray.append(i.receiverId!)
            }

        }
        
        print(receiverIdArray)
        
        self.objAddVariations.addVariation(controller: self, name: self.txtName.text!, sender: self.selectedFromPersonId , summary: self.txtVariationSummary.text!, gst: gstString, price: self.txtVariationPrice.text!, totalPrice: self.txtTotalPrice.text!, file: self.arrayOfAddedVariationsURL, project: self.ProjectId ?? 0, receiver: receiverIdArray) { success, eror, type in
            if success {
                self.navigationController?.popViewController(animated: true)
                self.showToast(message: "Variation Added successfully", font: .boldSystemFont(ofSize: 14.0))
                
            } else {
                self.showAlert(message: eror)
            }
        }
        

        
        
        
//        self.objAddVariations.addDocs(controller: self, name: txtName.text ?? "", description: txtFrom.text ?? "", size: "\(fileSize)", file: fileName, type: "variations" , project: ProjectId ?? 0) { (success, message, type) in
//            if success {
//                self.navigationController?.popViewController(animated: true)
//                self.showAlert(message: "Variation added successfully")
//            }else {
//                self.showAlert(message: message)
//            }
//        }
    }
    
    //MARK: Initial Load
    func initailLoad(){
        toBackgroundView.layer.cornerRadius = 4
        self.btnDone.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        self.btnDone.clipsToBounds = true
        txtTotalPrice.isUserInteractionEnabled = false
        txtTotalPrice.keyboardType = .numberPad
    }
    
}
//MARK: - Extension AddVariationsVC For Image Picker Controller
extension AddVariationsVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate,PhotoEditorDelegate {
    
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
extension AddVariationsVC: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
  uploadFile(urls: urls[0])
        
    }
    //Upload File
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
                    self.variationFileCollectionView.reloadData()

                    if self.arrayOfAddedVariations.count == 10 {
                        DispatchQueue.main.async {
                            self.addFileBtn.isHidden = true
                        }
                    }
                    self.showToast(message: "file uploaded successfully", font: .boldSystemFont(ofSize: 14.0))

                    self.view.layoutIfNeeded()
                } else {
                    self.showAlert(message: error?.localizedDescription ?? "")
                }
            }
        }
    }
}

extension AddVariationsVC: UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let a = collectionView as? ReceiverCollectionView {
            return selectedReceiverIdArray?.count ?? 0
        }
        print(arrayOfAddedVariations.count, "@#$!@#!@#$!@#$!@#$!@# C O L L E C T I O N V I E W $!@#$!@#$!@#$!@#$")
        
        return arrayOfAddedVariations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // dataArary is the managing array for your UICollectionView.
        if let a = collectionView as? ReceiverCollectionView {
            let item = selectedReceiverIdArray?[indexPath.row].person.firstName ?? "Hello"
            let itemSize = CGSize(width: item.size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]).width + 20, height: 44)
            return itemSize
        }
        let collectionViewWidth = self.variationFileCollectionView.bounds.size.width
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
            chipView.titleLabel.text = selectedReceiverIdArray?[indexPath.row].person.firstName
            chipView.setBackgroundColor( .systemGreen, for: .normal)
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
            vc.textFieldRef = txtFrom
            vc.selectedFromCallback = { person in
                self.txtFrom.text = "\(person.firstName) \(person.lastName)"
                self.selectedFromPersonId = person.id
                self.selectedReceiverIdArray = []
                self.receiverCollectionView.reloadData()
            }
            txtFrom.resignFirstResponder()
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

