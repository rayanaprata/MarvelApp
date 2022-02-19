//
//  CoreDataMock.swift
//  MarvelAppTests
//
//  Created by C94280a on 17/01/22.
//

import Foundation
import CoreData
@testable import MarvelApp

class CoreDataMock: CoreDataProtocol {
    
    let context = DataBaseController.persistentContainer.viewContext
    var haveSavedCharacters = false
    var haveSavedOffset = false
    
    func saveInCoreData(_ models: [Result]) {
        haveSavedCharacters = true
    }
    
    func getCharactersFromCoreData() -> [Hero] {
        let hero = Hero(context: self.context)
        return Array(repeating: hero, count: 20)
    }
    
    func getNumberOfCharactersInCoreData() -> Int16 {
        return 5
    }
    
    func defineOffset(_ offsetAPI: Int16) {
        haveSavedOffset = true
    }
    
    func getOffset() -> Int16 {
        return 0
    }
    
}
