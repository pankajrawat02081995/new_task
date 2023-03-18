//
//  TimeSheetVC.swift
//  Comezy
//
//  Created by shiphul on 28/12/21.
//

import UIKit

class TimeSheetVC: UIViewController {
    //MARK: - Variables
    var ProjectId: Int?
    var taskId: Int?
    var loggedInUserOcc:String?
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnStartIn: UIButton!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnFinishOut: UIButton!
    @IBOutlet weak var lblShowDate: UILabel!
    @IBOutlet weak var tblTimesheet: UITableView!
    @IBOutlet weak var lblNoTimeSheet: UILabel!
    @IBOutlet weak var startFinishBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var lblEditHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var lblEdit: UILabel!
    @IBOutlet weak var listTop: UIStackView!
    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    var myTimesheetList = [TimesheetListModelResult]()
    var objTimeSheetViewModel = TimesheetViewModel()
 
    //MARK: - LifeCylce Method
    override func viewDidLoad() {
        super.viewDidLoad()
        getTimesheetStatus()
       configureTableView()
        print(NSDate())
        getTimesheetList(date: getFormattedDate(dateFormatt: DateTimeFormat.kTimeSheetDateFormat, date: Date()))
        lblShowDate.text = getFormattedDate(dateFormatt: DateTimeFormat.kTimeSheetDateFormat, date: Date())
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loggedInUserOcc = UserDefaults.getString(forKey: UserDefaultConst.userOccupation)
        lblLocation.text = UserDefaults.getString(forKey: UserDefaultConst.location)
        if loggedInUserOcc == UserType.kOwner {
            self.startFinishBtnHeight.constant=0

        }
        else if loggedInUserOcc == UserType.kClient{
            self.startFinishBtnHeight.constant=0
          self.lblEditHeightConstaint.constant=0


        }else {
            self.startFinishBtnHeight.constant=167
         self.lblEditHeightConstaint.constant=0
            listTop.distribution = .equalSpacing



        }
    }
  

    //MARK: - On Click Action Method
    @IBAction func btnSeeAll(_ sender: UIButton) {
        getTimesheetList(date: "")
        lblShowDate.text = "Select Date"
    }
    //MARK: - On Back btn Action Method
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - On Home btn Action Method

    @IBAction func btnHome_action(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    //MARK: - On Start btn Action Method

    @IBAction func startTimesheet_action(_ sender: Any) {
        self.objTimeSheetViewModel.getStartTimesheet(task_id: taskId ?? 0, project_id: ProjectId ?? 0) { (success) in
            if success {
                self.objTimeSheetViewModel.startTimesheetDetail?.project = self.ProjectId!
                self.enableFinishButton()

                //self.objTimeSheetViewModel.startTimesheetDetail?.task = self.taskId
                
            }else {
                print("error")
            }
        }
    }
    //MARK: - On end btn Action Method

    @IBAction func endTimesheet_action(_ sender: Any) {
        self.objTimeSheetViewModel.getEndTimesheet(task_id: taskId ?? 0, project_id: ProjectId ?? 0) { (success) in
            if success {
                self.objTimeSheetViewModel.endTimesheetDetail?.project = self.ProjectId!
               // self.objTimeSheetViewModel.endTimesheetDetail?.task = self.taskId
                self.enableStartButton()
                self.getTimesheetList(date: getFormattedDate(dateFormatt: DateTimeFormat.kTimeSheetDateFormat, date: Date()))



                
            }else {
                self.showToast(message: FailureMessage.kErrorOccured)
            }
        }
    }
    
    //MARK: - On Date btn Action Method
    @IBAction func btnDatePicker_action(_ sender: Any) {
        datePicker = UIDatePicker.init()
            datePicker.backgroundColor = UIColor.white
                    
            datePicker.autoresizingMask = .flexibleWidth
        datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
            datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            self.view.addSubview(datePicker)
                    
            toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
            toolBar.barStyle = .blackTranslucent
            toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
            toolBar.sizeToFit()
            self.view.addSubview(toolBar)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
        if let date = sender?.date {
            print("Picked the date \(getFormattedDate(dateFormatt: DateTimeFormat.kTimeSheetDateFormat, date: date))")
            lblShowDate.text = "\(getFormattedDate(dateFormatt: DateTimeFormat.kTimeSheetDateFormat, date: date))"
            print(getFormattedDate(dateFormatt: DateTimeFormat.kTimeSheetDateFormat, date: date))
            getTimesheetList(date: getFormattedDate(dateFormatt: DateTimeFormat.kTimeSheetDateFormat, date: date))
            
        }
    }

    @objc func onDoneButtonClick() {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
    }
    
    //MARK: - User Defined Functions
    //Method to get Time Sheet Status
    func getTimesheetStatus() {
        self.objTimeSheetViewModel.getTimesheetStatus(project_id: ProjectId!){ (success) in
                if success {
                    if self.objTimeSheetViewModel.timesheetStatusDetail?.timesheet_status == "false"{
                        self.enableStartButton()
                    }else{
                        self.enableFinishButton()
                    }
                }else {
                    self.showToast(message: FailureMessage.kErrorOccured)
                }
            }
        }
    
    //Method to Get Timesheet List
    func getTimesheetList(date:String){
        self.objTimeSheetViewModel.getTimesheetList(project_id: ProjectId ?? 0,date_added: date){ (success, timesheetList, error) in
            if success {
                self.myTimesheetList = timesheetList ?? []
                self.NoTimesheet()

                DispatchQueue.main.async {
                    self.tblTimesheet.reloadData()
                }
            }else {
                self.showToast(message: FailureMessage.kErrorOccured)
            }
        }
    }
    
    //Method to Show/Hide empty text message
    func NoTimesheet(){
        if myTimesheetList.count == 0{
            lblNoTimeSheet.isHidden = false
            tblTimesheet.isHidden = true
        }else{
            lblNoTimeSheet.isHidden = true
            tblTimesheet.isHidden = false
        }
    }
    
    //Method to Configure Table View
    func configureTableView() {
        tblTimesheet.delegate = self
        tblTimesheet.dataSource = self
        tblTimesheet.register(UINib(nibName: StoryBoardIdentifier.kTimeSheetCellController, bundle: nil), forCellReuseIdentifier: StoryBoardIdentifier.kTimeSheetCellController)
    }
    
    //Method to Enable Start Button
    func enableStartButton(){

        self.btnFinishOut.backgroundColor = UIColor.init(red: 211, green: 211, blue: 211)
        self.btnStartIn.backgroundColor = UIColor.init(red: 32, green: 208, blue: 179)
        self.btnFinishOut.isEnabled=false
        self.btnStartIn.isEnabled=true
        getTimesheetList(date: getFormattedDate(dateFormatt: DateTimeFormat.kTimeSheetDateFormat, date: Date()))
        lblShowDate.text = getFormattedDate(dateFormatt: DateTimeFormat.kTimeSheetDateFormat, date: Date())

    }
    
    //Method To Enable Finish Button
    func enableFinishButton(){

        self.btnStartIn.backgroundColor = UIColor.init(red: 211, green: 211, blue: 211)
        self.btnFinishOut.backgroundColor =  UIColor.init(red: 29, green: 205, blue: 254)
        self.btnStartIn.isEnabled=false
        self.btnFinishOut.isEnabled=true
    }
    
  
}



//MARK: - Extension TimeSheetVC
extension TimeSheetVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objTimeSheetViewModel.timesheetListDataDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblTimesheet.dequeueReusableCell(withIdentifier: StoryBoardIdentifier.kTimeSheetCellController, for: indexPath) as! TimesheetCell

        if loggedInUserOcc == UserType.kOwner {
            cell.editButtonHeight.constant=73

        } else {
            cell.editButtonHeight.constant=0

        }
        cell.item = objTimeSheetViewModel.timesheetListDataDetail[indexPath.row]
        cell.editImageCallback = {
            let vc = EditTimeSheetViewController()
            vc.startDate = DateFromStringDate(inputFormat: DateTimeFormat.kTimeSheetDateTimeFormat, date: (cell.item?.startTime)!)
            vc.FinishDate = DateFromStringDate(inputFormat:  DateTimeFormat.kTimeSheetDateTimeFormat, date: (cell.item?.endTime)!)
            vc.show()
            vc.callback = {
                self.objTimeSheetViewModel.updateTimesheet(timesheet_id: (cell.item?.id)!, startTime: getFormattedDate(dateFormatt:  DateTimeFormat.kTimeSheetDateTimeFormat, date: (vc.startDate)!), EndTime: getFormattedDate(dateFormatt:  DateTimeFormat.kTimeSheetDateTimeFormat, date: (vc.FinishDate)!)) { success, eror, response in
                    if success {
                        self.showToast(message: SuccessMessage.kTimeSheetUpdate, font: .boldSystemFont(ofSize: 14.0))
                        vc.dismiss(animated: true)
                        self.getTimesheetList(date: "")
                    }
                    else{

                    }
                }
                    vc.dismiss(animated: true)
                      }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 47
    }
    
    
}
//MARK: - Function To Get Formatted Date()
func getFormattedDate(dateFormatt:String,date:Date)->String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormatt
    return dateFormatter.string(from: date)
}
//MARK: - Function to get Date From Another Date String

func DateFormatToAnother(inputFormat:String,outputFormat:String, date:String)->String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = inputFormat
    let date1 = dateFormatter.date(from: date ?? "")!
    dateFormatter.dateFormat = outputFormat
    return dateFormatter.string(from: date1)
}
//MARK: - Function to get Date() from String Date

func DateFromStringDate(inputFormat:String,date:String)->Date{
    let dateFormatter = DateFormatter()
   // let tempLocale = dateFormatter.locale // save locale temporarily

    dateFormatter.locale = Locale.autoupdatingCurrent // set locale to reliable US_POSIX
    dateFormatter.dateFormat = inputFormat
    return dateFormatter.date(from: date ?? "")!
    
}

