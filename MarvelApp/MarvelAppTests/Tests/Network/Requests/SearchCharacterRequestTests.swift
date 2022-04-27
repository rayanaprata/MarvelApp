@testable import MarvelApp

import XCTest

final class SearchCharacterRequestTests: XCTestCase {
    private let sut = SearchCharacterRequest(name: "test")
    
    func test_parameters_shouldReturNameStartsWithparameter() {
        XCTAssertEqual(sut.parameters, [.nameStartsWith: "test"])
    }
    
    func test_path_shouldReturnCorrectPath() {
        XCTAssertEqual(sut.path, "/v1/public/characters")
    }
    
    func test_baseURL_shoulrReturnCorrectURL() {
        XCTAssertEqual(sut.baseUrl, "gateway.marvel.com")
    }
}
