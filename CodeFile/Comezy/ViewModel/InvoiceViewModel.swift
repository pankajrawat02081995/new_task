//
//  InvoiceViewModel.swift
//  Comezy
//
//  Created by Lalit Kumar on 26/06/23.
//

import Foundation
import UIKit


class InvoiceViewModel {
    
    var jsonData : InvoiceListModel?
    
    //MARK: - GET INVOIVE LIST DATA
    func getInvoiceList(projectId: Int ,startDate: String, endDate: String, status: String?,_ completion:@escaping() -> Void) {
        var url = ""
        if status == "" {
             url = "\(ApiUrl.getInvoiceList)\(projectId)&start_date=\(startDate)&end_date=\(endDate)"
        } else {
             url = "\(ApiUrl.getInvoiceList)\(projectId)&start_date=\(startDate)&end_date=\(endDate)&status=\(status ?? "")"
        }
        
        WebServices.shared.getData(url, showIndicator: true) { response in
            if response.isSuccess {
                let apiData = Constantss.shared.jsonDecoder.decode(model: InvoiceListModel.self, data: response.data)
                self.jsonData = apiData
                completion()
            } else {
                CommonMethod.shared.hideActivityIndicator()
                Alerts.shared.showAlert(title: AppInfo.appName, message: response.message)
            }
        }
    }
    
    
    
    
//    func getInvoiceList(projectId: Int ,startDate: String, endDate: String, status: String?, completionHandler: @escaping(_ success: Bool, _ resp: InvoiceListModel?, _ errorMsg: String?) -> Void){
//
//
//        DispatchQueue.main.async {
//            var url = "invoice/invoices/list?project_id=\(projectId)"
//
////            var parameters = [String : Any]()
////            parameters = ["start_date":startDate,
////                          "end_date":endDate,
////                          "status": 0]
////
////            if status == nil {
////                url = url + "start_date=" + startDate + "&end_date=" + endDate
////            } else {
////                url = url + "start_date=" + startDate + "&end_date=" + endDate + "&status=" + "\(status ?? 0)"
////            }
//            print(url)
//
//            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
//
//            }, success: { (json) in
//
//                if let json = json {
//                    do {
//                        let jsonData = try JSONSerialization.data(withJSONObject:json)
//                        print("jsonData  :", jsonData)
//                        let result = try JSONDecoder().decode(BaseResponse<InvoiceListModel>.self, from: jsonData)
//                        print("ProjectList  :", result)
//                        if result.code == 200 {
//                            completionHandler(true, result.data, "")
//
//                        } else {
//                            completionHandler(false, nil, result.message ?? "Error occured while Decoding")
//                        }
//
//                    }
//                    catch let err {
//                        print("ProjectList  err.localizedDescription:", err.localizedDescription)
//                        completionHandler(false,nil,err.localizedDescription)
//                    }
//                }
//            }) { (error) in
//                print("ProjectList  error:", error)
//
//                completionHandler(false,nil,error)
//
//            }
//        }
//
//    }
}
