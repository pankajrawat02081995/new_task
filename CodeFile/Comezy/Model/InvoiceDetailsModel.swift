//
//  InvoiceDetailsModel.swift
//  Comezy
//
//  Created by Lalit Kumar on 17/08/23.
//

import Foundation


struct InvoiceDetailsModel : Codable {
    let status : String?
    let code : Int?
    let data : InvoiceDetailsData?
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
        data = try values.decodeIfPresent(InvoiceDetailsData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}


struct InvoiceDetailsData : Codable {
    let invoice : InvoiceList?

    enum CodingKeys: String, CodingKey {

        case invoice = "invoice"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        invoice = try values.decodeIfPresent(InvoiceList.self, forKey: .invoice)
    }

}



struct InvoiceList : Codable {
    let id : Int?
    let owner : String?
    let client : String?
    let status : Bool?
    let created_date : String?
    let terms : String?
    let tax_rate : Double?
    let builder_address : String?
    let tax_amount : Double?
    let tax : String?
    let note : String?
    let pdf_link: String?
    let sub_total : Int?
    let total_amount : Double?
    let items : [InvoiceItems]?
    let address : InvoiceAddress?
    let invoice_code : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case owner = "Owner"
        case client = "client"
        case status = "status"
        case created_date = "created_date"
        case terms = "terms"
        case tax_rate = "tax_rate"
        case builder_address = "builder_address"
        case tax_amount = "tax_amount"
        case tax = "tax"
        case note = "note"
        case pdf_link = "pdf_link"
        case sub_total = "sub_total"
        case total_amount = "total_amount"
        case items = "items"
        case address = "address"
        case invoice_code = "invoice_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        owner = try values.decodeIfPresent(String.self, forKey: .owner)
        client = try values.decodeIfPresent(String.self, forKey: .client)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        created_date = try values.decodeIfPresent(String.self, forKey: .created_date)
        terms = try values.decodeIfPresent(String.self, forKey: .terms)
        tax_rate = try values.decodeIfPresent(Double.self, forKey: .tax_rate)
        builder_address = try values.decodeIfPresent(String.self, forKey: .builder_address)
        tax_amount = try values.decodeIfPresent(Double.self, forKey: .tax_amount)
        tax = try values.decodeIfPresent(String.self, forKey: .tax)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        pdf_link = try values.decodeIfPresent(String.self, forKey: .pdf_link)
        sub_total = try values.decodeIfPresent(Int.self, forKey: .sub_total)
        total_amount = try values.decodeIfPresent(Double.self, forKey: .total_amount)
        items = try values.decodeIfPresent([InvoiceItems].self, forKey: .items)
        address = try values.decodeIfPresent(InvoiceAddress.self, forKey: .address)
        invoice_code = try values.decodeIfPresent(String.self, forKey: .invoice_code)
    }

}


struct InvoiceAddress : Codable {
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


struct InvoiceItems : Codable {
    let id : Int?
    let name : String?
    let description : String?
    let price : Int?
    let currency : String?
    let quantity : Int?
    let invoice : Int?
    let total_price : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case description = "description"
        case price = "price"
        case currency = "currency"
        case quantity = "quantity"
        case invoice = "invoice"
        case total_price = "total_price"
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
        total_price = try values.decodeIfPresent(Int.self, forKey: .total_price)
    }

}
