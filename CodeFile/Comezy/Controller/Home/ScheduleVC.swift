//
//  ScheduleVC.swift
//  Comezy
//
//  Created by amandeepsingh on 08/08/22.
//

import UIKit

import 	FSCalendar

class ScheduleVC: UIViewController{
    
    var projectId: Int?
    var scheduleVM = ScheduleViewModel()
    var myList = [Schedule]()
    var dateFormatter = DateFormatter()
    var allList = [Schedule]()
    @IBOutlet weak var noEventsLabel: UILabel!
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    var callback: (()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 20)
        tableView.register(UINib(nibName: "ScheduledTaskCell", bundle: nil), forCellReuseIdentifier: "ScheduledTaskCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let obj = NotificationsViewModel.shared
        obj.clearBadgeCount(projectId: projectId ?? 0, module: "schedule") { success, resp, errorMsg in
            if success {
                print("Notification count cleared")
            }
        }
    }

    
    var datesWithEvent = [String]()

    var datesWithMultipleEvents = [String]()

    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    @IBAction func btnCalendar_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .schedule, controller: ScheduleTimelineVC()) as! ScheduleTimelineVC
        vc.projectId = projectId
        navigationController?.pushViewController(vc, animated: true)
    }
    func showNoItems() {
        if myList.count == 0 {
            tableView.isHidden = true
            noEventsLabel.isHidden = false
        } else {
            tableView.isHidden = false
            noEventsLabel.isHidden = true
        }
    }
    
    func getEvents() {
        datesWithEvent = []
        datesWithMultipleEvents = []
        
//        myList = [Schedule(id: 1, taskName: "hello", startDate: "2022-12-28 00:00:00", endDate: "2023-01-05 00:00:00", scheduleDescription: "hello description", color: "#fffff", documents: [], project: Project(), worker_action: "pending", complete_status: "pending"),Schedule(id: 2, taskName: "hello1", startDate: "2023-01-02 00:00:00", endDate: "2023-01-09 00:00:00", scheduleDescription: "hello1 description", color: "#fffff", documents: [], project: Project(), worker_action: "pending", complete_status: "pending"),Schedule(id: 3, taskName: "hello3", startDate: "2023-01-05 00:00:00", endDate: "2023-01-20 00:00:00", scheduleDescription: "hello3 description", color: "#fffff", documents: [], project: Project(), worker_action: "pending", complete_status: "pending"),Schedule(id: 4, taskName: "hello4", startDate: "2023-01-25 00:00:00", endDate: "2023-01-26 00:00:00", scheduleDescription: "hello4 description", color: "#fffff", documents: [], project: Project(), worker_action: "pending", complete_status: "pending"),Schedule(id: 5, taskName: "hello5", startDate: "2023-01-25 00:00:00", endDate: "2023-01-26 00:00:00", scheduleDescription: "hello5 description", color: "#fffff", documents: [], project: Project(), worker_action: "pending", complete_status: "pending")]
            for i in myList {

                var start = DateFromStringDate(inputFormat: "yyyy-MM-dd HH:mm:ss", date: i.startDate!).millisecondsSince1970
                var end = DateFromStringDate(inputFormat: "yyyy-MM-dd HH:mm:ss", date: i.endDate!).millisecondsSince1970
//        var start:Int64 = 1672165800000
//        var end:Int64 = 1673025236023

                
        for date in stride(from: start, to: end+86400000, by: 86400000) {
                    Date(milliseconds: date)
                    getFormattedDate(dateFormatt: "yyyy-MM-dd", date: Date(milliseconds: date))
                    print(getFormattedDate(dateFormatt: "yyyy-MM-dd", date: Date(milliseconds: date)))
              
                    let formattedDate = getFormattedDate(dateFormatt: "yyyy-MM-dd", date: Date(milliseconds: date))

                    if datesWithEvent.contains(formattedDate) {
                        datesWithMultipleEvents.append(formattedDate)
                    } else {
                        datesWithEvent.append(formattedDate)
                    }
                }
            
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let currentMonth = calendar.currentPage
        let components = NSCalendar.current.dateComponents([.day,.month,.year],from:currentMonth)
        if let month = components.month {
//            let dayString = "\(day)"
            let monthString = "\(month)"
//            let yearString = "\(year)"
            print(monthString)
            
            scheduleVM.getScheduleTasksList(size: "1000", page: 1, project_id: projectId ?? 0, month: "", date: "") { success, resp, errorMsg in
                self.allList = resp?.results.schedule ?? []
            }
            scheduleVM.getScheduleTasksList(size: "1000", page: 1, project_id: projectId ?? 0, month: monthString, date: "") { success, resp, errorMsg in
                if success {
                    self.myList = resp?.results.schedule ?? []
                    self.showNoItems()
                    self.getEvents()
                    self.callback = {
                        //self.getEvents()

                        print("Called after get events")
                    }
                    print("DatesWithEvent->", self.datesWithEvent)
                    self.calendar.reloadData()
                    self.tableView.reloadData()
                    
                } else {
                    self.showToast(message: errorMsg ?? "Error occured!")
                }
            }
        }
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
    
    func yyyMMddDateFrom(string: String) -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    
    @IBAction func btnBack_action(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: Calendar Delegates
extension ScheduleVC: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let str = dateFormatter.string(from: date)
        scheduleVM.getScheduleTasksList(size: "1000", page: 1, project_id: projectId ?? 0, month: "", date: str) { success, resp, errorMsg in
            self.myList = resp?.results.schedule ?? []
            self.showNoItems()
            self.tableView.reloadData()
        }

        print("Formatted Date ->", str)
        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        callback?()
        let dateString = self.dateFormatter2.string(from: date)
        print("No. of events for date:->", dateString)
        print(dateString, datesWithMultipleEvents, datesWithEvent)
        if self.datesWithMultipleEvents.contains(dateString) {
            var counts: [String: Int] = [:]

            self.datesWithMultipleEvents.forEach {
                counts[$0, default: 1] += 1
                
            }

           // print("DATATATAT",counts[dateString])
            return counts[dateString]!
            //return 3
        }
        
        if self.datesWithEvent.contains(dateString) {
            print("Contains single event:->", dateString)
            return 1
        }
        return 0
    }

    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentMonth = calendar.currentPage
        let components = NSCalendar.current.dateComponents([.day,.month,.year],from:currentMonth)
        if let month = components.month {
//            let dayString = "\(day)"
            let monthString = "\(month)"
//            let yearString = "\(year)"
            print(monthString)
//            
            scheduleVM.getScheduleTasksList(size: "1000", page: 1, project_id: projectId ?? 0, month: "", date: "") { success, resp, errorMsg in
                if success {
                    self.myList = resp?.results.schedule ?? []
                    self.getEvents()
                    self.showNoItems()
                    self.calendar.reloadData()
                    self.tableView.reloadData()
                } else {
                    self.showToast(message: errorMsg ?? "An Error Occured!")
                }

            }
            
       }
    }
}

//MARK: TableView Delegates
extension ScheduleVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduledTaskCell", for: indexPath) as! ScheduledTaskCell
//        let currentMonth = calendar.currentPage
        let item = myList[indexPath.row]
        let startDate = ajDateFormat(string: item.startDate ?? "")
        let endDate = ajDateFormat(string: item.endDate ?? "")
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy'-'MM'-'dd HH':'mm':'ss"
        let startDateObj = dateFormat.date(from: item.startDate ?? "") ?? Date()
        let components = NSCalendar.current.dateComponents([.day,.month,.year],from:startDateObj)
        
        if let day = components.day, let month = components.month {
            let dayString = "\(day)"
            let monthString = "\(month)"
//            let yearString = "\(year)"
            print(monthString)
            cell.btnTodayDate.setTitle(dayString, for: .normal)
        }
        
        cell.lblDay.text = startDateObj.dayOfWeek()?.first(char: 3)
        cell.lblStartDate.text = startDate
        cell.lblEndDate.text = endDate
        cell.lblTaskName.text = item.taskName
        
        
        return cell
    }
    
    
}


