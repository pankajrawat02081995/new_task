//
//  EditIncidentReportVC.swift
//  Comezy
//
//  Created by aakarshit on 02/07/22.
//

import UIKit
import MobileCoreServices
import DropDown
import iOSPhotoEditor

class EditIncidentReportVC: UIViewController {

    //MARK: - Variable
    //Variable
    let objAddIncidentReport = EditIncidentReportViewModel()
    let objPeopleListViewModel = PeopleListViewModel.shared
    var arrayOfAddedVariations = [String]()
    var arrayOfAddedVariationsURL = [String?]()
    var fileSize : UInt64 = 0
    var fileName = ""
    var ProjectId: Int?
    var isFileUploaded = false
    var isGSTApplied = true
    var arrayPath : URL?
    var selectedIndex: Int?
    var selectedReceiverIdArray: [SelectedReceiver]?
    var datePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    var setEndDate = Date()
    var startDateMillie : String?
    var endDateMillie : String?
    var incidentTimePicker = UIDatePicker()
    var incidentTimeReportedPicker = UIDatePicker()
    var objIncidentDetails: IncidentResult?
    var incidentId: Int?
    var previousRef: IncidentReportDetailVC?
    var imageName: String?
    var selectedFile = ""
    var selectedFromPersonId: Int?
    var selectedWitnessId: Int?
    var typeOfIncidentId: Int?
    
    //MARK: - IB Outlet
    @IBOutlet weak var txtDateOfIncident: UITextField!
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var txtDescriptionOfIncident: UITextView!
    @IBOutlet weak var txtDateOfIncidentReported: UITextField!
    @IBOutlet weak var txtTypeOfIncident: UITextField!
    @IBOutlet weak var txtTimeOfIncident: UITextField!
    @IBOutlet weak var txtTimeOfIncidentReported: UITextField!
    @IBOutlet weak var txtPreventiveActionTaken: UITextField!
    @IBOutlet weak var addFileBtn: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var variationFileCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fromStackView: UIStackView!
    @IBOutlet weak var witnessStackView: UIStackView!
    @IBOutlet weak var txtWitness: UITextField!
    @IBOutlet weak var typeOfIncidentStack: UIStackView!
    
    
  

    
    //MARK: Veiw Controller Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        txtFrom.isUserInteractionEnabled = false
        txtFrom.isEnabled = false
        txtWitness.isUserInteractionEnabled = false
        txtWitness.isEnabled = false
        variationFileCollectionView.delegate = self
        variationFileCollectionView.dataSource = self
        variationFileCollectionView.reloadData()
        initailLoad()
        txtFrom.delegate = self
        setupDelegates()
        let fromTap = UITapGestureRecognizer(target: self, action: #selector(self.handleFromTapped(_:)))
        fromStackView.addGestureRecognizer(fromTap)
        
        let witnessTap = UITapGestureRecognizer(target: self, action: #selector(self.handleWitnessTapped(_:)))
        witnessStackView.addGestureRecognizer(witnessTap)
        
        let typeOfIncidentTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTypeOfIncidentTapped(_:)))
        typeOfIncidentStack.addGestureRecognizer(typeOfIncidentTap)
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadInfo()
        variationFileCollectionView.reloadData()
        
    }
    
    //Method to load info
    func loadInfo() {
        
        let ref = objIncidentDetails
        
        txtDateOfIncident.text = ref?.dateOfIncident
        txtTimeOfIncident.text = ref?.timeOfIncident
        txtDescriptionOfIncident.text = ref?.descriptionOfIncident
        txtPreventiveActionTaken.text = ref?.preventativeActionTaken
        txtTimeOfIncidentReported.text = ref?.timeOfIncidentReported
        txtDateOfIncidentReported.text = ref?.dateOfIncidentReported
        txtTypeOfIncident.text = ref?.typeOfIncident?.name
        arrayOfAddedVariationsURL = ref?.files ?? []
        var count = 0
        if let files = ref?.files {
            arrayOfAddedVariations = files.map({ str in
                if let url = URL(string: str ?? "") {
                    if url.lastPathComponent == "" {
                        count += 1
                        return "file\(count)"
                    }
                    return url.lastPathComponent
                } else {
                    return "Error"
                }
            })
        }

        variationFileCollectionView.reloadData()
        self.collectionViewHeightConstraint.constant = CGFloat(60 * self.arrayOfAddedVariations.count)

        
        //MARK: Manage who can delete and edit
//        self.manageUI(id: ref?.sender.id)
        if let firstName = ref?.witnessOfIncident?.firstName, let lastName = ref?.witnessOfIncident?.lastName {
            txtWitness.text =  firstName + " " + lastName
        }else{
            txtWitness.text = ref?.visitor_witness
        }
        
        if let firstName = ref?.personCompletingForm?.firstName, let lastName = ref?.personCompletingForm?.lastName {
            txtFrom.text =  firstName + " " + lastName
        }
        
        let dateString = ref?.dateOfIncident
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: localeIdentifier.en_USA)
        dateFormatter.dateFormat = DateTimeFormat.kyy_MM_dd
        if let date = dateFormatter.date(from: dateString!) {
          let dateToTimeInterval = date.timeIntervalSince1970
            let dateString = String(dateToTimeInterval)
            let doublString = Double(dateString)!
            let intDateString = Int(doublString)
            startDateMillie = String(intDateString)

        }
        
        let endDateString = ref?.dateOfIncidentReported
        dateFormatter.locale = Locale(identifier: localeIdentifier.en_USA)
        dateFormatter.dateFormat = DateTimeFormat.kyy_MM_dd
        if let date = dateFormatter.date(from: endDateString!) {
          let dateToTimeInterval = date.timeIntervalSince1970
            let dateString = String(dateToTimeInterval)
            let doublString = Double(dateString)!
            let intDateString = Int(doublString)
            endDateMillie = String(intDateString)

        }
    }
    
    //Method to setup Delegates
    func setupDelegates() {
        txtDateOfIncident.delegate = self
        //txtDescriptionOfIncident.delegate = self
        txtDateOfIncidentReported.delegate = self
        txtTimeOfIncident.delegate = self
        txtTimeOfIncidentReported.delegate = self
        txtTypeOfIncident.delegate = self
    }

    //MARK: Button back
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Method to Setup Gesture on From Tap
    @objc func handleFromTapped(_ sender: UITapGestureRecognizer? = nil) {
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
        }
        txtFrom.resignFirstResponder()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Method to Setup Gesture on witness Tap
    @objc func handleWitnessTapped(_ sender: UITapGestureRecognizer? = nil) {
        //           txtName.endEditing(true)
        //           txtName.resignFirstResponder()
        txtWitness.inputView = UIView.init(frame: CGRect.zero)
        txtWitness.inputAccessoryView = UIView.init(frame: CGRect.zero)
        
        let vc = ScreenManager.getController(storyboard: .main, controller: AllPeopleVC()) as! AllPeopleVC
        vc.ProjectId = self.ProjectId
        vc.fromComponent = "txtFrom"
        vc.textFieldRef = txtWitness
        vc.selectedFromCallback = { person in
            self.txtWitness.text = "\(person.firstName) \(person.lastName)"
            self.selectedWitnessId = person.id
            self.selectedReceiverIdArray = []
        }
        txtWitness.resignFirstResponder()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Method to Setup Gesture on Type of incident Tap
    @objc func handleTypeOfIncidentTapped(_ sender: UITapGestureRecognizer? = nil) {
        let dropDown = DropDown()
        let dropDownValues = IncidentTypeList.incidentType
        dropDown.anchorView = txtTypeOfIncident
        dropDown.dataSource = dropDownValues
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.txtTypeOfIncident.text = dropDownValues[index]
            typeOfIncidentId = index
        }
        

    }
    
    

    
    //MARK: - IB Button action
    @IBAction func btnHome_action(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: Add File
    @IBAction func btnAddFile_action(_ sender: Any) {
        showImagePickerOption(delegate:self)
        
    }
    
    
    
    //MARK: BTN DONE
    @IBAction func btnDone_action(_ sender: Any) {
        print(endDateMillie)
        print(startDateMillie)
        self.objAddIncidentReport.editIncident(name: "incidentreport", dateOfIncidentReported: endDateMillie ?? "", dateOfIncident: startDateMillie ?? "", timeOfIncident: txtTimeOfIncident.text ?? "", timeOfIncidentReported: txtTimeOfIncidentReported.text ?? "", descriptionOfIncident: txtDescriptionOfIncident.text ?? "", preventiveActionTaken: txtPreventiveActionTaken.text ?? "", file: arrayOfAddedVariationsURL, project: incidentId ?? 0) { success, response, error in
            if success {
                self.previousRef?.didEdit = true
                self.navigationController?.popViewController(animated: true)
                self.showToast(message: SuccessMessage.kIncidentReportEdit)
            } else {
                self.showAlert(message: error)
            }
        }
    }
    
    //MARK: User Defined Method
    func initailLoad(){
        self.btnDone.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        self.btnDone.clipsToBounds = true
    }

}

//MARK: - Extension EditIncidentReportVC For Image Picker Controller
extension EditIncidentReportVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, PhotoEditorDelegate{
    
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
extension EditIncidentReportVC: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
       uploadFile(urls: urls)
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
            AWSS3Manager.shared.uploadImageFile(fileUrl: urls[0], fileName: "\(AWSFileDirectory.PUBLIC)\(AWSFileDirectory.INCIDENT_FOLDER)\(AWSFileDirectory.INCIDENT_FILE)\(arrayPath!.lastPathComponent)") { (progress) in

                print(progress)
            } completion: { (resp, error) in
                if error == nil {
                    self.hideProgressHUD()
                    let file = resp as! String
                    self.arrayOfAddedVariationsURL.append(file)
                    self.arrayOfAddedVariations.append(urls[0].lastPathComponent)
                    self.collectionViewHeightConstraint.constant = CGFloat(60 * self.arrayOfAddedVariations.count)
                    self.variationFileCollectionView.reloadData()
                    
                    if self.arrayOfAddedVariations.count == 10 {
                        DispatchQueue.main.async {
                            self.addFileBtn.isHidden = true
                        }
                    }
                    self.showToast(message: SuccessMessage.kFileUpload, font: .boldSystemFont(ofSize: 14.0))

                    self.view.layoutIfNeeded()
                } else {
                    self.showAlert(message: error?.localizedDescription ?? "")
                }
            }
        }
    }
}

//MARK: - Extension of EditIncidentReportVC
extension EditIncidentReportVC: UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let a = collectionView as? ReceiverCollectionView {
            return selectedReceiverIdArray?.count ?? 0
        }
        
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddVariationDocCell", for: indexPath) as! AddVariationDocCell
        let item = arrayOfAddedVariations[indexPath.row]
        cell.VariationFileLabel.text = item
        cell.VariationFileLabel.textAlignment = .center
        return cell
        
        
        
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
                //                self.receiverCollectionView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
            txtFrom.endEditing(true)
            
        }
        
        //MARK: txtDateOfIncident
        if textField == txtDateOfIncident {

            txtDateOfIncident.inputView = datePicker
            
            if txtDateOfIncident.text == "" {
                dateChanged(datePicker)
            }
            
            datePicker.backgroundColor = UIColor.white
            datePicker.autoresizingMask = .flexibleWidth
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
            datePicker.backgroundColor = .clear
            print(txtDateOfIncident.top)
        }
        
        if txtDateOfIncident != nil{
            
            txtDateOfIncidentReported.isEnabled = true
        }else{
            txtDateOfIncidentReported.isEnabled = false
        }
        
        if textField == txtDateOfIncidentReported {
            
            if txtDateOfIncident.text == "" {
                txtDateOfIncidentReported.isEnabled = false
                txtDateOfIncidentReported.inputView = UIView()
                txtDateOfIncidentReported.inputAccessoryView = UIView()
                textField.tintColor = .white
                showToast(message: FieldValidation.selectIncidentDate)
            } else {
                txtDateOfIncidentReported.inputView = endDatePicker
                if txtDateOfIncidentReported.text == "" {
                    endDateChanged(datePicker)
                }
                endDatePicker.backgroundColor = .clear
                
                endDatePicker.autoresizingMask = .flexibleWidth
                endDatePicker.datePickerMode = .date
                endDatePicker.preferredDatePickerStyle = .wheels
                endDatePicker.minimumDate = setEndDate
                endDatePicker.addTarget(self, action: #selector(self.endDateChanged(_:)), for: .valueChanged)
            }
            
        }
        
        //MARK: TimeOfIncident
        if textField == txtTimeOfIncident {
            txtTimeOfIncident.inputView = incidentTimePicker
            
            incidentTimePicker.backgroundColor = .clear
            //To make time picker 24 hour
            incidentTimePicker.autoresizingMask = .flexibleWidth
            incidentTimePicker.datePickerMode = .time
            incidentTimePicker.preferredDatePickerStyle = .wheels
            incidentTimePicker.addTarget(self, action: #selector(self.incidentTimeChanged(_:)), for: .valueChanged)
        }
        
        if textField == txtTimeOfIncidentReported {
            txtTimeOfIncidentReported.inputView = incidentTimeReportedPicker
            
            incidentTimeReportedPicker.backgroundColor = .clear
            //To make time picker 24 hour
            incidentTimeReportedPicker.autoresizingMask = .flexibleWidth
            incidentTimeReportedPicker.datePickerMode = .time
            incidentTimeReportedPicker.preferredDatePickerStyle = .wheels
            incidentTimeReportedPicker.addTarget(self, action: #selector(self.incidentTimeReportedChanged(_:)), for: .valueChanged)
        }
        
        if textField == txtTypeOfIncident {
            txtTypeOfIncident.isEnabled = false
            txtTypeOfIncident.isUserInteractionEnabled = false
            txtTypeOfIncident.inputView = UIView()
            txtTypeOfIncident.inputAccessoryView = UIView()
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == txtDateOfIncident {
            txtDateOfIncidentReported.text = ""
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
        txtDateOfIncidentReported.text = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let newFormat = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: localeIdentifier.en_USA)
        dateFormatter.dateFormat = DateTimeFormat.kyy_MM_dd
        if let date = sender?.date {
            txtDateOfIncident.text = "\(dateFormatter.string(from: date))"
            setEndDate = date
            let timeInterval = date.timeIntervalSince1970
            newFormat.dateFormat = "\(Int(timeInterval))"
            startDateMillie = newFormat.dateFormat
        }
    }
    @objc func endDateChanged(_ sender: UIDatePicker?) {
        
        let dateFormatter = DateFormatter()
        let newFormat = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: localeIdentifier.en_USA)
        dateFormatter.dateFormat =  DateTimeFormat.kyy_MM_dd
        if let endDate = sender?.date{
            txtDateOfIncidentReported.text = "\(dateFormatter.string(from: endDate))"
            let timeInterval = endDate.timeIntervalSince1970
            newFormat.dateFormat = "\(Int(timeInterval))"
            endDateMillie = newFormat.dateFormat
            print(endDateMillie)
        }
    }
    
    @objc func incidentTimeChanged(_ sender: UIDatePicker?) {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        formatter.dateFormat = DateTimeFormat.kTimeHH_mm_SS

        
        if let incidentTime = sender?.date {
            txtTimeOfIncident.text = "\(formatter.string(from: incidentTime))"
        }
    }
    
    @objc func incidentTimeReportedChanged(_ sender: UIDatePicker?) {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        formatter.dateFormat = DateTimeFormat.kTimeHH_mm_SS

        if let incidentTime = sender?.date {
            txtTimeOfIncidentReported.text = "\(formatter.string(from: incidentTime))"
        }
    }
}
