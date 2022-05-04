@testable import MarvelApp

import XCTest

final class SetCarouselCharacterRequestTests: XCTestCase {
    private let sut = SetCarouselCharacterRequest(serieId: 000)
    
    func test_parameters_shouldReturNameStartsWithparameter() {
        XCTAssertEqual(sut.parameters, [.series: 000])
    }
    
    func test_path_shouldReturnCorrectPath() {
        XCTAssertEqual(sut.path, "/v1/public/characters")
    }
    
    func test_baseURL_shoulrReturnCorrectURL() {
        XCTAssertEqual(sut.baseUrl, "gateway.marvel.com")
    }
}
