//
//  API.swift
//  MarvelApp
//
//  Created by C94280a on 26/11/21.
//

import Foundation

protocol NetworkServiceProtocol {
    func setNewCharacters(_ offset: Int) -> String
    func searchCharacter(_ nameStartsWith: String) -> String
    func setCarouselCharacter(_ serieId: Int) -> String
    func getListCharacters(urlString: String, method: HTTPMethod, success: @escaping (Character) -> Void, failure: @escaping (NetworkServiceError) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Private Properties
    let baseURL = "http://gateway.marvel.com"
    
    private let crypto: MarvelCryptoProtocol
    private let auth: AuthenticationURLProviderProtocol
    private let urlSession: URLSession
    
    init(
        crypto: MarvelCryptoProtocol,
        auth: AuthenticationURLProviderProtocol,
        urlSession: URLSession = .shared
    ) {
        self.crypto = crypto
        self.auth = auth
        self.urlSession = urlSession
    }
    
    /// Returns the URL string to EndPoint Characters with Offset - Fetches new characters.
    func setNewCharacters(_ offset: Int) -> String {
        makeURL(from: SetNewCharacterRequest(page: offset))
    }
    
    func searchCharacter(_ name: String) -> String {
        makeURL(from: SearchCharacterRequest(name: name))
    }
    
    func setCarouselCharacter(_ serieId: Int) -> String {
        makeURL(from: SetCarouselCharacterRequest(serieId: serieId))
    }
    
    private func makeURL(from baseRequest: BaseRequest) -> String {
        let auth = auth.authentication(baseRequest.path)
        let content = String(auth.ts) + auth.privateKey + auth.publicKey
        let hash = crypto.MD5(string: content)
    
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseRequest.baseUrl
        components.path = auth.path
    
        let baseRequestParams: [URLQueryItem] = baseRequest.parameters.map {
            .init(name: $0.key.rawValue, value: "\($0.value)")
        }
        
        components.queryItems?.append(contentsOf: baseRequestParams)
        components.queryItems = [
            URLQueryItem(name: "ts", value: "\(auth.ts)"),
            URLQueryItem(name: "apikey", value: auth.publicKey),
            URLQueryItem(name: "hash", value: hash)
        ]
        
        return components.url?.description ?? ""
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
