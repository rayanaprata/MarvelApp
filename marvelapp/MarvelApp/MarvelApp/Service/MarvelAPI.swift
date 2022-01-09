//
//  MarvelAPI.swift
//  MarvelApp
//
//  Created by C94280a on 30/11/21.
//

import Foundation

protocol MarvelAPI {
    func authentication(_ path: String) -> Auth
    func setNewCharacters(_ offset: Int) -> String
    func getListCharacters(urlString: String, method: HTTPMethod, success: @escaping (Character) -> Void, failure: @escaping (APIError) -> Void)
    func MD5(string: String) -> String
}
