@testable import MarvelApp

import XCTest

final class MarvelCryptoTests: XCTestCase {
    private let sut = MarvelCrypto()

    func test_MD5_shouldReturnCorrectString() {
        let expectedResult = sut.MD5(string: "Test")
        
        XCTAssertNotEqual(expectedResult, "Test")
        XCTAssertEqual(expectedResult, "0cbc6611f5540bd0809a388dc95a615b")
    }
}
