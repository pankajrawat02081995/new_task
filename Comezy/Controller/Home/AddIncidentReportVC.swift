//
//  AddIncidentReportVC.swift
//  Comezy
//
//  Created by aakarshit on 30/06/22.
//

import UIKit
import MobileCoreServices
import DropDown
import iOSPhotoEditor

class AddIncidentReportVC: UIViewController {
    //MARK: - Variable
    //Variables
    let objAddIncidentReport = AddIncidentReportViewModel()
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
    var datePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    var setEndDate = Date()
    var startDateMillie : String?
    var endDateMillie : String?
    var incidentTimePicker = UIDatePicker()
    var incidentTimeReportedPicker = UIDatePicker()
    var peopleList = PeopleListViewModel.shared.peopleListDataDetail
    var imageName: String?
    var selectedFile = ""
    var selectedFromPersonId: Int?
    var selectedWitnessId: Int? = -1
    var typeOfIncidentId: Int?
    var incidentTypes: [IncidentTypeResult]?
    var incidentTypeNameList: [String]?
    
    //MARK: - IB Outlets
    //IB Outlet of storyboard view
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
    @IBOutlet weak var visitor_witness_phone: UITextField!
    @IBOutlet weak var typeOfIncidentStack: UIStackView!
    @IBOutlet weak var visitor_witness_name: UITextField!
    @IBOutlet weak var visitor_witness_name_stack: UIStackView!
    @IBOutlet weak var visitor_witness_phone_stack: UIStackView!
    
    
    //MARK: ViewDidLoad
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
        print(ProjectId)
        initailLoad()
        txtFrom.delegate = self
        setupDelegates()
        let fromTap = UITapGestureRecognizer(target: self, action: #selector(self.handleFromTapped(_:)))
        fromStackView.addGestureRecognizer(fromTap)
        
        let witnessTap = UITapGestureRecognizer(target: self, action: #selector(self.handleWitnessTapped(_:)))
        witnessStackView.addGestureRecognizer(witnessTap)
        
        let typeOfIncidentTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTypeOfIncidentTapped(_:)))
        typeOfIncidentStack.addGestureRecognizer(typeOfIncidentTap)
        objAddIncidentReport.getIncidentType { status, listInfo, errorMsg in
            if status {
                self.incidentTypes = listInfo?.results
                self.getIncidentTypeNamesList()
            }
        }
        ///API Method call of all User list
        objAddIncidentReport.getAllPeopleList(project_id: ProjectId ?? 0) { success, peopleList, errorMsg in
                if success {
                    //Removing the selected sender from all people list
                    self.objAddIncidentReport.allPeopleSearchedListDataDetail = peopleList ?? []
                    self.objAddIncidentReport.allWitnessListDataDetail = peopleList ?? []
                    ///Adding other item if user not available in our application
                    self.objAddIncidentReport.allWitnessListDataDetail.append(AllPeopleListElement(id: 0, firstName: "Other", lastName: "", phone: "", email: "", profilePicture: "", userType: "", occupation: Occupation(id: 0,name: "")))
                    
                } else {
                    self.showAlert(message: errorMsg)
                }
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func getIncidentTypeNamesList() {
        if let list = incidentTypes {
            let myList = list.compactMap { incident in
                return incident.name
            }
            incidentTypeNameList = myList
        }
    }
    
    func setupDelegates() {
        txtDateOfIncident.delegate = self
        txtDateOfIncidentReported.delegate = self
        txtTimeOfIncident.delegate = self
        txtTimeOfIncidentReported.delegate = self
        txtTypeOfIncident.delegate = self
    }
    
    //MARK: Button back
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleFromTapped(_ sender: UITapGestureRecognizer? = nil) {
        let dropDown = DropDown()
        let dropDownValues = self.objAddIncidentReport.allPeopleSearchedListDataDetail.map { worker in
            "\(worker.firstName ?? "FirstName") \(worker.lastName ?? "LastName")(\(worker.userType ?? "Other"))"
        }
        let dropDownValuesId = self.objAddIncidentReport.allPeopleSearchedListDataDetail.map { worker in
            worker.id ?? 0
        }
        dropDown.anchorView = txtFrom
        dropDown.dataSource = dropDownValues
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.selectedFromPersonId = dropDownValuesId[index]
            self.txtFrom.text = dropDownValues[index]
        }


    }
    
    @objc func handleWitnessTapped(_ sender: UITapGestureRecognizer? = nil) {
        let dropDown = DropDown()
        
        let dropDownValues:[String] = self.objAddIncidentReport.allWitnessListDataDetail.map { worker in
            if (worker.firstName != "Other"){
                return "\(worker.firstName ?? "FirstName") \(worker.lastName ?? "LastName")(\(worker.userType ?? "Other"))"
            }else{
                return "\(worker.firstName ?? "FirstName")"
            }
        }
        let dropDownValuesId = self.objAddIncidentReport.allWitnessListDataDetail.map { worker in
            worker.id ?? 0
        }
        dropDown.anchorView = txtWitness
        dropDown.dataSource = dropDownValues
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.selectedWitnessId = dropDownValuesId[index]
            self.txtWitness.text = dropDownValues[index]
            if(dropDownValues[index]=="Other"){
                self.visitor_witness_name_stack.isHidden = false
                self.visitor_witness_phone_stack.isHidden = false
                self.selectedWitnessId = nil

            }else{
                self.visitor_witness_name_stack.isHidden = true
                self.visitor_witness_phone_stack.isHidden = true
                self.visitor_witness_name.text = ""
                self.visitor_witness_phone.text = ""
            }
        }
    }
    
    @objc func handleTypeOfIncidentTapped(_ sender: UITapGestureRecognizer? = nil) {
        let dropDown = DropDown()
        guard let values = incidentTypeNameList else {return}
        let dropDownValues = values
        dropDown.anchorView = txtTypeOfIncident
        dropDown.dataSource = dropDownValues
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.txtTypeOfIncident.text = dropDownValues[index]
            typeOfIncidentId = incidentTypes?[index].id
            print("Incident Id->", typeOfIncidentId)
        }
        

    }
    
    @IBAction func btnHome_action(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: Add File
    @IBAction func btnAddFile_action(_ sender: Any) {
        showImagePickerOption(delegate: self)
        
    }
    
    //MARK: BTN DONE
    @IBAction func btnDone_action(_ sender: Any) {
        self.objAddIncidentReport.addIncidentReport(name: "incidentreport", dateOfIncidentReported: endDateMillie ?? "", dateOfIncident: startDateMillie ?? "", typeOfIncident: typeOfIncidentId, timeOfIncident: txtTimeOfIncident.text ?? "", timeOfIncidentReported: txtTimeOfIncidentReported.text ?? "", descriptionOfIncident: txtDescriptionOfIncident.text ?? "", preventiveActionTaken: txtPreventiveActionTaken.text ?? "", personCompletingForm: selectedFromPersonId ?? 0 , witnessOfIncident: selectedWitnessId, witnessOfIncidentName: self.txtWitness.text, file: arrayOfAddedVariationsURL, project: ProjectId ?? 0,visitor_witness_name: self.visitor_witness_name.text ?? "" ,visitor_witness_phone: self.visitor_witness_phone.text ?? "") { success, response, error in
            if success {
                self.navigationController?.popViewController(animated: true)
                self.showToast(message: SuccessMessage.kIncidentReportAdded)
            }else if(response != nil) {
                self.showToast(message: response!)

            }
        }

    }
    
    //MARK: User Defined Function
    func initailLoad(){
        self.btnDone.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        self.btnDone.clipsToBounds = true
    }
    

}
//MARK: - Extension AddIncidentReportVC For Image Picker Controller
extension AddIncidentReportVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, PhotoEditorDelegate{
    
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
        //photoEditor.stickers.append(UIImage(named: "sticker" )!)
        
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
extension AddIncidentReportVC: UIDocumentPickerDelegate{
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
                    self.showToast(message: SuccessMessage.kFileUpload, font: .boldSystemFont(ofSize: 14.0))

                    self.view.layoutIfNeeded()
                } else {
                    self.showAlert(message: error?.localizedDescription ?? "")
                }
            }
        }
        
    }
}

extension AddIncidentReportVC: UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddVariationDocCell", for: indexPath) as! AddVariationDocCell
        let item = arrayOfAddedVariations[indexPath.row]
        print("AddedFileCell  .. ", item)
        cell.VariationFileLabel.text = item
        
        cell.VariationFileLabel.textAlignment = .center
        print(cell.VariationFileLabel, "@#$!@#!@#$!@#$!@#$!@#$!@# F I L E N A M E $!@#$!@#$!@#$!@#$")
        
        return cell
        
        
        
    }
    
    //MARK: TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        /// From
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
        
        /// txtDateOfIncident
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
                showToast(message: "Please select Date of Incident first")
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
//            incidentTimePicker.locale = Locale(identifier: "en_GB")
            incidentTimePicker.autoresizingMask = .flexibleWidth
            incidentTimePicker.datePickerMode = .time
            incidentTimePicker.preferredDatePickerStyle = .wheels
            incidentTimePicker.addTarget(self, action: #selector(self.incidentTimeChanged(_:)), for: .valueChanged)
        }
        
        if textField == txtTimeOfIncidentReported {
            txtTimeOfIncidentReported.inputView = incidentTimeReportedPicker
            
            incidentTimeReportedPicker.backgroundColor = .clear
            //To make time picker 24 hour
//            incidentTimePicker.locale = Locale(identifier: "en_GB")
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
        print("TextField did change called")
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
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = sender?.date {
            print("Picked the start date \(dateFormatter.string(from: date))")
                        txtDateOfIncident.text = "\(dateFormatter.string(from: date))"
                        setEndDate = date
            let timeInterval = date.timeIntervalSince1970
            newFormat.dateFormat = "\(Int(timeInterval))"
            startDateMillie = newFormat.dateFormat
            print(startDateMillie, "fcchjsbvchsbchjdsv")
        }
                
    }
    @objc func endDateChanged(_ sender: UIDatePicker?) {
        
        let dateFormatter = DateFormatter()
        let newFormat = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        if let endDate = sender?.date{
            print("Picked the endDate \(dateFormatter.string(from: endDate))")
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
        formatter.dateFormat = "HH:mm:SS"

        
        if let incidentTime = sender?.date {
            print("Picked Incident Time \(incidentTime)")
            txtTimeOfIncident.text = "\(formatter.string(from: incidentTime))"
        }
    }
    
    @objc func incidentTimeReportedChanged(_ sender: UIDatePicker?) {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        formatter.dateFormat = "HH:mm:SS"

        
        if let incidentTime = sender?.date {
            print("Picked Incident Reported Time \(incidentTime)")
            txtTimeOfIncidentReported.text = "\(formatter.string(from: incidentTime))"
        }
    }
}
