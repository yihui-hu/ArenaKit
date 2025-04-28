import UIKit

/// Configuration for the Are.na API client.
///
public struct ArenaAPIConfig: Sendable {
    public let clientId: String
    public let clientSecret: String
    public let redirectScheme: String
    public let baseURL: URL = URL(string: "https://api.are.na")!
    public let devURL: URL = URL(string: "https://dev.are.na")!
    
    /// - Parameters:
    ///   - clientId: Your Are.na OAuth client ID.
    ///   - clientSecret: Your Are.na OAuth client secret.
    ///   - redirectScheme: The URL scheme used for OAuth callbacks (e.g. "myapp").
    ///
    public init(
        clientId: String,
        clientSecret: String,
        redirectScheme: String
    ) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectScheme = redirectScheme
    }
    
    /// Constructs the full redirect URI (e.g. "myapp://").
    ///
    public var redirectURI: String { "\(redirectScheme)://" }
}
