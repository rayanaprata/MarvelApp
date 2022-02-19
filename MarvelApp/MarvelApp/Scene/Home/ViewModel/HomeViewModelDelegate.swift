//
//  HomeViewModelProtocol.swift
//  MarvelApp
//
//  Created by C94280a on 14/01/22.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func loadData()
    func validateInternetConnection()
    func getCarouselCharacters()
    func getCharacters()
    func getSearchCharacters(_ startsWith: String)
    func apiReturnedError(_ error: NetworkServiceError)
}
