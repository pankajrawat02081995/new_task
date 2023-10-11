
//
//  AddTaskVC.swift
//  Comezy
//
//  Created by shiphul on 21/12/21.
//

import UIKit
import MobileCoreServices
import DropDown
import iOSPhotoEditor

class AddTaskVC: UIViewController {
    let objPeopleListViewModel = PeopleListViewModel.shared
    var ProjectId: Int?
    var datePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    var toolBar = UIToolbar()
    var objAddTask = TaskListViewModel()
    var arrayOfAddedFiles = [String]()
    var arrayOfAddedFilesURL = [String]()
    var selectedIndex: Int?
    var WorkerId : Int?
    var startDateMillie : String?
    var endDateMillie : String?
    var setEndDate = Date()
    var didSelect = false
    var peopleList = PeopleListViewModel.shared.peopleListDataDetail
    var selectedWorkerId = 0
    var selectedPerson: PeopleClient?
    var imageName: String?

    
    var uploadUrls = [URL]()
    var arrayPath : URL?


    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var txtTaskName: UITextField!
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var txtTaskDesc: UITextView!
    @IBOutlet weak var txtWorkerName: UITextField!
    @IBOutlet weak var txtWorkerEmail: UITextField!
    @IBOutlet weak var txtWorkerOcc: UITextField!
    @IBOutlet weak var fileCollectionView: UICollectionView!
    @IBOutlet weak var btnAddFile: UIButton!
    @IBOutlet weak var stackViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var stackAssignWorker: UIStackView!
    
    @IBOutlet weak var btnDone: UIButton!
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.objPeopleListViewModel.clientListDataDetail.email = ""
        self.objPeopleListViewModel.clientListDataDetail.occupation?.name = ""
        self.objPeopleListViewModel.clientListDataDetail.firstName = ""
        initialLoad()
        fileCollectionView.reloadData()
        txtWorkerName.delegate = self
        // Do any additional setup after loading the view.
        print("Project Bt last Contrller ","\(ProjectId)")
        txtStartDate.delegate = self
        txtEndDate.delegate = self
        
        let workerTap = UITapGestureRecognizer(target: self, action: #selector(self.handleWorkerTap(_:)))
        stackAssignWorker.addGestureRecognizer(workerTap)
        
        
    }
    
    
    fileprivate enum TextField: Int {
        case txtStartDate
        case txtEndDate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
   
    
    func initialLoad() {
        txtWorkerName.attributedPlaceholder = NSAttributedString(string: "Eg: John Doe", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 202, green: 202, blue: 204)])
        txtWorkerName.setLeftPaddingPoints(10)
        //txtTaskDesc.setLeftPaddingPoints(10)
        
        self.btnDone.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        self.btnDone.clipsToBounds = true
        //ShowDatePicker()
        //ShowDatePicker2()
    }
    
    //MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if didSelect {
            self.txtWorkerName.text = self.objPeopleListViewModel.clientListDataDetail.firstName //+ self.objPeopleListViewModel.clientListDataDetail.lastName
            self.txtWorkerOcc.text = self.objPeopleListViewModel.clientListDataDetail.occupation?.name
            self.txtWorkerEmail.text = self.objPeopleListViewModel.clientListDataDetail.email
            txtWorkerEmail.becomeFirstResponder()
        }

        txtEndDate.isEnabled = false
        txtWorkerOcc.isEnabled = false
        txtWorkerEmail.isEnabled = false
    }
    
    @objc func handleWorkerTap(_ sender: UITapGestureRecognizer? = nil) {
        let dropDown = DropDown()
        let dropDownValues = peopleList.map { worker in
            "\(worker.firstName ?? "FirstName") \(worker.lastName ?? "LastName")"
        }
        let dropDownValuesId = peopleList.map { worker in
            worker.id ?? 0
        }
        dropDown.anchorView = txtWorkerName
        dropDown.dataSource = dropDownValues
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.selectedWorkerId = dropDownValuesId[index]
            self.txtWorkerName.text = dropDownValues[index]
            self.txtWorkerEmail.text = peopleList[index].email
            self.txtWorkerOcc.text = peopleList[index].occupation?.name
            self.selectedPerson = peopleList[index]
        }
//                   txtName.endEditing(true)
//                   txtName.resignFirstResponder()
//        txtWitness.inputView = UIView.init(frame: CGRect.zero)
//        txtWitness.inputAccessoryView = UIView.init(frame: CGRect.zero)
//
//        let vc = ScreenManager.getController(storyboard: .main, controller: AllPeopleVC()) as! AllPeopleVC
//        vc.ProjectId = self.ProjectId
//        vc.fromComponent = "txtFrom"
//        vc.textFieldRef = txtWitness
//        vc.selectedFromCallback = { person in
//            self.txtWitness.text = "\(person.firstName) \(person.lastName)"
//            self.selectedWitnessId = person.id
//            self.selectedReceiverIdArray = []
//        }
//        txtWitness.resignFirstResponder()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
//    func ShowDatePicker(){
//        datePicker.datePickerMode = .dateAndTime
//        let toolbar = UIToolbar();
//        toolbar.sizeToFit()
//        datePicker.minimumDate = Date()
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
//        toolbar.setItems([doneButton,cancelButton], animated: false)
//        txtStartDate.inputAccessoryView = toolbar
//        txtStartDate.inputView = datePicker
//
//
//    }
//
//    @objc func donedatePicker(){
//        let formatter = DateFormatter()
//        let newFormat = DateFormatter()
//        formatter.dateFormat = "dd/MM/yyyy"
//        txtStartDate.text = formatter.string(from: datePicker.date)
//        let someDate = Date()
//        let timeInterval = someDate.timeIntervalSince1970
//        newFormat.dateFormat = "\(Int(timeInterval))"
//        startDateMillie = newFormat.dateFormat
//
//        self.view.endEditing(true)
//
//    }
//        @objc func cancelDatePicker() {
//            self.view.endEditing(true)
//
//        }
//
//    func ShowDatePicker2() {
//        endDatePicker.datePickerMode = .dateAndTime
//        let toolbar = UIToolbar();
//        toolbar.sizeToFit()
//        endDatePicker.minimumDate = Date()
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker2));
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker2));
//        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
//        txtEndDate.inputAccessoryView = toolbar
//        txtEndDate.inputView = endDatePicker
//
//
//    }
//    @objc func donedatePicker2(){
//        let formatter = DateFormatter()
//        let newFormatter = DateFormatter()
//        formatter.dateFormat = "dd/MM/yyyy"
//        txtEndDate.text = formatter.string(from: endDatePicker.date)
//        let someDate = Date()
//        let timeInterval = someDate.timeIntervalSince1970
//        newFormatter.dateFormat = "\(Int(timeInterval))"
//        endDateMillie = newFormatter.dateFormat
//
//        self.view.endEditing(true)
//
//    }
//    @objc func cancelDatePicker2(){
//        self.view.endEditing(true)
//
//    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnback_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnHome_action(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func btnAddFile_action(_ sender: Any) {
        
        selectedIndex = nil
        showImagePickerOption(delegate:self)
    }
    
    //MARK: btnDone_action
    @IBAction func btnDone_action(_ sender: Any) {
        
        let randomColor = UIColor.random()
        let hexString = randomColor.toHexString()
        
        print(self.objPeopleListViewModel.clientListDataDetail.id)
        self.objAddTask.addTask(controller: self, task_name: txtTaskName.text ?? "", start_date: startDateMillie ?? "", end_date: endDateMillie ?? "", description: txtTaskDesc.text ?? "" , documents: arrayOfAddedFilesURL , project: ProjectId ?? 0, occupation: self.selectedPerson?.occupation?.id ?? 0  , assigned_worker: selectedWorkerId , status: "in_progress", color: hexString) { (success, message, type) in
            if success { 
                
                self.navigationController?.popViewController(animated: true)
                DispatchQueue.main.async {
                    self.showAlert(message: "Task added successfully")
                }
            } else {
                self.showAlert(message: message)
            }
        }
    }
    
    
    
    
    //MARK: documentPicker
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        uploadFile(urls: urls)
        }
    func uploadFile(urls:[URL]){
        if arrayOfAddedFiles.count <= 10 || selectedIndex != nil{
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = DateTimeFormat.kDateTimeFormat
            let timestamp = format.string(from: date)
            showProgressHUD(message: "")
            print("urls[0]", urls[0])
             arrayPath = urls[0]
            AWSS3Manager.shared.uploadImageFile(fileUrl: urls[0], fileName: "\(AWSFileDirectory.PUBLIC)\(AWSFileDirectory.TASK_FOLDER)\(AWSFileDirectory.TASK_FILE)\(arrayPath?.lastPathComponent)") { (progress) in
                print(progress)
            } completion: { (resp, error) in
                if error == nil {
                    self.hideProgressHUD()
                    let file = resp as! String
                    if self.selectedIndex == nil {
                        self.selectedIndex = nil
                    self.arrayOfAddedFilesURL.append(file)
                    } else {
                        self.arrayOfAddedFiles.remove(at: self.selectedIndex!)
                        self.arrayOfAddedFilesURL.insert(file, at: self.selectedIndex!)
                    }
                    self.arrayOfAddedFiles.append(urls[0].lastPathComponent)
                    
                    if self.arrayOfAddedFiles.count == 10 {
                        DispatchQueue.main.async {
                            self.btnAddFile.isHidden = true
                        }
                    }
                    
                    self.stackViewHeightConstraint.constant = CGFloat(60 * self.arrayOfAddedFiles.count)
                    self.view.layoutIfNeeded()
                    self.fileCollectionView.reloadData()
                } else {
                    self.showAlert(message: error?.localizedDescription ?? "")
                }
            }
        }else{
            btnAddFile.isHidden = true
        }
    }
   
    
}
//MARK: - Extension AddTaskVC For Image Picker Controller
extension AddTaskVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, PhotoEditorDelegate {
    
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
extension AddTaskVC: UITextFieldDelegate, UIDocumentPickerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfAddedFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddedFileCell", for: indexPath) as! AddedFileCell
        let item = arrayOfAddedFiles[indexPath.row]
        print("AddedFileCell  .. ", item)
        cell.fileName?.text = item
        cell.fileName.textAlignment = .center
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let collectionViewWidth = self.fileCollectionView.bounds.size.width
            return CGSize(width: collectionViewWidth, height: 50)
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    
    //MARK: TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtWorkerName {
            //To not show IQKeyboard
            didSelect = false
            txtWorkerName.inputView = UIView.init(frame: CGRect.zero)
            txtWorkerName.inputAccessoryView = UIView.init(frame: CGRect.zero)
            let vc = ScreenManager.getController(storyboard: .main, controller: PeopleVC()) as! PeopleVC
            vc.ProjectId = self.ProjectId
            vc.fromViewController = "daily"
            vc.didSelect = { bool in
                self.didSelect = bool
            }
            self.navigationController?.pushViewController(vc, animated: true)
        
        }
        
        if textField == txtStartDate {
            txtStartDate.inputView = datePicker
            if txtStartDate.text == "" {
                dateChanged(datePicker)
            }
            
                datePicker.backgroundColor = UIColor.white
                datePicker.autoresizingMask = .flexibleWidth
                datePicker.datePickerMode = .date

            datePicker.preferredDatePickerStyle = .wheels
                datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
            datePicker.backgroundColor = .clear


            print(txtStartDate.frame)
            print(txtStartDate.top)

//                self.view.addSubview(datePicker)
                        
//                toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
//                toolBar.barStyle = .blackTranslucent
//                toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
//                toolBar.sizeToFit()
//                self.view.addSubview(toolBar)
        }
        
       
        
        if txtStartDate != nil{
            
            txtEndDate.isEnabled = true
        }else{
            txtEndDate.isEnabled = false
        }
          
        if textField == txtEndDate{
            txtEndDate.inputView = endDatePicker
            if txtEndDate.text == "" {
                endDateChanged(datePicker)
            }
            endDatePicker.backgroundColor = .clear
                    
            endDatePicker.autoresizingMask = .flexibleWidth
            endDatePicker.datePickerMode = .date
            endDatePicker.preferredDatePickerStyle = .wheels
            endDatePicker.minimumDate = setEndDate
            endDatePicker.addTarget(self, action: #selector(self.endDateChanged(_:)), for: .valueChanged)
                    
//            toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
//            toolBar.barStyle = .blackTranslucent
//            toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick2))]
//            toolBar.sizeToFit()
//            self.view.addSubview(toolBar)
        }
        
        
            
    }
    @objc func endDateChanged(_ sender: UIDatePicker?) {
        
        let enddateFormatter = DateFormatter()
        let endnewFormat = DateFormatter()
        enddateFormatter.dateStyle = .short
        enddateFormatter.timeStyle = .none
            
        if let endDate = sender?.date{
            print("Picked the endDate \(enddateFormatter.string(from: endDate))")
            txtEndDate.text = "\(enddateFormatter.string(from: endDate))"
            let timeInterval = endDate.timeIntervalSince1970
            endnewFormat.dateFormat = "\(Int(timeInterval))"
            endDateMillie = endnewFormat.dateFormat
            print(endDateMillie)
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
        let dateFormatter = DateFormatter()
        let newFormat = DateFormatter()
       
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
            
        if let date = sender?.date {
        
            print("Picked the start date \(dateFormatter.string(from: date))")
            txtStartDate.text = "\(dateFormatter.string(from: date))"
            setEndDate = date
            let timeInterval = date.timeIntervalSince1970
            newFormat.dateFormat = "\(Int(timeInterval))"
            startDateMillie = newFormat.dateFormat
            print(startDateMillie, "fcchjsbvchsbchjdsv")
            
        }
        
    }

    @objc func onDoneButtonClick() {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
    }
    
    @objc func onDoneButtonClick2() {
        toolBar.removeFromSuperview()
        endDatePicker.removeFromSuperview()
    }
    
    
    
    
}


