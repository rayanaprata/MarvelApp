protocol BaseRequest {
    var baseUrl: String { get }
    var path: String { get }
    var parameters: [BaseRequestParameters: Any] { get }
}

/// This extension is used to provide a default value for anyone who conforms with it
extension BaseRequest {
    var baseUrl: String {
        "gateway.marvel.com"
    }
    
    var path: String {
        "/v1/public/characters"
    }
}

enum BaseRequestParameters: String {
    case offset
    case nameStartsWith
    case series
}
