import UIKit

/// Protocol abstracting token persistence.
///
public protocol ArenaAuthStorage: Sendable {
    var accessToken: String? { get set }
    func clear()
}

/// Default UserDefaults-based token storage.
///
public final class UserDefaultsAuthStorage: ArenaAuthStorage, @unchecked Sendable {
    private let defaults: UserDefaults
    private let tokenKey = "arena_access_token"
    
    public init(suiteName: String? = nil) {
        if let name = suiteName {
            self.defaults = UserDefaults(suiteName: name) ?? .standard
        } else {
            self.defaults = .standard
        }
    }
    
    public var accessToken: String? {
        get { defaults.string(forKey: tokenKey) }
        set {
            if let value = newValue {
                defaults.set(value, forKey: tokenKey)
            } else {
                defaults.removeObject(forKey: tokenKey)
            }
        }
    }
    
    public func clear() {
        defaults.removeObject(forKey: tokenKey)
    }
}
