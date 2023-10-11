//
//  AllPeopleListViewModel.swift
//  Comezy
//
//  Created by aakarshit on 24/05/22.
//

import Foundation

class AllPeopleListViewModel: NSObject {
    class var shared:AllPeopleListViewModel {
            struct Singlton{
                static let instance = AllPeopleListViewModel()
            }
            return Singlton.instance
        }
    
    var allPeopleListDataDetail = [AllPeopleListElement]()
    var allPeopleSearchedListDataDetail = [AllPeopleListElement]()


    
    
    func getAllPeopleList(project_id: Int, completionHandler: @escaping(_ status: Bool, _ peopleList: [AllPeopleListElement]?, _ errorMsg: String?) -> Void) {
        
        DispatchQueue.main.async {

            var url = API.getAllPeopleList
            url = url + "\(project_id)"
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { [self] (json) in
                
                if let json = json {
                    do {
                        print(json)
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let PeopleList = try JSONDecoder().decode(BaseResponse<AllPeopleListModel>.self, from: jsonData)
                        print("PeopleList  :", PeopleList)
                        if PeopleList.code == 200 {
//                            self.peopleListDataDetail = PeopleList.data?.results?.workers ?? []
//                            self.clientListDataDetail = PeopleList.data?.results?.client ?? PeopleClient()
//                            print(clientListDataDetail)
                            self.allPeopleListDataDetail = PeopleList.data ?? []
                            completionHandler(true, self.allPeopleListDataDetail , "")
                            
                        } else {
                            completionHandler(false,nil,PeopleList.message ?? "")
                        }
                        
                    }
                    catch let err {
                        print(err)
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
    
    func getAllPeopleWithoutHUD(project_id: Int, completionHandler: @escaping(_ status: Bool, _ peopleList: [AllPeopleListElement]?, _ errorMsg: String?) -> Void) {
        
        DispatchQueue.main.async {

            var url = API.getAllPeopleList
            url = url + "\(project_id)"
            APIManager.shared.requestWithoutHUD(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { [self] (json) in
                
                if let json = json {
                    do {
                        print(json)
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let PeopleList = try JSONDecoder().decode(BaseResponse<AllPeopleListModel>.self, from: jsonData)
                        print("PeopleList  :", PeopleList)
                        if PeopleList.code == 200 {
//                            self.peopleListDataDetail = PeopleList.data?.results?.workers ?? []
//                            self.clientListDataDetail = PeopleList.data?.results?.client ?? PeopleClient()
//                            print(clientListDataDetail)
                            self.allPeopleListDataDetail = PeopleList.data ?? []
                            completionHandler(true, self.allPeopleListDataDetail , "")
                            
                        } else {
                            completionHandler(false,nil,PeopleList.message ?? "")
                        }
                        
                    }
                    catch let err {
                        print(err)
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
