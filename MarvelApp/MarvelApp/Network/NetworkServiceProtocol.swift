//
//  MarvelAPI.swift
//  MarvelApp
//
//  Created by C94280a on 30/11/21.
//

protocol NetworkServiceProtocol {
    func authentication(_ path: String) -> Auth
    func setNewCharacters(_ offset: Int) -> String
    func searchCharacter(_ nameStartsWith: String) -> String
    func setCarouselCharacter(_ serieId: Int) -> String
    func getListCharacters(urlString: String, method: HTTPMethod, success: @escaping (Character) -> Void, failure: @escaping (NetworkServiceError) -> Void)
}
