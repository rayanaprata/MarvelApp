struct SearchCharacterRequest: BaseRequest {
    private let name: String

    init(name: String) {
        self.name = name
    }

    var parameters: [BaseRequestParameters : Any] {
        return [.nameStartsWith : name]
    }
}
