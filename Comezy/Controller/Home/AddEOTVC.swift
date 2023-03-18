//
//  AddEOTVC.swift
//  Comezy
//
//  Created by aakarshit on 23/06/22.
//

import UIKit
import MobileCoreServices
import MaterialComponents.MaterialChips
import MaterialComponents

class AddEOTVC: UIViewController {
    
    let objAddEOTViewModel = AddEOTViewModel()
    let objPeopleListViewModel = PeopleListViewModel.shared
    var fileSize : UInt64 = 0
    var fileName = ""
    var ProjectId: Int?
    var selectedIndex: Int?
    var selectedReceiverIdArray: [SelectedReceiver]?
    var toolBar = UIToolbar()
    
    var datePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    var setEndDate = Date()
    var startDateMillie : String?
    var endDateMillie : String?
    
    
    
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var txtInfoNeeded: UITextView!
    @IBOutlet weak var fromStackView: UIStackView!
    
    @IBOutlet weak var btnAddReceiver: UIButton!
    @IBOutlet weak var receiverCollectionView: ReceiverCollectionView!
    @IBOutlet weak var txtReasonForDelay: UITextView!
    @IBOutlet weak var txtNumberOfDays: UITextField!
    @IBOutlet weak var txtExtendedFromDate: UITextField!
    @IBOutlet weak var txtExtendedToDate: UITextField!
    
    var selectedFile = ""
    var selectedFromPersonId: Int?
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        txtFrom.isUserInteractionEnabled = false
        txtFrom.isEnabled = false
        
        txtExtendedFromDate.delegate = self
        txtExtendedToDate.delegate = self
        
        receiverCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
        let layout = MDCChipCollectionViewFlowLayout()
        receiverCollectionView.collectionViewLayout = layout
        
        print("View Did Load")
        print(ProjectId)
        initailLoad()
        txtFrom.delegate = self
        
        
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
    @IBAction func
    btnAddTo(_ sender: UIButton) {
        handleTap()
    }
    
    @IBAction func btnHome_action(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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
        
        self.objAddEOTViewModel.addEOT(name: txtName.text ?? "", sender: selectedFromPersonId ?? 0, reasonForDelay: txtReasonForDelay.text ?? "", project: ProjectId ?? 0, receiver: receiverIdArray, numberOfDays: txtNumberOfDays.text ?? "" , extendDateFrom: startDateMillie ?? "", extendDateTo: endDateMillie ?? "") { success, eror, type in
            if success {
                self.navigationController?.popViewController(animated: true)
                
                self.showToast(message: "Extension of time added successfully", font: .boldSystemFont(ofSize: 14.0))
                
            } else {
                self.showAlert(message: eror)
            }
        }
    }
    
    //MARK: Initial Load
    func initailLoad(){
        //           toBackgroundView?.layer.cornerRadius = 4
        self.btnDone.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        self.btnDone.clipsToBounds = true
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension AddEOTVC: UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let a = collectionView as? ReceiverCollectionView {
            return selectedReceiverIdArray?.count ?? 0
        }
        //        print(arrayOfAddedVariations.count, "@#$!@#!@#$!@#$!@#$!@# C O L L E C T I O N V I E W $!@#$!@#$!@#$!@#$")
        //
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // dataArary is the managing array for your UICollectionView.
        if let a = collectionView as? ReceiverCollectionView {
            let item = selectedReceiverIdArray?[indexPath.row].person.firstName ?? "Hello"
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
            chipView.titleLabel.text = selectedReceiverIdArray?[indexPath.row].person.firstName
            chipView.setBackgroundColor( .systemGreen, for: .normal)
            chipView.titleLabel.textColor = .white
            print(chipView.frame, "@#$!@#!@#$! I N T R I N S I C@#$!@#$!@# ")
            
            cell.isUserInteractionEnabled = false
            // configure the chipView to be an action chip
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddVariationDocCell", for: indexPath) as! AddVariationDocCell
            //            let item = arrayOfAddedVariations[indexPath.row]
            //            print("AddedFileCell  .. ", item)
            //            cell.VariationFileLabel.text = item
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
            endnewFormat.dateFormat = "\(Int(timeInterval) * Constants.thousand)"
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
            txtExtendedFromDate.text = "\(dateFormatter.string(from: date))"
            setEndDate = date
            let timeInterval = date.timeIntervalSince1970
            newFormat.dateFormat = "\(Int(timeInterval) * Constants.thousand)"
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
