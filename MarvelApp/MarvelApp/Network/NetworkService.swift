//
//  API.swift
//  MarvelApp
//
//  Created by C94280a on 26/11/21.
//

import Foundation

class NetworkService: NetworkServiceProtocol {
    
    let baseURL = "http://gateway.marvel.com"
    
    // MARK: - Private Properties
    
    private let crypto: MarvelCryptoProtocol
    
    init(crypto: MarvelCryptoProtocol) {
        self.crypto = crypto
    }
    
    func authentication(_ path: String) -> Auth {
        return Auth(path: path,
                    publicKey: Bundle.main.object(forInfoDictionaryKey: "publicKey") as! String,
                    privateKey: Bundle.main.object(forInfoDictionaryKey: "privateKey") as! String,
                    ts: Int(Date().timeIntervalSince1970))
    }
    
    /// Returns the URL string to EndPoint Characters with Offset - Fetches new characters.
    func setNewCharacters(_ offset: Int) -> String {
        let auth = authentication("v1/public/characters")
        let content = String(auth.ts) + auth.privateKey + auth.publicKey
        let hash = crypto.MD5(string: content)
        return baseURL + "/" + auth.path + "?" + "offset=\(offset)" + "&ts=\(auth.ts)" + "&apikey=\(auth.publicKey)" + "&hash=\(hash)"
    }
    
    func searchCharacter(_ nameStartsWith: String) -> String {
        let auth = authentication("v1/public/characters")
        let content = String(auth.ts) + auth.privateKey + auth.publicKey
        let hash = crypto.MD5(string: content)
        return baseURL + "/" + auth.path + "?" + "nameStartsWith=\(nameStartsWith)" + "&ts=\(auth.ts)" + "&apikey=\(auth.publicKey)" + "&hash=\(hash)"
    }
    
    func setCarouselCharacter(_ serieId: Int) -> String {
        let auth = authentication("v1/public/characters")
        let content = String(auth.ts) + auth.privateKey + auth.publicKey
        let hash = crypto.MD5(string: content)
        return baseURL + "/" + auth.path + "?" + "series=\(serieId)" + "&ts=\(auth.ts)" + "&apikey=\(auth.publicKey)" + "&hash=\(hash)"
    }
    
    func getListCharacters(urlString: String, method: HTTPMethod, success: @escaping (Character) -> Void, failure: @escaping (NetworkServiceError) -> Void) {
        let config: URLSessionConfiguration = .default
        let session: URLSession = URLSession(configuration: config)
        guard let url: URL = URL(string: urlString) else { return }
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "\(method)"
        let task = session.dataTask(with: urlRequest, completionHandler: { (result, URLResponse, error) in
            guard let data = result else { return }
            do {
                let decoder: JSONDecoder = JSONDecoder()
                let list = try decoder.decode(Character.self, from: data)
                let statusCode = list.code
                switch statusCode {
                case 200:
                    success(list)
                    return
                case 404:
                    failure(NetworkServiceError.notFound)
                    return
                case 500:
                    failure(NetworkServiceError.serverError)
                    return
                default:
                    break
                }
            } catch {
                failure(NetworkServiceError.invalidResponse)
            }
        })
        task.resume()
    }    
}
