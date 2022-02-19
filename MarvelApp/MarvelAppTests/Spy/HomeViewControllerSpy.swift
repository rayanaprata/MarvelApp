//
//  HomeViewControllerSpy.swift
//  MarvelAppTests
//
//  Created by C94280a on 19/01/22.
//

import Foundation
@testable import MarvelApp

class HomeViewControllerSpy: HomeViewControllerDelegate {
    
    var reloadCarouselCalls = 0
    var reloadCharactersListCalls = 0
    var hideEmptyStateMessageCalled = false
    
    func reloadCarousel() {
        reloadCarouselCalls += 1
    }
    
    func reloadCharactersList() {
        reloadCharactersListCalls += 1
    }
    
    func hideEmptyStateMessage() {
        hideEmptyStateMessageCalled = true
    }
    
    func showEmptyStateMessageToUser(message: String) {
        
    }
    
    func showAlertToUser(message: String) {
        
    }
    
}
