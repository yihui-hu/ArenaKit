public struct User: Decodable, Hashable, Sendable {
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    public let id: Int
    public let slug: String
    public let username: String
    public let initials: String
    public let createdAt: String
    public let channelCount: Int
    public let avatarImage: AvatarImage
    
    enum CodingKeys: String, CodingKey {
        case id, slug, username, initials
        case createdAt = "created_at"
        case channelCount = "channel_count"
        case avatarImage = "avatar_image"
    }
}
