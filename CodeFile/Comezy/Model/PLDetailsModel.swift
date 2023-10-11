//
//  PLDetailsModel.swift
//  Comezy
//
//  Created by Lalit Kumar on 28/09/23.
//

import Foundation


struct PLDetailsModel : Codable {
    let status : String?
    let code : Int?
    let data : PLDetailsData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case code = "code"
        case data = "data"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        data = try values.decodeIfPresent(PLDetailsData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}


struct PLDetailsData : Codable {
    let purchase_payment_amount : Double?
    let amount_of_invoice : Double?
    let total_profit_loss : Int?
    let result : Int?
    let purchase : [PLDetailsPurchase]?
    let invoice_list : [PLDetailsInvoiceList]?
    let client : PLDetailsClient?
    let owner : PLDetailsOwner?
    let address : PLDetailsAddress?

    enum CodingKeys: String, CodingKey {

        case purchase_payment_amount = "purchase_payment_amount"
        case amount_of_invoice = "amount_of_invoice"
        case total_profit_loss = "total_profit_loss"
        case result = "result"
        case purchase = "purchase"
        case invoice_list = "invoice_list"
        case client = "client"
        case owner = "Owner"
        case address = "address"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        purchase_payment_amount = try values.decodeIfPresent(Double.self, forKey: .purchase_payment_amount)
        amount_of_invoice = try values.decodeIfPresent(Double.self, forKey: .amount_of_invoice)
        total_profit_loss = try values.decodeIfPresent(Int.self, forKey: .total_profit_loss)
        result = try values.decodeIfPresent(Int.self, forKey: .result)
        purchase = try values.decodeIfPresent([PLDetailsPurchase].self, forKey: .purchase)
        invoice_list = try values.decodeIfPresent([PLDetailsInvoiceList].self, forKey: .invoice_list)
        client = try values.decodeIfPresent(PLDetailsClient.self, forKey: .client)
        owner = try values.decodeIfPresent(PLDetailsOwner.self, forKey: .owner)
        address = try values.decodeIfPresent(PLDetailsAddress.self, forKey: .address)
    }

}


struct PLDetailsOwner : Codable {
    let id : Int?
    let username : String?
    let email : String?
    let first_name : String?
    let last_name : String?
    let user_type : String?
    let occupation : Int?
    let profile_picture : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case username = "username"
        case email = "email"
        case first_name = "first_name"
        case last_name = "last_name"
        case user_type = "user_type"
        case occupation = "occupation"
        case profile_picture = "profile_picture"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        user_type = try values.decodeIfPresent(String.self, forKey: .user_type)
        occupation = try values.decodeIfPresent(Int.self, forKey: .occupation)
        profile_picture = try values.decodeIfPresent(String.self, forKey: .profile_picture)
    }

}


struct PLDetailsInvoiceList : Codable {
    let invoice : PLDetailsInvoice?
    let item : [PLDetailsItem]?

    enum CodingKeys: String, CodingKey {

        case invoice = "invoice"
        case item = "item"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        invoice = try values.decodeIfPresent(PLDetailsInvoice.self, forKey: .invoice)
        item = try values.decodeIfPresent([PLDetailsItem].self, forKey: .item)
    }

}

struct PLDetailsInvoice : Codable {
    let id : Int?
    let status : Bool?
    let created_date : String?
    let updated_date : String?
    let terms : String?
    let note : String?
    let tax_rate : Double?
    let tax : String?
    let invoice_code : String?
    let pdf_file : String?
    let project : Int?
    let amount_of_invoice : Double?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case status = "status"
        case created_date = "created_date"
        case updated_date = "updated_date"
        case terms = "terms"
        case note = "note"
        case tax_rate = "tax_rate"
        case tax = "tax"
        case invoice_code = "invoice_code"
        case pdf_file = "pdf_file"
        case project = "project"
        case amount_of_invoice = "amount_of_invoice"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        created_date = try values.decodeIfPresent(String.self, forKey: .created_date)
        updated_date = try values.decodeIfPresent(String.self, forKey: .updated_date)
        terms = try values.decodeIfPresent(String.self, forKey: .terms)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        tax_rate = try values.decodeIfPresent(Double.self, forKey: .tax_rate)
        tax = try values.decodeIfPresent(String.self, forKey: .tax)
        invoice_code = try values.decodeIfPresent(String.self, forKey: .invoice_code)
        pdf_file = try values.decodeIfPresent(String.self, forKey: .pdf_file)
        project = try values.decodeIfPresent(Int.self, forKey: .project)
        amount_of_invoice = try values.decodeIfPresent(Double.self, forKey: .amount_of_invoice)
    }

}


struct PLDetailsItem : Codable {
    let id : Int?
    let name : String?
    let description : String?
    let price : Int?
    let currency : String?
    let quantity : Int?
    let invoice : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case description = "description"
        case price = "price"
        case currency = "currency"
        case quantity = "quantity"
        case invoice = "invoice"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        price = try values.decodeIfPresent(Int.self, forKey: .price)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        invoice = try values.decodeIfPresent(Int.self, forKey: .invoice)
    }

}


struct PLDetailsPurchase : Codable {
    let purchase : PLPurchase?
    let item : [PLItem]?

    enum CodingKeys: String, CodingKey {

        case purchase = "purchase"
        case item = "item"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        purchase = try values.decodeIfPresent(PLPurchase.self, forKey: .purchase)
        item = try values.decodeIfPresent([PLItem].self, forKey: .item)
    }

}


struct PLDetailsClient : Codable {
    let id : Int?
    let username : String?
    let email : String?
    let first_name : String?
    let last_name : String?
    let user_type : String?
    let occupation : Int?
    let profile_picture : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case username = "username"
        case email = "email"
        case first_name = "first_name"
        case last_name = "last_name"
        case user_type = "user_type"
        case occupation = "occupation"
        case profile_picture = "profile_picture"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        user_type = try values.decodeIfPresent(String.self, forKey: .user_type)
        occupation = try values.decodeIfPresent(Int.self, forKey: .occupation)
        profile_picture = try values.decodeIfPresent(String.self, forKey: .profile_picture)
    }

}


struct PLDetailsAddress : Codable {
    let id : Int?
    let name : String?
    let longitude : Double?
    let latitude : Double?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case longitude = "longitude"
        case latitude = "latitude"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
    }

}


struct PLPurchase : Codable {
    
    let id : Int?
    let created_date : String?
    let note : String?
    let tax_rate : Int?
    let tax : String?
    let project : Int?
    let purchase_code : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case created_date = "created_date"
        case note = "note"
        case tax_rate = "tax_rate"
        case tax = "tax"
        case project = "project"
        case purchase_code = "purchase_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        created_date = try values.decodeIfPresent(String.self, forKey: .created_date)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        tax_rate = try values.decodeIfPresent(Int.self, forKey: .tax_rate)
        tax = try values.decodeIfPresent(String.self, forKey: .tax)
        project = try values.decodeIfPresent(Int.self, forKey: .project)
        purchase_code = try values.decodeIfPresent(String.self, forKey: .purchase_code)
    }

}


struct PLItem : Codable {
    
    let id : Int?
    let name : String?
    let description : String?
    let price : Int?
    let currency : String?
    let quantity : Int?
    let purchase_details : Int?
    let created_date : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case description = "description"
        case price = "price"
        case currency = "currency"
        case quantity = "quantity"
        case purchase_details = "purchase_details"
        case created_date = "created_date"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        price = try values.decodeIfPresent(Int.self, forKey: .price)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        purchase_details = try values.decodeIfPresent(Int.self, forKey: .purchase_details)
        created_date = try values.decodeIfPresent(String.self, forKey: .created_date)
    }

}
