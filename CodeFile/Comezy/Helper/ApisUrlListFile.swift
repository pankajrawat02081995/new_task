//
//  ApisUrlListFile.swift
//  Picker
//
//  Created by Developer IOS on 29/05/23.
//

import Foundation

//MARK: - SERVER LINK's
struct ServerLink {
    static let baseUrlApi = "http://3.21.238.163:8001/"
    static let imageBaseUrl = "http://144.91.80.25:3030/"
    static let baseUrl = ""
    static let socketBaseUrl = ""
}

//MARK: - API URL's
struct ApiUrl {
   
    
    static let getInvoiceList = ServerLink.baseUrlApi + "invoice/invoices/list?project_id="
    static let getInvoiceDetails = ServerLink.baseUrlApi + "invoice/invoice/detail?invoice_id="
    static let changeStatus = ServerLink.baseUrlApi + "invoice/invoice/update?invoice_id="
    static let profileDetails = ServerLink.baseUrlApi + "accounts/profiledetails/"
    static let profileLost = ServerLink.baseUrlApi + "invoice/Profit/loss/list"
    static let profileLostDetails = ServerLink.baseUrlApi + "invoice/Profit/loss/detail"
    static let purchaseList = ServerLink.baseUrlApi + "invoice/purchase/list"

    
    
}
