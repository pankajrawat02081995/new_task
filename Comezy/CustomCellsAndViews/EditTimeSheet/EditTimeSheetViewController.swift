//
//  EditTimeSheetViewController.swift
//  Comezy
//
//  Created by amandeepsingh on 15/07/22.
//

import UIKit

class EditTimeSheetViewController: UIViewController {
    //MARK: - Variables
    var callback: (() -> Void)?
    @IBOutlet var backgroundView: UIView!
    var updatedStartTime:String?
    var updatedFinishTime:String?
    var createdDate:String?
    var startDate:Date?
    var FinishDate:Date?
    var startTime:Int?
    var finishTime:Int?
    @IBOutlet weak var StartTimePicker: UIDatePicker!
    @IBOutlet weak var finishTimePicker: UIDatePicker!
    
    //MARK: - Life Cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        //StartTimePicker.datePickerMode = .time
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        backgroundView.addGestureRecognizer(tap)
        print("Start Time1------------------>\(self.startDate)")
        print(" Finish Time1------------------>\(self.FinishDate)")
        StartTimePicker.setDate(self.startDate!, animated: false)
        finishTimePicker.setDate(self.FinishDate!, animated: false)
        self.startTime = Int(self.startDate!.millisecondsSince1970)
        self.finishTime = Int(self.FinishDate!.millisecondsSince1970)



        // Do any additional setup after loading the view.
    }
//    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
//        
//        self.dismiss(animated: true, completion: nil)
//    }
//    
    
    //MARK: - On Click Action Method
    @IBAction func btnOkClick(_ sender: UIButton) {
    
        if(Int(self.startDate?.millisecondsSince1970 ?? 0) > Int(self.FinishDate?.millisecondsSince1970 ?? 0)){
            showToast(message: "Timesheet can not finish before start time")
        }
        else{
            callback?()

        }


       // }

    }
    
    @IBAction func startTimeChange(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        let newFormat = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let timeInterval = sender.date.timeIntervalSince1970
        //startTime = Int(timeInterval)
        startDate = sender.date
        print(sender.date)
    }
    
   
    @IBAction func finishTimeChange(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        let newFormat = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let timeInterval = sender.date.timeIntervalSince1970
        FinishDate = sender.date
        print(sender.date)
 
    }
    @IBAction func btnCancelClick(_ sender: UIButton) {

        self.dismiss(animated: true, completion: nil)
        

    }
    
    //MARK: - Show method for back to root controller
    func show() {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
    }

}
