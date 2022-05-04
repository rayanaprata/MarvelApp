@testable import MarvelApp

final class AuthenticationURLProviderSpy: AuthenticationURLProviderProtocol {
    
    private(set) var authenticationCalled: Bool = false
    private(set) var authenticationPathPassed: String?
    var authenticationToBeReturned: Auth = .fixture()
    
    func authentication(_ path: String) -> Auth {
        authenticationCalled = true
        authenticationPathPassed = path
        return authenticationToBeReturned
    }
}
