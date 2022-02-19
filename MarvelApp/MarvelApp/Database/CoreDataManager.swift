//
//  CoreDataManager.swift
//  MarvelApp
//
//  Created by C94280a on 13/01/22.
//

import Foundation
import CoreData

class CoreDataManager: CoreDataProtocol {

    let context = DataBaseController.persistentContainer.viewContext
    
    /// Save model in CoreData
    func saveInCoreData(_ models: [Result]) {
        
        let currentCharacters = getCharactersFromCoreData()
        let currentCharactersIds: [Int]
        currentCharactersIds = currentCharacters.map{ Int($0.id) }
        
        for character in models {
            
            if !currentCharactersIds.contains(character.id) {
                let data = Hero(context: context)
                
                data.id = Int64(character.id)
                data.name = character.name
                data.image = character.thumbnail.path + "/standard_xlarge." + character.thumbnail.thumbnailExtension
                data.resultDescription = character.resultDescription
                
                var concatComics = ""
                var concatEvents = ""
                var concatSeries = ""
                
                for comicsItem in character.comics.items {
                    concatComics += comicsItem.name + "\n"
                }
                
                for eventsItem in character.events.items {
                    concatEvents += eventsItem.name + "\n"
                }
                
                for seriesItem in character.series.items {
                    concatSeries += seriesItem.name + "\n"
                }
                
                data.comics = concatComics
                data.events = concatEvents
                data.series = concatSeries
            }
            
        }
        DataBaseController.saveContext()
    }

    /// Return the characters of CoreData
    func getCharactersFromCoreData() -> [Hero] {
        do {
            let data = try DataBaseController.persistentContainer.viewContext.fetch(Hero.fetchRequest())
            return data
        } catch {
            print("It was not possible to bring the character information from the database")
            return []
        }
    }
    
    /// Return the number of characters in CoreData
    func getNumberOfCharactersInCoreData() -> Int16 {
        do {
            let data = try DataBaseController.persistentContainer.viewContext.fetch(Hero.fetchRequest())
            return Int16(data.count)
        } catch {
            print("It was not possible to bring the number of characters from the database.")
            return 0
        }
    }
    
    /// Save offset in CoreData
    func defineOffset(_ offsetAPI: Int16) {
        let entityOffset = EntityOffset(context: context)
        entityOffset.offset = offsetAPI
        DataBaseController.saveContext()
    }
    
    /// Return the offset of CoreData
    func getOffset() -> Int16 {
        var offset: Int16 = 0
        do {
            let result = try DataBaseController.persistentContainer.viewContext.fetch(EntityOffset.fetchRequest())
            offset = result.last?.offset ?? 0
        } catch {
            print("It was not possible to bring the offset information from the database.")
        }
        return offset
    }

}
