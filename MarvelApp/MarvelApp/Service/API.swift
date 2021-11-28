//
//  API.swift
//  MarvelApp
//
//  Created by C94280a on 26/11/21.
//

import Foundation
//import CommonCrypto
//import CryptoKit
//import Darwin
//import UIKit

import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class API {
    
    let baseURL = "http://gateway.marvel.com"
    
    func authentication(_ path: String) -> Auth {
        return Auth(path: path,
                        publicKey: Bundle.main.object(forInfoDictionaryKey: "publicKey") as! String,
                        privateKey: Bundle.main.object(forInfoDictionaryKey: "privateKey") as! String,
                        ts: Int(Date().timeIntervalSince1970))
    }
    
    /// Returns the URL string to EndPoint Characters - Fetches lists of characters.
    func setListCharacters() -> String {
        let auth = authentication("v1/public/characters")
        let content = String(auth.ts) + auth.privateKey + auth.publicKey
        let hash = MD5(string: content)
        return baseURL + "/" + auth.path + "?" + "ts=\(auth.ts)" + "&apikey=\(auth.publicKey)" + "&hash=\(hash)"
    }
    
//    func getListCharcters() {
//        let url = setListCharacters()
//        if let url = URL(string: url) {
//            print(url)
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data {
//                    do {
//                        let res = try JSONDecoder().decode(Character.self, from: data)
//                        print("deu bom .-.", res)
//                    } catch let error {
//                        print(error)
//                    }
//                }
//            }.resume()
//        }
//    }
    
    func getListCharacters(urlString: String, method: HTTPMethod, success: @escaping (Character) -> Void, failure: @escaping (APIError) -> Void) {
        let config: URLSessionConfiguration = .default
        let session: URLSession = URLSession(configuration: config)
        guard let url: URL = URL(string: urlString) else { return }
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "\(method)"
        let task = session.dataTask(with: urlRequest, completionHandler: { (result, URLResponse, error) in
            var statusCode: Int = 0
            if let response = urlRequest as? HTTPURLResponse {
                statusCode = response.statusCode
            }
            guard let data = result else { return }
            do {
                let decoder: JSONDecoder = JSONDecoder()
                let list = try decoder.decode(Character.self, from: data)
                
                switch statusCode {
                    case 200:
                        success(list)
                    case 404:
                        failure(APIError.notFound)
                        return
                    case 500:
                        failure(APIError.serverError)
                        return
                    default:
                        break
                }
                
            } catch {
                failure(APIError.invalidResponse)
            }
        })
        task.resume()
    }
    
}

func MD5(string: String) -> String {
    let length = Int(CC_MD5_DIGEST_LENGTH)
    let messageData = string.data(using:.utf8)!
    var digestData = Data(count: length)
    
    _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
        messageData.withUnsafeBytes { messageBytes -> UInt8 in
            if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                let messageLength = CC_LONG(messageData.count)
                CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
            }
            return 0
        }
    }
    return digestData.map { String(format: "%02hhx", $0) }.joined()
}
