public enum ChannelStatus: String, Decodable, Sendable {
    case open = "open"
    case closed = "closed"
    case `private` = "private"
    case `public` = "public"
}

public struct Channel: Decodable, Identifiable, Hashable, Sendable {
    public static func == (lhs: Channel, rhs: Channel) -> Bool {
        lhs.id == rhs.id
    }
    
    public let id: Int
    public let title: String
    public let slug: String
    public let status: ChannelStatus?
    public let length: Int
    public let contents: [Block]?
    public let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case slug
        case status
        case length
        case contents
        case user
    }
}
