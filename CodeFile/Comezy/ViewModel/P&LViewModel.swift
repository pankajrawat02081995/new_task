//
//  P&LViewModel.swift
//  Comezy
//
//  Created by Lalit Kumar on 11/07/23.
//

import Foundation

class P_LViewModel: NSObject {
    
    
    
    var jsonData : InvoiceListModel?
    var profitLostData : ProfitLostListModel?
    var purchaseData : PurchaseOrdersListModel?
    
    
    func getInvoicesList(projectId: Int ,startDate: String, endDate: String,_ completion:@escaping() -> Void) {
        let url = "\(ApiUrl.getInvoiceList)\(projectId)&start_date=\(startDate)&end_date=\(endDate)&status=1"
        
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
    
    //MARK: - PROFIT LOST LIST
    func getProfitLostList(projectId: Int ,_ completion:@escaping() -> Void) {
       
        
        let url = "\(ApiUrl.profileLost)?project_id=\(projectId)"
        
        WebServices.shared.getData(url, showIndicator: true) { response in
            if response.isSuccess {
                let apiData = Constantss.shared.jsonDecoder.decode(model: ProfitLostListModel.self, data: response.data)
                self.profitLostData = apiData
                completion()
            } else {
                CommonMethod.shared.hideActivityIndicator()
                Alerts.shared.showAlert(title: AppInfo.appName, message: response.message)
            }
        }
    }
    
    
    //MARK: - PURCHASE ORDERS LIST
    func getPurchaseOrdersList(projectId: Int ,_ completion:@escaping() -> Void) {
        let url = "\(ApiUrl.purchaseList)?project_id=\(projectId)"
        WebServices.shared.getData(url, showIndicator: true) { response in
            if response.isSuccess {
                let apiData = Constantss.shared.jsonDecoder.decode(model: PurchaseOrdersListModel.self, data: response.data)
                self.purchaseData = apiData
                completion()
            } else {
                CommonMethod.shared.hideActivityIndicator()
                Alerts.shared.showAlert(title: AppInfo.appName, message: response.message)
            }
        }
    }
    
    
    func getInvoiceList(projectId: Int ,completionHandler: @escaping(_ success: Bool, _ resp: InvoiceListModel?, _ errorMsg: String?) -> Void){
        
        
        DispatchQueue.main.async {
            let url = "invoice/invoices/list?project_id=\(projectId)"
            print(url)
            
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let result = try JSONDecoder().decode(BaseResponse<InvoiceListModel>.self, from: jsonData)
                        print("ProjectList  :", result)
                        if result.code == 200 {
                            completionHandler(true, result.data, "")
                            
                        } else {
                            completionHandler(false, nil, result.message ?? "Error occured while Decoding")
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
    
    
    
    func getPurchaseList(projectId: Int ,completionHandler: @escaping(_ success: Bool, _ resp: PurchaseListModel?, _ errorMsg: String?) -> Void){
        
        
        DispatchQueue.main.async {
            let url = "invoice/purchase/list?project_id=\(projectId)"
            print(url)
            
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let result = try JSONDecoder().decode(BaseResponse<PurchaseListModel>.self, from: jsonData)
                        print("ProjectList  :", result)
                        if result.code == 200 {
                            completionHandler(true, result.data, "")
                            
                        } else {
                            completionHandler(false, nil, result.message ?? "Error occured while Decoding")
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
