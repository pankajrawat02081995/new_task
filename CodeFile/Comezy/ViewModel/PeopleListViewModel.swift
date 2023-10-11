//
//  PeopleListViewModel.swift
//  Comezy
//
//  Created by shiphul on 15/12/21.
//

import UIKit

class PeopleListViewModel: NSObject {
    
    class var shared:PeopleListViewModel{
            struct Singlton{
                static let instance = PeopleListViewModel()
            }
            return Singlton.instance
        }

    var peopleListDataDetail = [PeopleClient]()
    var clientListDataDetail = PeopleClient()
    var variationsToPeopleList = [PeopleClient]()
    
    
    func getPeopleList(assigned_workers: Int = 0, size: String, page: Int, project_id: Int, completionHandler: @escaping(_ status: Bool, _ peopleList: PeopleResults?, _ errorMsg: String?) -> Void) {
        
        DispatchQueue.main.async {

            var url = API.getPeopleList
            url = url + "\(project_id)" + "/assigned_workers/" + "?size=" + "\(size)" + "&page=" + "\(page)"
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { [self] (json) in
                
                if let json = json {
                    do {
                        print(json, "P R I N T     J S O N")
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let PeopleList = try JSONDecoder().decode(BaseResponse<PeopleListModel>.self, from: jsonData)
                        print("PeopleList  :", PeopleList)
                        if PeopleList.code == 200 {
                            self.peopleListDataDetail = PeopleList.data?.results?.workers ?? []
                            self.clientListDataDetail = PeopleList.data?.results?.client ?? PeopleClient()
                            print(clientListDataDetail)
                            completionHandler(true, PeopleList.data?.results, "")
                            
                        } else {
                            completionHandler(false,nil,PeopleList.message ?? "")
                        }
                        
                    }
                    catch let err {
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
    func unAssignedWorker(assignedWorkerId:Int, project_id: Int, completionHandler: @escaping(_ status: Bool, _ unAssignedWorkerModel: unAssignedWorkerModel?, _ errorMsg: String?) -> Void) {
        
        DispatchQueue.main.async {

            var url = API.unAssignedWorker
            url = url + "\(project_id)" + "&worker_id=" + "\(assignedWorkerId)"
            APIManager.shared.request(url: url, method: .delete, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { [self] (json) in
                
                if let json = json {
                    do {
                        print(json, "P R I N T     J S O N")
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let unassignedWorker = try JSONDecoder().decode(unAssignedWorkerModel.self, from: jsonData)
                        print("unassignedWorker  :", unassignedWorker)
                        if unassignedWorker.code == 200 {
                          
                            completionHandler(true, nil, "")
                            
                        } else {
                            completionHandler(false,nil,unassignedWorker.message ?? "")
                        }
                        
                    }
                    catch let err {
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
    func getPeopleListInBackground(assigned_workers: Int = 0, size: String, page: Int, project_id: Int, completionHandler: @escaping(_ status: Bool, _ peopleList: PeopleResults?, _ errorMsg: String?) -> Void) {
        
        DispatchQueue.main.async {

            var url = API.getPeopleList
            url = url + "\(project_id)" + "/assigned_workers/" + "?size=" + "\(size)" + "&page=" + "\(page)"
            APIManager.shared.requestWithoutHUD(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { [self] (json) in
                
                if let json = json {
                    do {
                        print(json, "P R I N T     J S O N")
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let PeopleList = try JSONDecoder().decode(BaseResponse<PeopleListModel>.self, from: jsonData)
                        print("PeopleList  :", PeopleList)
                        if PeopleList.code == 200 {
                            self.peopleListDataDetail = PeopleList.data?.results?.workers ?? []
                            self.clientListDataDetail = PeopleList.data?.results?.client ?? PeopleClient()
                            print(clientListDataDetail)
                            completionHandler(true, PeopleList.data?.results, "")
                            
                        } else {
                            completionHandler(false,nil,PeopleList.message ?? "")
                        }
                        
                    }
                    catch let err {
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
