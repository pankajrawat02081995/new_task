// MARK: - Welcome
struct InviteListModel: Codable {
    let next, previous: String
    let totalCount: Int
    let results: [InviteListResult]

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Result
struct InviteListResult: Codable {
    let id: Int
    let firstName, lastName, email, userType: String
    let project: Int?
    let inductionURL: String
    let status, inviteDate: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case userType = "user_type"
        case project
        case inductionURL = "induction_url"
        case status
        case inviteDate = "invite_date"
    }
}
