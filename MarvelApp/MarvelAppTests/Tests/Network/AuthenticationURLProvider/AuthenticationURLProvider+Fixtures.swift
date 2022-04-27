@testable import MarvelApp

extension Auth {

    static func fixture(
        path: String = "",
        publicKey: String = "",
        privateKey: String = "",
        ts: Int = 0
    ) -> Self {
        .init(
            path: path,
            publicKey: publicKey,
            privateKey: privateKey,
            ts: ts
        )
    }
}
