//
//  ProjectStatusViewModel.swift
//  Comezy
//
//  Created by aakarshit on 22/07/22.
//

import Foundation

class ProjectStatusViewModel: NSObject {
    func getProjectList(searchProject: String, type: String, completionHandler: @escaping(_ status: Bool, _ projectList: [ProjectResult]?, _ errorMsg: String?) -> Void){
      
        DispatchQueue.main.async{
//            var parameters = [String : Any]()
//            parameters = ["status" : type, "page": 1 , "size": 10, "search": searchProject ]
            var url = API.projectListApi
            url = url + "status=" +  "\(type)" + "&page=" + "1" + "&size=" + "1000" + "&search=" + "\(searchProject)"
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let ProjectList = try JSONDecoder().decode(BaseResponse<DataClass>.self, from: jsonData)
                        print("ProjectList  :", ProjectList)
                        if ProjectList.code == 200 {
                            completionHandler(true, ProjectList.data?.results, "")
                            
                        }else {
                            completionHandler(false,nil,ProjectList.message ?? "")
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
    
    
    func getProjectListByType(type: String, completionHandler: @escaping(_ status: Bool, _ projectList: [ProjectResult]?, _ errorMsg: String?) -> Void){
      
        DispatchQueue.main.async{
//            var parameters = [String : Any]()
//            parameters = ["status" : type, "page": 1 , "size": 10, "search": searchProject ]
            var url = "api/project/"
            url = url + "\(type)/?" + "page=" + "1" + "&size=" + "1000"
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let ProjectList = try JSONDecoder().decode(BaseResponse<DataClass>.self, from: jsonData)
                        print("ProjectList  :", ProjectList)
                        if ProjectList.code == 200 {
                            completionHandler(true, ProjectList.data?.results, "")
                            
                        }else {
                            completionHandler(false,nil,ProjectList.message ?? "")
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
    
    
    
    func changeProjectStatus(type: String, projectId: Int, completionHandler: @escaping(_ status: Bool, _ projectList: BaseResponse<EmptyData>?, _ errorMsg: String?) -> Void){
      
        DispatchQueue.main.async{
//            var parameters = [String : Any]()
//            parameters = ["status" : type, "page": 1 , "size": 10, "search": searchProject ]
            var url = "api/project/"
            url = url + "\(type)/?" + "project_id=\(projectId)"
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let ProjectList = try JSONDecoder().decode(BaseResponse<EmptyData>.self, from: jsonData)
                        print("ProjectList  :", ProjectList)
                        if ProjectList.code == 200 {
                            completionHandler(true, ProjectList , "")
                            
                        }else {
                            completionHandler(false,nil,ProjectList.message ?? "")
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
    
    func deleteProject(projectId: Int, completionHandler: @escaping(_ status: Bool, _ projectList: EmptyData?, _ errorMsg: String?) -> Void){
      
        DispatchQueue.main.async{
//            var parameters = [String : Any]()
//            parameters = ["status" : type, "page": 1 , "size": 10, "search": searchProject ]
            var url = "api/project/"
            url = url + "?" + "project_id=\(projectId)"
            APIManager.shared.request(url: url, method: .delete, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let ProjectList = try JSONDecoder().decode(BaseResponse<EmptyData>.self, from: jsonData)
                        print("ProjectList  :", ProjectList)
                        if ProjectList.code == 200 {
                            completionHandler(true, ProjectList.data, "")
                            
                        } else {
                            completionHandler(false,nil,ProjectList.message ?? "")
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
    
    func leaveProjectList(completionHandler: @escaping(_ status: Bool, _ projectList: LeaveJobDataClass?, _ errorMsg: String?) -> Void){
      
        DispatchQueue.main.async{
//            var parameters = [String : Any]()
//            parameters = ["status" : type, "page": 1 , "size": 10, "search": searchProject ]
            var url = "api/project/"
            url = url + "listjob/?" + "page=" + "1" + "&size=" + "1000"
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let ProjectList = try JSONDecoder().decode(BaseResponse<LeaveJobDataClass>.self, from: jsonData)
                        print("ProjectList  :", ProjectList)
                        if ProjectList.code == 200 {
                            completionHandler(true, ProjectList.data, "")
                            
                        }else {
                            completionHandler(false,nil,ProjectList.message ?? "")
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
    
    func getInviteList(completionHandler: @escaping(_ status: Bool, _ projectList: InviteListModel?, _ errorMsg: String?) -> Void){
      
        DispatchQueue.main.async{
//            var parameters = [String : Any]()
//            parameters = ["status" : type, "page": 1 , "size": 10, "search": searchProject ]
            var url = "accounts/invitation/?"
            url = url + "page=" + "1" + "&size=" + "1000"
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let ProjectList = try JSONDecoder().decode(BaseResponse<InviteListModel>.self, from: jsonData)
                        print("ProjectList  :", ProjectList)
                        if ProjectList.code == 200 {
                            completionHandler(true, ProjectList.data, "")
                            
                        }else {
                            completionHandler(false,nil,ProjectList.message ?? "")
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

    
    
    
    
}
