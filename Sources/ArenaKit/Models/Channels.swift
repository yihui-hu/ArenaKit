public struct Channels: Decodable, Sendable {
    public let length: Int
    public let totalPages: Int
    public let currentPage: Int
    public let per: Int
    public let channels: [Channel]
    
    enum CodingKeys: String, CodingKey {
        case length, per, channels
        case totalPages = "total_pages"
        case currentPage = "current_page"
    }
}
