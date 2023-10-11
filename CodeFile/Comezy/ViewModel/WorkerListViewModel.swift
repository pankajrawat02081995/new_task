//
//  WorkerListViewModel.swift
//  Comezy
//
//  Created by shiphul on 16/12/21.
//

import UIKit

class WorkerListViewModel: NSObject {
    
    var workerListDataDetail = [WorkersResult]()
    var addWorkerListDataDetail = [AddWorkerClient]()
    //API for Unassigned Wokers
    func getWorkersList(searchParam: String, unassigned_workers: Int, size: String, page: Int, project_id: Int, completionHandler: @escaping(_ status: Bool, _ workerList: [WorkersResult]? , _ errorMsg: String?) -> Void){
        
        DispatchQueue.main.async {
            
            var url = API.getUnassignedWorkerList
            url = url + "\(project_id)" + "/unassigned_workers/" + "?size=" + "\(size)" + "&page=" + "\(page)" + "&search=" + "\(searchParam)"
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { [self] (json) in
                
                if let json = json {
                    do {
                        print(json)
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let WorkerList = try JSONDecoder().decode(BaseResponse<Workers>.self, from: jsonData)
                        print("WorkerList  :", WorkerList)
                        if WorkerList.code == 200 {
                            self.workerListDataDetail = WorkerList.data?.results ?? []
                            completionHandler(true, WorkerList.data?.results, "")
                            
                        }else {
                            completionHandler(false,nil,WorkerList.message ?? "")
                        }
                        
                    }
                    catch let err{
                        print("ProjectList  err.localizedDescription:", err.localizedDescription)
                        completionHandler(false,nil,err.localizedDescription)
                    }
                }
            }) { (error) in
                print("WorkerList  error:", error)
                completionHandler(false,nil,error)
                
            }
        }
    }
    
    //API for adding unassigned worker in people list
    func getAddWorkerList(project_id:Int, worker_id:Int,completionHandler: @escaping(_ status: Bool, _ workerList: [AddWorkerClient]? , _ errorMsg: String?) -> Void){
        
        DispatchQueue.main.async{

            var url = API.getAddUnassignedWorker
            url = url + "project_id=" + "\(project_id)" + "&worker_id=" + "\(worker_id)"
            print(url)
            
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { [self] (json) in
                
                if let json = json {
                    do {
                        print(json)
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let AddWorkerList = try JSONDecoder().decode(BaseResponse<AddWorkerModel>.self, from: jsonData)
                        print("AddWorkerList  :", AddWorkerList)
                        if AddWorkerList.code == 200 {
                            self.addWorkerListDataDetail = AddWorkerList.data?.worker ?? []
                            completionHandler(true, AddWorkerList.data?.worker, "")
                            
                        }else {
                            completionHandler(false, nil, AddWorkerList.message ?? "")
                        }
                        
                    }
                    catch let err{
                        print("AddWorkerList  err.localizedDescription:", err.localizedDescription)
                        completionHandler(false, nil, err.localizedDescription)
                    }
                }
            }) { (error) in
                print("AddWorkerList  error:", error)
                completionHandler(false,nil, error)
                
            }
        }
    }
}
