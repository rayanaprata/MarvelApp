//
//  NetworkServiceMock.swift
//  MarvelAppTests
//
//  Created by C94280a on 30/11/21.
//

import Foundation
@testable import MarvelApp

class NetworkServiceSpy: NetworkServiceProtocol {
    
    var apiCalls = 0
    var executeCalled = false
    var inputRequest: String?
    
    func authentication(_ path: String) -> Auth {
        return Auth(path: "", publicKey: "", privateKey: "", ts: 0)
    }
    
    func setNewCharacters(_ offset: Int) -> String {
        return ""
    }
    
    func searchCharacter(_ nameStartsWith: String) -> String {
        return ""
    }
    
    func setCarouselCharacter(_ serieId: Int) -> String {
        return ""
    }
    
    func getListCharacters(urlString: String, method: HTTPMethod, success: @escaping (Character) -> Void, failure: @escaping (NetworkServiceError) -> Void) {
        apiCalls += 1
        executeCalled = true
        inputRequest = urlString
        
        guard let bundle = Bundle(identifier: "rayanaprata.MarvelAppTests") else { return }
        guard let url = bundle.url(forResource: "response", withExtension: "json") else { return }
        guard let result = try? Data(contentsOf: url) else { return }

        do {
            let data = try JSONDecoder().decode(Character.self, from: result)
            success(data)
        } catch {
            print("error")
        }
    }
    
    func MD5(string: String) -> String {
        return ""
    }
    
}

class NetworkErrorServiceMock: NetworkServiceProtocol {
    
    func authentication(_ path: String) -> Auth {
        return Auth(path: "", publicKey: "", privateKey: "", ts: 0)
    }
    
    func setNewCharacters(_ offset: Int) -> String {
        return ""
    }
    
    func searchCharacter(_ nameStartsWith: String) -> String {
        return ""
    }
    
    func setCarouselCharacter(_ serieId: Int) -> String {
        return ""
    }
    
    func getListCharacters(urlString: String, method: HTTPMethod, success: @escaping (Character) -> Void, failure: @escaping (NetworkServiceError) -> Void) {
        failure(NetworkServiceError.decodeFailed)
    }
    
    func MD5(string: String) -> String {
        return ""
    }
    
    
}
