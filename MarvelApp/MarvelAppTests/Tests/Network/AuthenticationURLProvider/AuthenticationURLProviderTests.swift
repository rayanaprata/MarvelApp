@testable import MarvelApp

import XCTest

class AuthenticationTests: XCTestCase {
    private let sut = AuthenticationURLProvider()

    func test_Authentication_shouldReturnCorrectAuth() {
        let expectedAuth = sut.authentication("path")
        
        XCTAssertEqual(expectedAuth.path, "path")
        XCTAssertEqual(expectedAuth.publicKey, "f5f3a3f471bb6ad75818d41835590f36")
        XCTAssertEqual(expectedAuth.privateKey, "e30eb4fd2bcade522ae467b91f20d9d8602d47ce")
    }

}
