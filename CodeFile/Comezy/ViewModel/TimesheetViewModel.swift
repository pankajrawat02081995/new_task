//
//  TimesheetViewModel.swift
//  Comezy
//
//  Created by shiphul on 29/12/21.
//

import UIKit
import Alamofire

class TimesheetViewModel: NSObject {
    var timesheetStatusDetail:TimesheetSatusModel?
    var startTimesheetDetail: StartTimesheetModel?
    var endTimesheetDetail: FinishTimeSheetModel?
    var updatedTimesheet: UpdateTimeSheetModel?
    var timesheetListDataDetail = [TimesheetListModelResult]()
    
    //API for timesheet status
    func getTimesheetStatus(project_id: Int , completionHandler:  @escaping(_ status: Bool) -> Void){
        DispatchQueue.main.async {
            
            APIManager.shared.request(url: API.getTimesheetStatus + "?project_id=" + "\(project_id)" , method: .get,parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { [self] (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let timesheetStatus = try JSONDecoder().decode(BaseResponse<TimesheetSatusModel>.self, from: jsonData)
                        print(timesheetStatus)
                        print(kUserData?.jwt_token)
                       // UserDefaults.standard.string(forKey: kUserDataKey)
                        if timesheetStatus.code == 200 {
                            self.timesheetStatusDetail = timesheetStatus.data.self as! TimesheetSatusModel
                           // print(timesheetStatusDetail, "ftfgghfghftdghcghcgc")
                            completionHandler(true)
                        }else {
                            completionHandler(false)
                        }
                        
                    }
                    catch let err{
                        completionHandler(false)
                    }
                }
            }) { (error) in
                print(error)
                completionHandler(false)
                
            }
        }
    }
    
    //API for start timesheet
    func getStartTimesheet(task_id: Int, project_id: Int , completionHandler:  @escaping(_ status: Bool) -> Void){
        DispatchQueue.main.async {
            
            APIManager.shared.request(url: API.getStartTimesheet + "?project_id=" + "\(project_id)" , method: .get,parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { [self] (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let startTimesheet = try JSONDecoder().decode(BaseResponse<StartTimesheetModel?>.self, from: jsonData)
                        print(startTimesheet)
                        if startTimesheet.code == 200 {
                            self.startTimesheetDetail = startTimesheet.data.self as! StartTimesheetModel
                            print(startTimesheetDetail, "ftfgghfghftdghcghcgc")
                            completionHandler(true)
                        }else {
                            completionHandler(false)
                        }
                        
                    }
                    catch let err{
                        completionHandler(false)
                    }
                }
            }) { (error) in
                print(error)
                completionHandler(false)
                
            }
        }
    }
   
    
    //API for End Timesheet
    func getEndTimesheet(task_id: Int, project_id: Int , completionHandler:  @escaping(_ status: Bool) -> Void){
        DispatchQueue.main.async {
            
            APIManager.shared.request(url: API.getEndTimesheet + "?project_id=" + "\(project_id)" , method: .get,parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { [self] (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let endTimesheet = try JSONDecoder().decode(BaseResponse<FinishTimeSheetModel?>.self, from: jsonData)
                        print(endTimesheet)
                        if endTimesheet.code == 200 {
                            self.endTimesheetDetail = endTimesheet.data.self as! FinishTimeSheetModel
                            print(endTimesheetDetail, "ftfgghfghftdghcghcgc")
                            completionHandler(true)
                        }else {
                            completionHandler(false)
                        }
                        
                    }
                    catch let err{
                        completionHandler(false)
                    }
                }
            }) { (error) in
                print(error)
                completionHandler(false)
                
            }
        }
    }
    
    //API for Timesheet List
    func getTimesheetList(project_id: Int,date_added: String, completionHandler: @escaping(_ status: Bool, _ timesheetList: [TimesheetListModelResult]?, _ errorMsg: String?) -> Void){
        
        DispatchQueue.main.async{

            var url = API.getTimesheetList
            url = url + "?date_added=" + "\(date_added)" + "&page=" + "\(1)" + "&size=" + "\(1000)" + "&project_id=" + "\(project_id)" + "&timezone=" + "\(getCurrentTimezone())"
            
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let timesheetList = try JSONDecoder().decode(TimesheetListModel.self, from: jsonData)
                        print("timesheetList  :", timesheetList)
                        if timesheetList.code == 200 {
                            self.timesheetListDataDetail = timesheetList.data.results
                            completionHandler(true, timesheetList.data.results , "")
                            
                        }else {
                            completionHandler(false,nil,timesheetList.message ?? "")
                        }
                        
                    }
                    catch let err{
                        print("timesheetList  err.localizedDescription:", err.self)
                        completionHandler(false,nil,err.localizedDescription)
                    }
                }
            }) { (error) in
                print("timesheetList  error:", error)
                completionHandler(false,nil,error)
                
            }
        }
    }
    func updateTimesheet(timesheet_id: Int, startTime:String, EndTime:String,completionHandler: @escaping(_ status: Bool, _ updateTimesheetModel: UpdateTimeSheetModel?, _ errorMsg: String?) -> Void){
        
        var parameters = [String : Any]()
//        parameters["start_time"] = startTime
//        parameters["end_time"] = EndTime

        parameters = ["start_time": startTime,"end_time": EndTime]
            
        APIManager.shared.request(url: API.updatedTimeSheet + "id=" + "\(timesheet_id)" + "&timezone=" + "\(getCurrentTimezone())" + "&timezone_id=" + "\(getTimeZoneIdentifier())" ,method: .put,parameters: parameters , encoding: URLEncoding.default ,completionCallback: { (_ ) in
                
            }, success: { [self] (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let response = try JSONDecoder().decode(BaseResponse<UpdateTimeSheetModel>.self, from: jsonData)
                        print(response)
                        if response.code == 200 {
                            completionHandler(true, response.data!, "")
                        } else {
                            completionHandler(false, nil , response.message ?? "")
                        }
                        
                    }
                    catch let err {
                        completionHandler(false,nil,err.localizedDescription ?? "")
                    }
                }
            }) { (error) in
                print("json error", error)
                completionHandler(false,nil,error)
            }
        }
    
    }


func getCurrentTimezone() -> String {
        let localTimeZoneFormatter = DateFormatter()
        localTimeZoneFormatter.dateFormat = "ZZZZ"
        return localTimeZoneFormatter.string(from: Date())

        
    }

func getTimeZoneIdentifier()->String{
    return TimeZone.current.identifier
}
