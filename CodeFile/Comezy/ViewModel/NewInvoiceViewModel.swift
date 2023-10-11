//
//  NewInvoiceViewModel.swift
//  Comezy
//
//  Created by Lalit Kumar on 11/07/23.
//

import Foundation


class NewInvoiceViewModel: NSObject {
 
    func addInvoice(arr: [ItemsList], req: InvoiceAdd, completionHandler: @escaping(_ status: Bool, _ invoiceModel: InvoiceListModel?, _ errorMsg: String?) -> Void){
        
        var items = [[String: Any]]()
        
        for i in 0..<arr.count {
            let data = arr[i]
            let value = ["name": data.name,
                         "description": "Item \(i)",
                         "price": data.amount,
                         "currency": "USD",
                         "quantity": data.quantity] as [String: Any]
            
            if data.hasValue {
                items.append(value)
            }
            
        }
        
        let param = ["terms": req.terms,
                     "tax_rate": req.tax_rate,
                     "tax": req.tax,
                     "project": req.project,
                     "customer": req.customer,
                     "name": req.name,
                     "items": items] as [String: Any]
        
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.createInvoice, method: .post,parameters:param ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let decodedData = try JSONDecoder().decode(InvoiceListModel.self, from: jsonData)
                        print(decodedData)
                        if decodedData.code == 200 {
                            completionHandler(true, nil , "")
                        } else {
                            completionHandler(false, nil, decodedData.message ?? "Error occured while Decoding")
                        }
                        
                    }
                    catch let err {
                        print("!@#$!@#$@#$%^#    FAILED  $%$%^$%^##$%", err)
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
