//
//  CommentListViewModel.swift
//  Comezy
//
//  Created by shiphul on 24/12/21.
//

import UIKit

class CommentListViewModel: NSObject {
    var commentListDataDetail = [CommentResult]()
    func getCommentList(module: String, module_id: Int, size: Int, page: Int, completionHandler: @escaping (_ success: Bool, _ taskList: [CommentResult]?, _ errorMsg: String?) -> Void) {
        
        DispatchQueue.main.async {

            var url = API.getCommentList
//            url = "api/comment/?size=100&page=1&roi_id=7"
            url = url + "?size=" + "\(size)" + "&page=" + "\(page)" + "&\(module)=" + "\(module_id)"
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let CommentList = try JSONDecoder().decode(BaseResponse<CommentListModel>.self, from: jsonData)
                        print("CommentList  :", CommentList)
                        if CommentList.code == 200 {
                            self.commentListDataDetail = CommentList.data?.results ?? []
                            completionHandler(true, CommentList.data?.results, "")
                            
                        }else {
                            completionHandler(false,nil,CommentList.message ?? "")
                        }
                        
                    }
                    catch let err{
                        print("CommentList  err.localizedDescription:", err.localizedDescription)
                        completionHandler(false,nil,err.localizedDescription)
                    }
                }
            }) { (error) in
                print("CommentList  error:", error)
                completionHandler(false,nil,error)
                
            }
        }
        
    }
    //API for AddComment
    func getAddComment(controller: UIViewController, module: String, comment: String, moduleId:Int ,completionHandler: @escaping(_ status: Bool, _ addTaskList: AddCommentModel?, _ errorMsg: String?) -> Void) {
        
        var parameters = [String : Any]()

        parameters = ["comment": comment, "\(module)": moduleId]
      
        print("parameters", parameters)
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.addCommentList, method: .post,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let addCommentData = try JSONDecoder().decode(BaseResponse<AddCommentModel>.self, from: jsonData)
                        print(addCommentData)
                        print("This line is after decoding and printing addCommentData")
                        if addCommentData.code == 200 {
                            completionHandler(true, addCommentData.data!, "")
                        } else {
                            completionHandler(false, nil ,addCommentData.message ?? "")
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
    
}


