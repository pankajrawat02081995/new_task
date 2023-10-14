//
//  ScheduleTimelineVC.swift
//  Comezy
//
//  Created by aakarshit on 10/08/22.
//

import Foundation
import UIKit
import FSCalendar
//import KVKCalendar

class ScheduleTimelineVC: UIViewController {
    var scheduleVM = ScheduleViewModel()
    var myList = [Schedule]()
    var projectId: Int?
    var dateFormatter = DateFormatter()
    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        print("My List", myList)
        calendar.dataSource = self
        calendar.delegate = self
        calendar.scrollDirection = .horizontal
        calendar.appearance.titleOffset = CGPoint(x: 0, y: 0)
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
//        calendar.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let currentMonth = calendar.currentPage
        let components = NSCalendar.current.dateComponents([.day,.month,.year],from:currentMonth)
        if let day = components.day, let month = components.month, let year = components.year {
            let monthString = "\(month)"
            print(monthString)
            self.scheduleVM.getScheduleTasksList(size: "1000", page: 1, project_id: projectId ?? 0, month: "", date: "") { success, resp, errorMsg in
                if success {
                    self.myList = resp?.results.schedule ?? []
//                    self.showNoItems()
//                    self.getEvents()
                    self.getAllDatesForAllTasks()
                    
                    let dateFormatter = DateFormatter();
                    dateFormatter.dateFormat = "yyyy-MM-dd"
//                    dateFormatter.date(from: String)?.millisecondsSince1970
//                    print("date 0 index", dateFormatter.date(from: self.myList[0].allDates![0])!.millisecondsSince1970)
                    
//                    self.myList.sorted(by: $0.results.schedule.allDates![0] > $1.results.schedule.allDates![0])
                    self.myList = self.myList.sorted { a,b in
                        dateFormatter.date(from: a.allDates![0])!.millisecondsSince1970 < dateFormatter.date(from: b.allDates![0])!.millisecondsSince1970
                    }
                    
                    print("My list ->", self.myList)
                    self.calendar.reloadData()
                    
                } else {
                    self.showToast(message: errorMsg ?? "Error occured!")
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        calendar.reloadData()
    }
    
    
    //MARK: Date Functions
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
    
    func dateStrFromyyyMMdd(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func getDateObj(string: String) -> Date {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: string)!
        return date
    }
    
    func getAllDatesForAllTasks() {
        for (index,i) in myList.enumerated() {
            let startDateObj = getDateObj(string: i.startDate ?? "")
            let endDateObj = getDateObj(string: i.endDate ?? "")
            let allDates = Date.dates(from: startDateObj, to: endDateObj)
            let strAllDates = allDates.compactMap { date in
                return dateStrFromyyyMMdd(date: date)
            }
            myList[index].allDates = strAllDates
        }
    }
 
    @IBAction func btnBack_action(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnHome_action(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

//MARK: FSCalendar
extension ScheduleTimelineVC: FSCalendarDataSource, FSCalendarDelegate {
    
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendar.reloadData()
    }
    
//    func myListSorted() {
//        self.myList.sorted { a,b in
//            a.allDates![0] > b.allDates![0]
//        }
//    }
    
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
//        cell.titleLabel.font = .systemFont(ofSize: 25, weight: .heavy)
        cell.titleLabel.isHidden = true
//        cell.border(width: 1, color: .black)
//        cell.titleLabel.border(width: 1, color: .systemOrange)
        let dateString = self.dateFormatter2.string(from: date)
//        var newLabel:UILabel = {
//           let label = UILabel()
//            label.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//            label.textColor = .white
//            label.font = UIFont.boldSystemFont(ofSize: 12)
//            label.text = String(date.kvkDay)
//            return label
//        }()
        
        let customDateLabel = CustomDateLabel(frame: CGRect(x: 5, y: 0, width: 25, height: 25))
        customDateLabel.text = String(date.kvkDay)
        if date == self.calendar.today {
            customDateLabel.textColor = App.Colors.appGreenColor
            customDateLabel.font = UIFont.systemFont(ofSize: 18, weight: .heavy)

        } else {
            customDateLabel.textColor = cell.titleLabel.textColor
            customDateLabel.font = UIFont.boldSystemFont(ofSize: 18)
        }
        
//        print("Todays Month         ->", self.calendar.today?.kvkMonth)
//        print("Delegate Month ->", date.kvkMonth)
        for subview in cell.subviews {
            
            if subview.className == "TimelineLabel" || subview.className == "CustomDateLabel"{
                subview.removeFromSuperview()
            }
            
        }
        
        cell.addSubview(customDateLabel)
        
        
        
        
        
        
        var dateYOffsets: [String:Int] = [String:Int]()
        var dateColors:[Int:UIColor] = [
            0: .systemRed.withAlphaComponent(0.8),
            1: .systemBlue.withAlphaComponent(0.8),
            2: .systemYellow.withAlphaComponent(0.8)
        ];
        
        var emptyRowIndexes = [Int]()

        for (taskIndex, task) in myList.enumerated() {
            guard let safeDates = task.allDates else {
                print("Error guarding alldates")
                return
            }
            
//            var tastyOffset = 1;
            
            let startDate = safeDates[0]
            let endDate = safeDates[safeDates.count - 1];
//            if (dateYOffsets[startDate] == nil) {
//                dateYOffsets[startDate] = 0;
//            } else {
//                dateYOffsets[startDate] = dateYOffsets[startDate]! + 11;
//            }
            
            for (dIndex,d) in safeDates.enumerated() {
                
                
                if (dateYOffsets[d] == nil) {
                    //  adding new values if the date has not been assigned once in the dateYOffsets dictionary
                    dateYOffsets[d] = 0;
                } else {
                    
                    // adding new values if the date has been assigned once in the dateYOffsets dictionary
                    if (emptyRowIndexes.count > 0) {
                        dateYOffsets[d] = emptyRowIndexes[0];
                        
                        emptyRowIndexes.removeFirst();
                        
                    } else {
                        dateYOffsets[d] = dateYOffsets[d]! + 11;
                    }
                }
                
                if (dIndex > 0 && dateYOffsets[d] != dateYOffsets[safeDates[dIndex - 1]] ) {
                    dateYOffsets[d] = dateYOffsets[safeDates[dIndex - 1]];
                }
                
//                if (d == endDate && emptyRowIndexes.contains(dateYOffsets[d]!) == false
//                ) {
//                    print(endDate, task.taskName, "end date inside the condition");
//                    emptyRowIndexes.append(dateYOffsets[d]!);
//                    emptyRowIndexes.sort();
//                }
                
                
                if d == dateString {
                    
                    let labelMy2 = TimelineLabel(frame: CGRect(x: 0, y: cell.titleLabel.top + CGFloat(23) + CGFloat(dateYOffsets[d]!), width: cell.bounds.width, height: 10))
                    labelMy2.font = .systemFont(ofSize: 8, weight: .heavy)
                    
                    labelMy2.text = d == startDate ? task.taskName : "";
                    if let intRGB = Int(task.color ?? "") {
                        labelMy2.backgroundColor = UIColor(hex: task.color ?? "")?.withAlphaComponent(0.8)
                    } else {
                        labelMy2.backgroundColor = dateColors[taskIndex % 3]
                    }
                    labelMy2.textColor = .white
                    if d == startDate {
                        labelMy2.roundCorners([.topLeft, .bottomLeft], radius: 4.0)
                        
                    }
                    
                    if d == endDate {
                        labelMy2.roundCorners([.topRight, .bottomRight], radius: 4.0)
                    }
                    if date.isSunday {
                        labelMy2.text = task.taskName
                    }
                
//                    if d == startDate {
//                        labelMy2.frame = CGRect(x: 0, y: cell.titleLabel.top + CGFloat(dateYOffsets[d]!), width: cell.bounds.width * 2, height: 10)
//                        cell.bringSubviewToFront(labelMy2)
//                    }
                    cell.addSubview(labelMy2)
                    continue
                }
                
                
            }
        }
        
//        if dateString == "2022-08-02" {
//            let labelMy2 = AJCell(frame: CGRect(x: 10, y: cell.titleLabel.bottom, width: cell.bounds.width, height: 20))
//            labelMy2.font = .systemFont(ofSize: 15, weight: .regular)
//            labelMy2.tag = 23
//            labelMy2.text = "abc"
//            labelMy2.backgroundColor = .systemTeal
//            labelMy2.textColor = .white
//            cell.addSubview(labelMy2)
//        }
//
//        if dateString == "2022-08-03" {
//            let labelMy2 = AJCell(frame: CGRect(x: 10, y: cell.titleLabel.bottom, width: cell.bounds.width, height: 20))
//            labelMy2.font = .systemFont(ofSize: 15, weight: .regular)
//            labelMy2.text = ""
//            labelMy2.tag = 23
//            labelMy2.backgroundColor = .systemTeal
//            labelMy2.textColor = .white
//            cell.addSubview(labelMy2)
//
//        }
//        if dateString == "2022-08-02" {
//            let labelMy2 = AJCell(frame: CGRect(x: 10, y: cell.titleLabel.bottom - 20, width: cell.bounds.width, height: 20))
//            labelMy2.font = .systemFont(ofSize: 15, weight: .regular)
//            labelMy2.text = "Holy"
//            labelMy2.backgroundColor = .systemPink
//            labelMy2.textColor = .white
//            labelMy2.tag = 23
//            cell.addSubview(labelMy2)
//
//        }



    }
    
    
}

class TimelineLabel: UILabel {
}
class CustomDateLabel: UILabel {
}


