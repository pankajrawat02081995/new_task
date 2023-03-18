//
//  EOTEditVC.swift
//  Comezy
//
//  Created by aakarshit on 24/06/22.
//

import UIKit
import MobileCoreServices
import MaterialComponents.MaterialChips
import MaterialComponents

class EOTEditVC: UIViewController {

    
    var eotId: Int?
    let objAddEOTViewModel = AddEOTViewModel()
    let objPeopleListViewModel = PeopleListViewModel.shared
    var objEOTDetailModel: EOTDetailModel?
    var objEditEOTViewModel = EditEOTViewModel()
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
    var recievers: [EOTSender]?
    
    var toolBar = UIToolbar()

    var datePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    var setEndDate = Date()
    var startDateMillie : String?
    var endDateMillie : String?

    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var btnAddTo: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var receiverCollectionView: ReceiverCollectionView!
    @IBOutlet weak var toBackgroundView: UIView!
    @IBOutlet weak var txtReasonForDelay: UITextView!
    @IBOutlet weak var txtNumberOfDays: UITextField!
    @IBOutlet weak var txtExtendedFromDate: UITextField!
    @IBOutlet weak var txtExtendedToDate: UITextField!
    
    
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
        
        txtExtendedFromDate.delegate = self
        txtExtendedToDate.delegate = self

        receiverCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
        let layout = MDCChipCollectionViewFlowLayout()
        receiverCollectionView.collectionViewLayout = layout
        
        
        print("View Did Load")
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
    
    func ajDateFormat(string: String) -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "EE, MMM d"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    //MARK: Load Info
    func loadInformation() {
        guard let ref = objEOTDetailModel else {return}
        recievers = ref.receiver
        txtTitle.text = ref.name
        txtFrom.text = "\(ref.sender.firstName) \(ref.sender.lastName)"
        txtFrom.textColor = .systemGray
        txtReasonForDelay.text = ref.reasonForDelay
        txtNumberOfDays.text = ref.numberOfDays
        
        let dateString = ref.extendDateFrom
        print(dateString)
        let dateFormatter = DateFormatter()
       // dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
       

        if let date = dateFormatter.date(from: dateString) {
          let dateToTimeInterval = date.timeIntervalSince1970
            let dateString = String(dateToTimeInterval)
            let doublString = Double(dateString)!
            let intDateString = Int(doublString)
            startDateMillie = String(intDateString)

        }
        
        let endDateString = ref.extendDateTo
    //   dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: endDateString) {
          let dateToTimeInterval = date.timeIntervalSince1970
            let dateString = String(dateToTimeInterval)
            let doublString = Double(dateString)!
            let intDateString = Int(doublString)
            endDateMillie = String(intDateString)

        }
        txtExtendedFromDate.text = ajDateFormat(string: ref.extendDateFrom)
        txtExtendedToDate.text = ajDateFormat(string: ref.extendDateTo)
        

        
    }
    
    //MARK: Button Actions
    
    @IBAction func btnBack_action(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddTo_action(_ sender: UIButton) {
        
        handleTap()

    }
    
    //MARK: Btn Update
    @IBAction func btnUpdate_action(_ sender: Any) {
        let vc = ConfirmViewController()
        vc.show()
        vc.confirmHeadingLabel.text = "Update Extension of Time"
        vc.confirmDescriptionLabel.text = "Do you want to update the Extension of Time?"
        vc.callback = {
            let ref = self.objEditEOTViewModel
            print(self.txtTitle.text ?? "")
            print(self.txtReasonForDelay.text ?? "")
            print(self.txtNumberOfDays.text ?? "")
            print(self.startDateMillie ?? "")
            print(self.endDateMillie ?? "")
            ref.updateEOT(name: self.txtTitle.text ?? "", reasonForDelay: self.txtReasonForDelay.text ?? "", eotId: self.eotId ?? 0, numberOfDays: self.txtNumberOfDays.text ?? "", extendDateFrom: self.startDateMillie ?? "", extendDateTo: self.endDateMillie ?? "") { sucess, eror, type in
                if sucess {
                    self.navigationController?.popViewController(animated: true)
                    self.showToast(message: "EOT updated successfully", font: .boldSystemFont(ofSize: 14.0))

                } else {
                    self.showAlert(message: eror)
                }
            }
            
//            ref.updatePunch(name: self.txtTitle.text ?? "", infoNeeded: self.txtReasonForDelay.text ?? "", file: self.arrayOfAddedVariationsURL, punchId: self.variationId ?? 0, checklist: self.checkList) { success, eror, type in
//                if success {
//                    self.navigationController?.popViewController(animated: true)
//                    self.showToast(message: "Punch updated successfully", font: .boldSystemFont(ofSize: 14.0))
//
//                } else {
//                    self.showAlert(message: eror)
//                }
//            }
            
          
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

extension EOTEditVC: UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        return CGSize(width: 0.1, height: 0.1)
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
            chipView.setBackgroundColor(UIColor.lightGray, for: .normal)
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
        //MARK: txtExtendedFromDate

        if textField == txtExtendedFromDate {
            txtExtendedFromDate.inputView = datePicker
            if txtExtendedFromDate.text == "" {
                dateChanged(datePicker)
            }
            
                datePicker.backgroundColor = UIColor.white
                datePicker.autoresizingMask = .flexibleWidth
                datePicker.datePickerMode = .date

            datePicker.preferredDatePickerStyle = .wheels
                datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
            datePicker.backgroundColor = .clear


            print(txtExtendedFromDate.frame)
            print(txtExtendedFromDate.top)

//                self.view.addSubview(datePicker)
                        
//                toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
//                toolBar.barStyle = .blackTranslucent
//                toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
//                toolBar.sizeToFit()
//                self.view.addSubview(toolBar)
        }
        
       
        
        if txtExtendedFromDate != nil{
            
            txtExtendedToDate.isEnabled = true
        }else{
            txtExtendedToDate.isEnabled = false
        }
          
        
        //MARK: txtExtendedToDate
        if textField == txtExtendedToDate{
            txtExtendedToDate.inputView = endDatePicker
            if txtExtendedToDate.text == "" {
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {

    }
    
    
    @objc func endDateChanged(_ sender: UIDatePicker?) {
        
        let enddateFormatter = DateFormatter()
        let endnewFormat = DateFormatter()
        enddateFormatter.dateStyle = .short
        enddateFormatter.timeStyle = .none
            
        if let endDate = sender?.date{
            print("Picked the endDate \(enddateFormatter.string(from: endDate))")
            txtExtendedToDate.text = "\(enddateFormatter.string(from: endDate))"
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
        
            print("Picked the endDate \(dateFormatter.string(from: date))")
            txtExtendedFromDate.text = "\(dateFormatter.string(from: date))"
            let timeInterval = date.timeIntervalSince1970
            dateFormatter.dateFormat = "\(Int(timeInterval))"
            startDateMillie = dateFormatter.dateFormat
            print(startDateMillie)
            print(endDateMillie)
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
