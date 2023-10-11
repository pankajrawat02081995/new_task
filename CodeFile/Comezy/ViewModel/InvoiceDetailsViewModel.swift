//
//  InvoiceDetailsViewModel.swift
//  Comezy
//
//  Created by Lalit Kumar on 17/08/23.
//

import Foundation


class InvoiceDetailsViewModel {
    
    var jsonData : InvoiceDetailsModel?
    
    //MARK: - GET INVOIVE LIST DATA
    func getInvoiceDetails(invoiceId: Int,_ completion:@escaping() -> Void) {
        let url = "\(ApiUrl.getInvoiceDetails)\(invoiceId)"
        
        
        WebServices.shared.getData(url, showIndicator: true) { response in
            if response.isSuccess {
                let apiData = Constantss.shared.jsonDecoder.decode(model: InvoiceDetailsModel.self, data: response.data)
                self.jsonData = apiData
                completion()
            } else {
                CommonMethod.shared.hideActivityIndicator()
                Alerts.shared.showAlert(title: AppInfo.appName, message: response.message)
            }
        }
    }
    
    //MARK: - CHANGE INVOICE STATUS
    func changeInvoiceStatus(invoiceId: Int, status: Bool,_ completion:@escaping() -> Void) {
        let url = "\(ApiUrl.changeStatus)\(invoiceId)&status=\(status)"
        
        
        WebServices.shared.getData(url, showIndicator: true) { response in
            if response.isSuccess {
                let apiData = Constantss.shared.jsonDecoder.decode(model: InvoiceDetailsModel.self, data: response.data)
                self.jsonData = apiData
                completion()
            } else {
                CommonMethod.shared.hideActivityIndicator()
                Alerts.shared.showAlert(title: AppInfo.appName, message: response.message)
            }
        }
    }

}
