//
//  HomeViewModel.swift
//  MarvelApp
//
//  Created by C94280a on 13/01/22.
//

import Foundation

class HomeViewModel: HomeViewModelDelegate {
    
    let networkService: NetworkServiceProtocol?
    let parseManager: ParseManager
    let coreDataManager: CoreDataProtocol?
    weak var delegate: HomeViewControllerDelegate?
    
    var isLoading = false
    
    var offsetAPI: Int = 0
    var list: [Result] = []
    var carouselCharacters: [Result] = []
    var searchList: [Result] = []
    var listCharacters: [Result] = []
    
    let urlImageNotAvailable = "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available/standard_xlarge.jpg"
    
    init(networkService: NetworkServiceProtocol, coreDataManager: CoreDataProtocol, parseManager: ParseManager) {
        self.networkService = networkService
        self.coreDataManager = coreDataManager
        self.parseManager = parseManager
    }
    
    func loadData() {
        if InternetConnectionManager.isConnectedToNetwork() {
            getCarouselCharacters()
            getCharacters()
        } else {
            guard let coreData = self.coreDataManager else { return }
            let persistedCharacters = coreData.getCharactersFromCoreData()
            if !persistedCharacters.isEmpty {
                carouselCharacters = parseManager.parseCharacters(Array(persistedCharacters.prefix(5)))
                listCharacters = parseManager.parseCharacters(Array(persistedCharacters.suffix(from: 5)))
            }
        }
    }
    
    func validateInternetConnection() {
        if !InternetConnectionManager.isConnectedToNetwork() {
            self.delegate?.showAlertToUser(message: "Please check your internet connection")
        }
    }
    
    func getCarouselCharacters() {
        guard let api = self.networkService else { return }
        let serieAvengersId = 17318
        let url = api.setCarouselCharacter(serieAvengersId)
        api.getListCharacters(urlString: url, method: .GET) { charactersReturn in
            self.carouselCharacters = Array(charactersReturn.data.results[2...6])
            self.delegate?.reloadCarousel()
        } failure: { error in
            self.apiReturnedError(error)
        }
    }
    
    func getCharacters() {
        if !isLoading {
            isLoading = true
            guard let api = self.networkService else { return }
            let url = api.setNewCharacters(self.offsetAPI)
            api.getListCharacters(urlString: url, method: .GET) { charactersReturn in
                self.listCharacters.append(contentsOf: charactersReturn.data.results)
                self.searchList = self.listCharacters
                self.list = self.listCharacters

                self.delegate?.reloadCharactersList()
                
                self.offsetAPI = charactersReturn.data.offset + charactersReturn.data.count
                
                guard let coreData = self.coreDataManager else { return }
                if self.offsetAPI > coreData.getOffset() {
                    coreData.saveInCoreData(charactersReturn.data.results)
                    let newOffset = Int16(self.offsetAPI)
                    coreData.defineOffset(newOffset)
                }
                
                self.isLoading = false
            } failure: { error in
                self.apiReturnedError(error)
            }
        }
    }
    
    func getSearchCharacters(_ startsWith: String) {
        guard let api = networkService else { return }
        let url = api.searchCharacter(startsWith)
        
        api.getListCharacters(urlString: url, method: .GET) { returnedCharacters in
            
            self.listCharacters.append(contentsOf: returnedCharacters.data.results)
            self.searchList = self.listCharacters
            self.listCharacters = self.searchList.filter({ $0.name.hasPrefix(startsWith) })
            
            DispatchQueue.main.async {
                if self.listCharacters.isEmpty {
                    self.delegate?.showEmptyStateMessageToUser(message: """
                                    We haven't found any characters
                                    named \(startsWith).
                                    """)
                }
            }
            
            self.delegate?.reloadCharactersList()
        } failure: { error in
            self.apiReturnedError(error)
        }
        
    }
    
    func apiReturnedError(_ error: NetworkServiceError) {
        switch error {
        case .emptyArray:
            self.delegate?.showAlertToUser(message: "Unable to show Characters")
        case .notFound:
            self.delegate?.showAlertToUser(message: "Character data not found")
        default:
            break;
        }
    }
    
}
