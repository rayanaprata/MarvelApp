struct SetNewCharacterRequest: BaseRequest {
    private let page: Int

    init(page: Int) {
        self.page = page
    }

    var parameters: [BaseRequestParameters: AnyHashable] {
        return [.offset: page]
    }
}
