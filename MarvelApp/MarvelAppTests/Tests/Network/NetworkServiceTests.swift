@testable import MarvelApp

import XCTest

final class NetworkServiceTests: XCTestCase {
    
    private let cryptoSpy = MarvelCryptoSpy()
    private let authSpy = AuthenticationURLProviderSpy()
    
    private lazy var sut = NetworkService(
        crypto: cryptoSpy,
        auth: authSpy
    )
    
    func test_setNewCharacters_shouldReturnCorrectURL() {
        authSpy.authenticationToBeReturned = .fixture(path: "/somePath")
        
        let expectedURL = sut.setNewCharacters(0)
        
        XCTAssertTrue(authSpy.authenticationCalled)
        XCTAssertEqual(expectedURL, "https://gateway.marvel.com/somePath?ts=0&apikey=&hash=")
    }
}
