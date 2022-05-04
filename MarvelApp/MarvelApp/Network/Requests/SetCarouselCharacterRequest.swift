struct SetCarouselCharacterRequest: BaseRequest {
    private let serieId: Int

    init(serieId: Int) {
        self.serieId = serieId
    }

    var parameters: [BaseRequestParameters : AnyHashable] {
        return [.series : serieId]
    }
}
