//
//  AddPunchVC.swift
//  Comezy
//
//  Created by aakarshit on 18/06/22.
//

import UIKit
import MobileCoreServices
import MaterialComponents.MaterialChips
import MaterialComponents
import iOSPhotoEditor

class AddPunchVC: UIViewController {
    
       let objAddPunchViewModel = AddPunchViewModel()
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
       var checkArray:[String] = []
    var imageName: String?
    
       @IBOutlet weak var txtName: UITextField!
       @IBOutlet weak var txtFrom: UITextField!
       @IBOutlet weak var addFileBtn: UIButton!
       @IBOutlet weak var btnDone: UIButton!
       @IBOutlet weak var txtInfoNeeded: UITextView!
       @IBOutlet weak var toBackgroundView: UIView!
       @IBOutlet weak var variationFileCollectionView: UICollectionView!
       @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
       @IBOutlet weak var fromStackView: UIStackView!
       
       @IBOutlet weak var btnAddReceiver: UIButton!
       @IBOutlet weak var receiverCollectionView: ReceiverCollectionView!
    @IBOutlet weak var addPunchCheckTableView: AddPunchCheckTableView!
    @IBOutlet weak var btnAddCheck: UIButton!
    @IBOutlet weak var addCheckTableViewHeightConstraint: NSLayoutConstraint!
    
       var selectedFile = ""
       var selectedFromPersonId: Int?
       
       //MARK: ViewDidLoad
       override func viewDidLoad() {
           super.viewDidLoad()
           hideKeyboardWhenTappedAround()
           txtFrom.isUserInteractionEnabled = false
           txtFrom.isEnabled = false
           
           btnAddCheck.setTitle("", for: .normal)
           
           receiverCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
           let layout = MDCChipCollectionViewFlowLayout()
           receiverCollectionView.collectionViewLayout = layout
           
           variationFileCollectionView.delegate = self
           variationFileCollectionView.dataSource = self
           print("View Did Load")
           variationFileCollectionView.reloadData()
           print(ProjectId)
           initailLoad()
           txtFrom.delegate = self
           
           let nib = UINib(nibName: "AddPunchCheckTableViewCell", bundle: nil)
           addPunchCheckTableView.register(nib, forCellReuseIdentifier: "AddPunchCheckCell")
           
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
       
       //MARK: Button back
       @IBAction func btnBack_action(_ sender: Any) {
           self.navigationController?.popViewController(animated: true)
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
       

       
       //MARK: BTN DONE
       @IBAction func btnDone_action(_ sender: Any) {
           
           var receiverIdArray = [Int]()
           if let safeReceiverIdArray = selectedReceiverIdArray {
               for i in safeReceiverIdArray {
                   receiverIdArray.append(i.receiverId!)
               }

           }
           
           print(receiverIdArray)
           
           
           self.objAddPunchViewModel.addPunch(name: self.txtName.text ?? "" , sender: self.selectedFromPersonId , infoNeeded: self.txtInfoNeeded.text ?? "" , file: self.arrayOfAddedVariationsURL, project: self.ProjectId ?? 0, receiver: receiverIdArray, checklist: checkArray) { success, eror, type in
               if success {
                   self.navigationController?.popViewController(animated: true)

                   self.showToast(message: "Punch added successfully", font: .boldSystemFont(ofSize: 14.0))

               } else {
                   self.showToast(message: eror ?? "Oops! an error occured.")
               }
           }
       }
       
       //MARK: Initial Load
       func initailLoad(){
           toBackgroundView?.layer.cornerRadius = 4
           self.btnDone.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
           self.btnDone.clipsToBounds = true
       }
    //MARK: Add Check Pressed
    @IBAction func addCheck_action(_ sender: Any) {
        checkArray.append("")
        addCheckTableViewHeightConstraint.constant += 130
        addPunchCheckTableView.reloadData()
        print("addCheck called")
        print(checkArray)
    }

}
    //MARK: - Extension AddVariationsVC For Image Picker Controller
    extension AddPunchVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, PhotoEditorDelegate {
        
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
   extension AddPunchVC: UIDocumentPickerDelegate {
       func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

           uploadFile(urls:urls)
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
               AWSS3Manager.shared.uploadImageFile(fileUrl: urls[0], fileName: "\(AWSFileDirectory.PUBLIC)\(AWSFileDirectory.PUNCH_FOLDER)\(AWSFileDirectory.PUNCH_FILE)\(arrayPath!.lastPathComponent)") { (progress) in

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
                       self.variationFileCollectionView.reloadData()

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

   extension AddPunchVC: UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
       
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

//MARK: TableView
extension AddPunchVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return checkArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == addPunchCheckTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddPunchCheckCell", for: indexPath) as! AddPunchCheckTableViewCell
            cell.didEndEditCallback = { text in
                self.checkArray[indexPath.section] = text
            }
            cell.punchTextField.text = checkArray[indexPath.section]
            cell.cancelCallback = {
                self.checkArray.remove(at: indexPath.section)
                self.addCheckTableViewHeightConstraint.constant -= 130
                self.addPunchCheckTableView.reloadData()
            }
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let headerView = UIView()
           headerView.backgroundColor = UIColor.clear
           return headerView
       }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
        }
    
    
}
