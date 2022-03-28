//
//  Authentication.swift
//  MarvelApp
//
//  Created by Rayana Prata Neves on 23/03/22.
//

import Foundation

protocol AuthenticationURLProviderProtocol {
    func authentication(_ path: String) -> Auth
}

class AuthenticationURLProvider: AuthenticationURLProviderProtocol {
    
    func authentication(_ path: String) -> Auth {
        return Auth(path: path,
                    publicKey: Bundle.main.object(forInfoDictionaryKey: "publicKey") as! String,
                    privateKey: Bundle.main.object(forInfoDictionaryKey: "privateKey") as! String,
                    ts: Int(Date().timeIntervalSince1970))
    }
    
}
