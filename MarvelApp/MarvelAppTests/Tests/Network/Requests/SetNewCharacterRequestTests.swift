@testable import MarvelApp

import XCTest

final class SetNewCharacterRequestTests: XCTestCase {
    private let sut = SetNewCharacterRequest(page: 0)
    
    func test_parameters_shouldReturnOffsetParameterWithCorrectPage() {
        XCTAssertEqual(sut.parameters, [.offset: 0])
    }
    
    func test_path_shouldReturnCorrectPath() {
        XCTAssertEqual(sut.path, "/v1/public/characters")
    }
    
    func test_baseURL_shoulrReturnCorrectURL() {
        XCTAssertEqual(sut.baseUrl, "gateway.marvel.com")
    }
}
