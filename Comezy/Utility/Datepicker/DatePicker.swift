//
//  DatePicker.swift
//  SoundTide
//
//  Created by archie on 05/04/21.
//

import Foundation
import UIKit

open class DatePicker: NSObject {
    private let datePicker: UIDatePicker
    private weak var presentationController: UIViewController?
    private weak var textfield: UITextField?
    
    public init(presentationController: UIViewController, textfield: UITextField) {
        self.datePicker = UIDatePicker()
        super.init()
        self.presentationController = presentationController
        self.textfield = textfield
        self.showDatePicker()
    }
    
    private func pickerController(_ controller: UIImagePickerController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func showDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            
        }
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        self.textfield!.inputAccessoryView = toolbar
        self.textfield?.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd, yyyy"
        self.textfield!.text = formatter.string(from: datePicker.date)
        self.presentationController?.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.presentationController?.view.endEditing(true)
     }
    
}
