//
//  TaskListViewModel.swift
//  Comezy
//
//  Created by shiphul on 20/12/21.
//

import UIKit
import Alamofire

class TaskListViewModel: NSObject {
    var taskListDataDetail = [TaskResult]()
    var workerResultList:[PeopleClient]?
    var objAssignedWorkerResult : AssignedWorker?
    var taskDetail : TaskDetailModel?
    class var shared:TaskListViewModel{
        struct Singlton{
            static let instance = TaskListViewModel()
        }
        return Singlton.instance
    }
    
    func getTaskList(project_id: Int, size: Int, page: Int, completionHandler: @escaping(_ status: Bool, _ taskList: [TaskResult]?, _ errorMsg: String?) -> Void){
        
        DispatchQueue.main.async{
            
            var url = API.getTaskList
            url = url + "\(project_id)" + "/get_tasks/" + "?size=" + "\(size)" + "&page=" + "\(page)"
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let TasksList = try JSONDecoder().decode(BaseResponse<TaskListModel>.self, from: jsonData)
                        print("TasksList  :", TasksList)
                        if TasksList.code == 200 {
                            self.taskListDataDetail = TasksList.data?.results ?? []
                            completionHandler(true, TasksList.data?.results, "")
                            
                        }else {
                            completionHandler(false,nil,TasksList.message ?? "")
                        }
                        
                    }
                    catch let err{
                        print("TasksList  err.localizedDescription:", err.localizedDescription)
                        completionHandler(false,nil,err.localizedDescription)
                    }
                }
            }) { (error) in
                print("TasksList  error:", error)
                completionHandler(false,nil,error)
                
            }
        }
    }
    
    //MARK: getAddTask API
    //API for Add Tasks
    func getAddTask(controller: UIViewController, task_name: String, start_date: String, end_date:String, description:String, documents:[String],project:Int,occupation:Int,assigned_worker: Int,status: String, color: String ,completionHandler: @escaping(_ status: Bool, _ addTaskList: AddTaskModel?, _ errorMsg: String?) -> Void){
        
        var parameters = [String : Any]()
        
        parameters = ["task_name": task_name, "start_date": start_date, "end_date": end_date, "description": description, "documents" : documents, "occupation":occupation, "assigned_worker": assigned_worker , "project": project, "status":"in_progress", "color": color]
        
        print("parameters", parameters)
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.addTaskList, method: .post,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let addTaskData = try JSONDecoder().decode(BaseResponse<AddTaskModel>.self, from: jsonData)
                        print(addTaskData)
                        if addTaskData.code == 200 {
                            completionHandler(true, addTaskData.data!, "")
                        }else {
                            completionHandler(false, nil ,addTaskData.message ?? "")
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
    
    
    //MARK: addTask
    //Validation for AddTaskList
    func addTask(controller:UIViewController, task_name: String, start_date: String, end_date: String,description:String ,documents: [String], project: Int, occupation: Int, assigned_worker:Int? ,status:String, color: String, completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ type: String?) -> Void){
        if(task_name.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kTaskNameEmpty, "")
        } else if (start_date.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kStart_DateEmpty, "")
        } else if (description.trimmingCharacters(in: .whitespaces).isEmpty) {
            completionHandler(false,FieldValidation.kTaskDescriptionEmpty, "")
        }
        else if (end_date.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false, FieldValidation.kEnd_DateEmpty, "")
        } else if (assigned_worker == nil){
            completionHandler(false,FieldValidation.kAssignedWorkerEmpty, "")
        }//else if (occupation.trimmingCharacters(in: .whitespaces).isEmpty){
        //            completionHandler(false,FieldValidation.koccupationEmpty, "")
        //       }
        else {
            self.getAddTask(controller: controller, task_name: task_name, start_date: start_date, end_date: end_date, description:description, documents:documents,project:project,occupation:occupation,assigned_worker: assigned_worker  ?? 0 ,status: status, color: color) { (success, projectModel, message) in
                if success {
                    completionHandler(true, nil, "")
                }else {
                    completionHandler(false,nil, "")
                }
            }
        }
    }
    
    
    func getTaskDetail(task_id:Int, completionHandler: @escaping(_ status: Bool) -> Void) {
        DispatchQueue.main.async {
            
            APIManager.shared.request(url: API.getTaskDetail + "\(task_id)" , method: .get,parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { [self] (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let taskDetail = try JSONDecoder().decode(BaseResponse<TaskDetailModel?>.self, from: jsonData)
                        print(taskDetail)
                        if taskDetail.code == 200 {
                            self.taskDetail = taskDetail.data.self as? TaskDetailModel
                            print(taskDetail)
                            completionHandler(true)
                        } else {
                            completionHandler(false)
                        }
                    }
                    catch let err {
                        completionHandler(false)
                    }
                }
            }) { (error) in
                print(error)
                completionHandler(false)
                
            }
        }
    }
    
    func getTaskResponse(task_id:Int, response: String, completionHandler: @escaping(_ status: Bool) -> Void) {
        DispatchQueue.main.async {
            
            var url = API.getTaskResponse
            url = url + "\(response)/?task_id=\(task_id)"
            APIManager.shared.request(url: url , method: .get,parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { [self] (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let taskDetail = try JSONDecoder().decode(BaseResponse<EmptyData>.self, from: jsonData)
                        print(taskDetail)
                        if taskDetail.code == 200 {
                            self.taskDetail = taskDetail.data.self as? TaskDetailModel
                            print(taskDetail)
                            completionHandler(true)
                        } else {
                            completionHandler(false)
                        }
                    }
                    catch let err {
                        completionHandler(false)
                    }
                }
            }) { (error) in
                print(error)
                completionHandler(false)
                
            }
        }
    }
    
    
    
}
//extension TaskListViewModel{
//    var workerListCount:Int{
//        return workerListCount.count
//    }
//    subscript (atWorkerList index:Int)->PeopleClient{
//            self.workerResultList[index]
//        }
//}
