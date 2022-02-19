//
//  DetailsViewModel.swift
//  MarvelApp
//
//  Created by C94280a on 13/01/22.
//

import Foundation

protocol DetailsViewModelProtocol: AnyObject {
    func validatesAndConcatenatesDetailsScreenInformation()
}

class DetailsViewModel {
    
    weak var view: DetailsViewController?
    var characterTouch: Result
    let urlImageNotAvailable = "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available/standard_xlarge.jpg"
    
    init(character: Result) {
        self.characterTouch = character
    }
    
}

extension DetailsViewModel: DetailsViewModelProtocol {
    
    func validatesAndConcatenatesDetailsScreenInformation() {
        if characterTouch.resultDescription != "" {
            view?.labelDescription.text = characterTouch.resultDescription
        } else {
            view?.labelDescription.text = "There are no descriptions of this character!"
        }
        
        for item in characterTouch.comics.items {
            view?.labelComics.text! += item.name + "\n"
        }
        
        if characterTouch.comics.available == 0 {
            view?.labelComics.text = "No comic info featuring this character!"
        }
        
        for item in characterTouch.series.items {
            view?.labelSeries.text! += item.name + "\n"
        }
        
        if characterTouch.series.available == 0 {
            view?.labelSeries.text = "No series info featuring this character!"
        }
        
        for item in characterTouch.events.items {
            view?.labelEvents.text! += item.name + "\n"
        }
        
        if characterTouch.events.available == 0 {
            view?.labelEvents.text = "No events info featuring this character!"
        }
    }
    
}
