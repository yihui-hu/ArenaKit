public struct Metadata: Decodable, Hashable, Sendable {
    public let description: String?
    
    enum CodingKeys: String, CodingKey {
        case description
    }
}
