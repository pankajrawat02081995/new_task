//
//  InvoiceListModel.swift
//  Comezy
//
//  Created by Lalit Kumar on 26/06/23.
//

struct InvoiceListModel : Codable {
    let status : String?
    let code : Int?
    let data : InvoiceListData?
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
        data = try values.decodeIfPresent(InvoiceListData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}


struct InvoiceListData : Codable {
    let count : Int?
    let next : String?
    let previous : String?
    let results : InvoiceResults?

    enum CodingKeys: String, CodingKey {

        case count = "count"
        case next = "next"
        case previous = "previous"
        case results = "results"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        next = try values.decodeIfPresent(String.self, forKey: .next)
        previous = try values.decodeIfPresent(String.self, forKey: .previous)
        results = try values.decodeIfPresent(InvoiceResults.self, forKey: .results)
    }

}

struct InvoiceResults : Codable {
    let invoices : [InvoicesList]?
    let client : InvoiceClient?
    let project_address : ProjectAddress?

    enum CodingKeys: String, CodingKey {

        case invoices = "invoices"
        case client = "Client"
        case project_address = "Project_address"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        invoices = try values.decodeIfPresent([InvoicesList].self, forKey: .invoices)
        client = try values.decodeIfPresent(InvoiceClient.self, forKey: .client)
        project_address = try values.decodeIfPresent(ProjectAddress.self, forKey: .project_address)
    }

}


struct ProjectAddress : Codable {
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


struct InvoicesList : Codable {
    let id : Int?
    let amount_of_invoice : Double?
    let currency : String?
    let status : Bool?
    let invoice_code : String?
    let created_date : String?
    let builder_address : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case amount_of_invoice = "amount_of_invoice"
        case currency = "currency"
        case status = "status"
        case invoice_code = "invoice_code"
        case created_date = "created_date"
        case builder_address = "builder_address"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        amount_of_invoice = try values.decodeIfPresent(Double.self, forKey: .amount_of_invoice)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        invoice_code = try values.decodeIfPresent(String.self, forKey: .invoice_code)
        created_date = try values.decodeIfPresent(String.self, forKey: .created_date)
        builder_address = try values.decodeIfPresent(String.self, forKey: .builder_address)
    }

}


struct InvoiceClient : Codable {
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
