public enum BaseClass: String, Decodable, Hashable, Sendable {
    case block = "Block"
    case channel = "Channel"
    case user = "User"
}

public enum BlockClass: String, Decodable, Hashable, Sendable {
    case text = "Text"
    case image = "Image"
    case attachment = "Attachment"
    case link = "Link"
    case channel = "Channel"
    case media = "Media"
    case user = "User"
}
