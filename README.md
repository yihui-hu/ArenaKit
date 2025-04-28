## Are.na API Client

Unofficial Are.na API client for Swift.

This Swift package provides a client for interacting with the Are.na API. It allows you to authenticate, fetch user data, and manage channels and blocks.

> [!IMPORTANT]  
> This package is still work-in-progress, only implementing a subset of the official Are.na API functionality.

### Installation

You can add this package to your project using Swift Package Manager. Add the following line to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/yihui-hu/ArenaKit.git", from: "1.0.0")
```

### Setup

To use the `ArenaAPIClient`, you need to configure it with your Are.na API credentials. You can do this in your app's launch code:

```swift
import ArenaKit

let config = ArenaAPIConfig(
    clientId: "YOUR_CLIENT_ID", 
    clientSecret: "YOUR_CLIENT_SECRET", 
    redirectScheme: "YOUR_REDIRECT_SCHEME"
)

ArenaAPIClient.setup(config: config)
```

### Usage

#### Authentication

To authenticate and obtain an access token, you can use the `exchangeCode` method:

```swift
let code = "AUTHORIZATION_CODE_FROM_OAUTH"

do {
    let token = try await ArenaAPIClient.shared.exchangeCode(code)
    print("Access Token: \(token.access_token)")
} catch {
    print("Error exchanging code: \(error)")
}
```

#### Fetching User Data

You can fetch the authenticated user's profile using:

```swift
do {
    let user = try await ArenaAPIClient.shared.getCurrentUser()
    print("User: \(user.username)")
} catch {
    print("Error fetching user: \(error)")
}
```

#### Managing Channels

To fetch channels for a specific user:

```swift
do {
    let channels = try await ArenaAPIClient.shared.getUserChannels(userId: user.id)
    print("Channels: \(channels.channels)")
} catch {
    print("Error fetching channels: \(error)")
}
```

### Example

Here is a simple example of how to use the `ArenaAPIClient`:

```swift
import ArenaKit

func main() async {
    let config = ArenaAPIConfig(
        clientId: "YOUR_CLIENT_ID", 
        clientSecret: "YOUR_CLIENT_SECRET", 
        redirectScheme: "YOUR_REDIRECT_SCHEME"
    )
    
    ArenaAPIClient.setup(config: config)

    do {
        let user = try await ArenaAPIClient.shared.getCurrentUser()
        print("Authenticated as: \(user.username)")
    } catch {
        print("Failed to fetch user: \(error)")
    }
}

Task {
    await main()
}
```

### License

This project is licensed under the MIT License. See the LICENSE file for details.
