//
//  FilterVC.swift
//  Comezy
//
//  Created by Lalit Kumar on 06/06/23.
//

import UIKit


protocol InviceFilter{
    func InvoiceFilter(startDate:String,endDate:String)
}

class FilterVC: UIViewController {
    
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    
    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    
    var isStartDate = false
    var delegate : InviceFilter?
    var startDate = ""
    var endDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblEndDate.text = self.endDate.isEmpty == true ? "End Date" : self.endDate
        self.lblStartDate.text = self.startDate.isEmpty == true ? "Start Date" : self.startDate
    }
    
    @IBAction func clearOnFilter(_ sender: UIButton) {
        self.lblEndDate.text = "End Date"
        self.lblStartDate.text = "Start Date"
        self.startDate = ""
        self.endDate = ""
        self.dismiss(animated: true) {
            if let del = self.delegate{
                del.InvoiceFilter(startDate: "", endDate: "")
            }
        }
    }
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        self.dismiss(animated: true){
            if let del = self.delegate{
                del.InvoiceFilter(startDate: self.startDate ?? "", endDate: self.endDate ?? "")
            }
        }
    }
    
    @IBAction func startDateOnPress(_ sender: UIButton) {
        self.onDoneButtonClick()
        self.isStartDate = true
        self.showDatePicker()
    }
    
    @IBAction func endDateOnPress(_ sender: UIButton) {
        self.onDoneButtonClick()
        self.isStartDate = false
        self.showDatePicker()
    }
    
}

extension FilterVC{
    
    func showDatePicker(){
        datePicker = UIDatePicker.init()
        datePicker.backgroundColor = UIColor.white
        
        datePicker.autoresizingMask = .flexibleWidth
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
        datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        datePicker.backgroundColor = .white
        self.view.addSubview(datePicker)
        
        toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.isTranslucent = true
        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
        toolBar.sizeToFit()
        self.view.addSubview(toolBar)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
        if let date = sender?.date {
            if self.isStartDate == true{
                self.startDate = "\(getFormattedDate(dateFormatt: DateTimeFormat.kTimeSheetDateFormat, date: date))"
                lblStartDate.text = "\(getFormattedDate(dateFormatt: DateTimeFormat.kTimeSheetDateFormat, date: date))"
            }else{
                self.endDate = "\(getFormattedDate(dateFormatt: DateTimeFormat.kTimeSheetDateFormat, date: date))"
                lblEndDate.text = "\(getFormattedDate(dateFormatt: DateTimeFormat.kTimeSheetDateFormat, date: date))"
            }
        }
    }
    
    @objc func onDoneButtonClick() {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
    }
}
