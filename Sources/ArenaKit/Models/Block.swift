public struct Block: Decodable, Hashable, Sendable {
    public let id: Int
    public let title: String?
    public let description: String?
    public let status: ChannelStatus?
    public let image: BlockImage?
    public let source: BlockSource?
    public let embed: BlockEmbed?
    public let content: String?
    public let attachment: Attachment?
    public let baseClass: BaseClass?
    public let blockClass: BlockClass?
    public let user: User?
    public let length: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, status, image, content, attachment, source, embed, user, length
        case baseClass = "base_class"
        case blockClass = "class"
    }
}

public struct BlockImage: Decodable, Hashable, Sendable {
    public let filename: String
    public let contentType: String
    public let thumb: BlockImageData
    public let square: BlockImageData
    public let display: BlockImageData
    public let large: BlockImageData
    public let original: BlockImageData
    
    enum CodingKeys: String, CodingKey {
        case filename
        case contentType = "content_type"
        case thumb
        case square
        case display
        case large
        case original
    }
}

public struct BlockSource: Decodable, Hashable, Sendable {
    public let url: String
    public let title: String?
}

public struct BlockEmbed: Decodable, Hashable, Sendable {
    public let url: String?
    public let type: String
    public let html: String
}

public struct BlockImageData: Decodable, Hashable, Sendable {
    public let url: String
    public let fileSizeDisplay: String?
    
    enum CodingKeys: String, CodingKey {
        case url
        case fileSizeDisplay = "file_size_display"
    }
}

public struct Attachment: Decodable, Hashable, Sendable {
    public let url: String
    public let fileName: String
    public let fileExtension: String
    public let fileSizeDisplay: String
    
    enum CodingKeys: String, CodingKey {
        case url
        case fileName = "file_name"
        case fileExtension = "extension"
        case fileSizeDisplay = "file_size_display"
    }
}

public struct Source: Decodable, Hashable, Sendable {
    public let url: String
    public let title: String
}
