import Foundation

/// Supported HTTP methods.
///
private enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

/// Main Are.na API client.
///
public actor ArenaAPIClient {
    /// Shared singleton instance. Set when first initialized.
    public static private(set) var shared: ArenaAPIClient!
    
    private let config: ArenaAPIConfig
    private var storage: ArenaAuthStorage
    private let session: URLSession
    
    /// URL to open in a browser or WebView to start OAuth.
    public nonisolated let authorizationURL: URL
    
    /// Configure the shared singleton. Call once at app launch.
    /// - Parameters:
    ///   - config: ArenaAPIConfig instance (must be Sendable).
    ///   - storage: Token storage (defaults to UserDefaultsAuthStorage).
    ///   - session: URLSession (defaults to shared).
    public static func setup(
        config: ArenaAPIConfig,
        storage: ArenaAuthStorage = UserDefaultsAuthStorage(),
        session: URLSession = .shared
    ) {
        shared = ArenaAPIClient(config: config, storage: storage, session: session)
    }
    
    /// Private initializer for the API client. Use `setup(...)` instead.
    ///
    /// - Parameters:
    ///   - config: ArenaAPIConfig instance.
    ///   - storage: Token storage (defaults to UserDefaultsAuthStorage).
    ///   - session: URLSession (defaults to shared).
    ///
    private init(
        config: ArenaAPIConfig,
        storage: ArenaAuthStorage,
        session: URLSession
    ) {
        self.config = config
        self.storage = storage
        self.session = session
        
        // Precompute OAuth authorization URL
        var comp = URLComponents(url: config.devURL, resolvingAgainstBaseURL: true)!
        comp.path = "/oauth/authorize"
        comp.queryItems = [
            .init(name: "client_id",    value: config.clientId),
            .init(name: "redirect_uri", value: config.redirectURI),
            .init(name: "response_type",value: "code")
        ]
        self.authorizationURL = comp.url!
    }
    
    /// Exchange an OAuth code for an access token and store it.
    ///
    @discardableResult
    public func exchangeCode(_ code: String) async throws -> AuthToken {
        let token: AuthToken = try await performRequest(
            baseUrl: config.devURL,
            path: "/oauth/token",
            method: .post,
            queryItems: [
                .init(name: "client_id",     value: config.clientId),
                .init(name: "client_secret", value: config.clientSecret),
                .init(name: "code",          value: code),
                .init(name: "grant_type",    value: "authorization_code"),
                .init(name: "redirect_uri",  value: config.redirectURI)
            ]
        )
        
        // Save access token to storage
        storage.accessToken = token.access_token
        
        return token
    }

    /// Clear any stored token.
    ///
    public func signOut() {
        storage.clear()
    }

    /// Thin wrapper function that performs API request via URLSession.
    ///
    private func performRequest<T: Decodable>(
        baseUrl: URL? = nil,
        path: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem]? = nil
    ) async throws -> T {
        // Build endpoint url with queryItems if needed
        var urlComponents = URLComponents(url: baseUrl ?? config.baseURL, resolvingAgainstBaseURL: true)!
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { throw APIError.invalidURL }

        // Build URLRequest with endpoint url and authorization token
        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue
        if let token = storage.accessToken {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await session.data(for: req)
        guard let http = response as? HTTPURLResponse else {
            throw APIError.httpError(status: (response as? HTTPURLResponse)?.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    public enum APIError: Error {
        case httpError(status: Int?)
        case invalidURL
        case decodingError(Error)
    }
}

/// Extension to store all available endpoints.
///
extension ArenaAPIClient {
    /// Fetch the authenticated user's profile.
    public func getCurrentUser() async throws -> User {
        try await performRequest(path: "/v2/me")
    }

    /// Fetch channels for a given user.
    public func getUserChannels(
        userId: Int,
        page: Int = 1
    ) async throws -> Channels {
        try await performRequest(
            path: "/v2/users/\(userId)/channels",
            queryItems: [.init(name: "page", value: "\(page)")]
        )
    }

    /// Fetch a single channel by ID.
    public func getChannel(id: Int) async throws -> Channel {
        try await performRequest(path: "/v2/channels/\(id)")
    }

    /// Fetch contents (blocks) of a channel.
    public func getChannelContents(
        channelId: Int,
        page: Int = 1,
        sort: Sort = .position,
        direction: Direction = .desc
    ) async throws -> ChannelContents {
        try await performRequest(
            path: "/v2/channels/\(channelId)/contents",
            queryItems: [
                .init(name: "page", value: "\(page)"),
                .init(name: "sort", value: "\(sort)"),
                .init(name: "direction", value: "\(direction)")
            ]
        )
    }
    
    public func getChannelThumbnails(
        channelId: Int
    ) async throws -> ChannelContents {
        try await performRequest(
            path: "/v2/channels/\(channelId)/thumb"
        )
    }

    /// Search channels by term.
    public func searchChannels(
        query: String,
        page: Int = 1
    ) async throws -> Channels {
        try await performRequest(
            path: "/v2/search/channels",
            queryItems: [
                .init(name: "q", value: query),
                .init(name: "page", value: "\(page)")
            ]
        )
    }
}
