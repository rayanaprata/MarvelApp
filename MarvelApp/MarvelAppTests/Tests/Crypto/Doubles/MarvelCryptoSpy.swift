@testable import MarvelApp

final class MarvelCryptoSpy: MarvelCryptoProtocol {
    
    private(set) var MD5Called: Bool = false
    private(set) var MD5StringPassed: String?
    var MD5ToBeReturn: String = ""
    
    func MD5(string: String) -> String {
        MD5Called = true
        MD5StringPassed = string
        return MD5ToBeReturn
    }
}
