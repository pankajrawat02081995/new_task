//
//  DailyLogListViewModel.swift
//  Comezy
//
//  Created by shiphul on 23/12/21.
//

import UIKit

class DailyLogListViewModel: NSObject {
    var editDailyLogDataDetail : EditDailyLogModel?
    func getDailyLogList(size: Int, page: Int, project_id: Int, completionHandler: @escaping(_ status: Bool, _ planList: [DailyLogResult]?, _ errorMsg: String?) -> Void){
      
        DispatchQueue.main.async{
            var url = API.getDailyLogList
            url = url + "?size=" + "\(size)" + "&page=" + "\(page)" + "&project_id=" + "\(project_id)"
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let DailyLogList = try JSONDecoder().decode(BaseResponse<DailyLogListModel>.self, from: jsonData)
                        print("DailyLogList  :", DailyLogList)
                        if DailyLogList.code == 200 {
                            completionHandler(true, DailyLogList.data?.results, "")
                            
                        }else {
                            completionHandler(false,nil,DailyLogList.message ?? "")
                        }
                        
                    }
                    catch let err{
                        print("ProjectList  err.localizedDescription:", err.localizedDescription)
                        completionHandler(false,nil,err.localizedDescription)
                    }
                }
            }) { (error) in
                print("ProjectList  error:", error)
                completionHandler(false,nil,error)
                
            }
        }
    }
    
    //Api for AddDailyLogs
    func getAddDailyLog(controller: UIViewController,project:String,location:String,latitude:Double,longitude:Double,documents:[String] ,notes: String, completionHandler: @escaping(_ status: Bool, _ addDailyLog: AddDailyLogModel?, _ errorMsg: String?) -> Void){
        
        var parameters = [String : Any]()
        var address = [String : Any]()
        address = ["name" : location, "longitude" : latitude, "latitude" : longitude]
        parameters = ["location": address, "documents": documents , "notes": notes, "project": project]
      
        print("parameters", parameters)
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.addDailyLog, method: .post,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let addDailyLogData = try JSONDecoder().decode(BaseResponse<AddDailyLogModel>.self, from: jsonData)
                        print(addDailyLogData)
                        if addDailyLogData.code == 200 {
                            completionHandler(true, addDailyLogData.data!, "")
                        }else {
                            completionHandler(false, nil ,addDailyLogData.message ?? "")
                        }
                        
                    }
                    catch let err{
                        completionHandler(false,nil,err.localizedDescription ?? "")
                    }
                }
            }) { (error) in
                print("json error", error)
                completionHandler(false,nil,error)
            }
            
        }
        
    }
    
    //Validation for AddTaskList
    func addDailyLog(controller: UIViewController,project: String,location:String,latitude:Double,longitude:Double,documents:[String] ,notes: String, completionHandler: @escaping(_ sucess:Bool,_ eror:String?,_ type: String?) -> Void){
        if(location.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kLocationEmpty, "")
        }else if (notes.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kNotesEmpty, "")
        }else{
            self.getAddDailyLog(controller: controller, project: project, location: location,latitude:latitude,longitude:longitude, documents: documents , notes: notes) { (success, docsModel, message) in
                if success {
                    completionHandler(true, nil, "")
                }else {
                    completionHandler(false,nil, "")
                }
            }
        }
    }
    
    //Api For Edit DailyLog
    func getEditDailyLog(controller: UIViewController,project:Int,dailylog_id: Int,location:String,latitude:Double,longitude:Double,documents:[String] ,notes: String, completionHandler: @escaping(_ status: Bool, _ editDailyLog: EditDailyLogModel?, _ errorMsg: String?) -> Void){
        
        var parameters = [String : Any]()
        var address = [String : Any]()
        address = ["name" : location, "longitude" : latitude, "latitude" : longitude]
        parameters = ["location": address, "documents": documents , "notes": notes]
      
        print("parameters", parameters)
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.editDailyLog + "?dailylog_id=" + "\(dailylog_id)", method: .put,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let editDailyLogData = try JSONDecoder().decode(BaseResponse<EditDailyLogModel>.self, from: jsonData)
                        print(editDailyLogData)
                        if editDailyLogData.code == 200 {
                            self.editDailyLogDataDetail = editDailyLogData.data! as EditDailyLogModel?
                            completionHandler(true, editDailyLogData.data!, "")
                        } else {
                            completionHandler(false, nil ,editDailyLogData.message ?? "")
                        }
                        
                    }
                    catch let err{
                        completionHandler(false,nil,err.localizedDescription ?? "")
                    }
                }
            }) { (error) in
                print("json error", error)
                completionHandler(false,nil,error)
            }
            
        }
        
    }
    
}
