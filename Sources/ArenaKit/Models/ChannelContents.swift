public struct ChannelContents: Decodable, Hashable, Sendable {
    public let contents: [Block]
    
    enum CodingKeys: String, CodingKey {
        case contents
    }
}
