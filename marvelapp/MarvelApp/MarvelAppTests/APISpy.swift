//
//  APISpy.swift
//  MarvelAppTests
//
//  Created by C94280a on 30/11/21.
//

import Foundation
@testable import MarvelApp

class APISpy: MarvelAPI {
    
    var apiCalls = 0
    var executeCalled = false
    var inputRequest: String?
    
    func authentication(_ path: String) -> Auth {
        return Auth(path: "", publicKey: "", privateKey: "", ts: 0)
    }
    
    func setNewCharacters(_ offset: Int) -> String {
        return ""
    }
    
    func getListCharacters(urlString: String, method: HTTPMethod, success: @escaping (Character) -> Void, failure: @escaping (APIError) -> Void) {
        apiCalls += 1
        executeCalled = true
        inputRequest = urlString
    }
    
    func MD5(string: String) -> String {
        return ""
    }
    
}
