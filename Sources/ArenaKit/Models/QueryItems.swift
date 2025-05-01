public enum Sort: String, Hashable, Decodable, Sendable {
    case position = "position"
}

public enum Direction: String, Hashable, Decodable, Sendable {
    case asc = "asc"
    case desc = "desc"
}
