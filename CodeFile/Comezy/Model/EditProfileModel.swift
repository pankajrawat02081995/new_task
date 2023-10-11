import Foundation

// MARK: - Welcome
struct EditProfileModel: Codable {
    let firstName, lastName, phone: String
    let occupation: EditProfileModelOccupation
    let company: String
    let profilePicture: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case phone, occupation, company
        case profilePicture = "profile_picture"
    }
}

// MARK: - Occupation
struct EditProfileModelOccupation: Codable {
    let name: String
    let id: Int
}
