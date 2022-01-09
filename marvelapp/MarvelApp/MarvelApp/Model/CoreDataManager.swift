//
//  CoreDataManager.swift
//  MarvelApp
//
//  Created by C94280a on 10/12/21.
//

//import UIKit
//import CoreData
//
//class CoreDataManager {
//        
//    fileprivate func saveInCoreData(_ models: [Result]) {
//        let context = DataBaseController.persistentContainer.viewContext
//        let data = Hero(context: context)
//        
//        for character in models {
//            data.name = character.name
//            data.image = character.thumbnail.path + "/standard_xlarge." + character.thumbnail.thumbnailExtension
//            DataBaseController.saveContext()
//        }
//    }
//    
//    fileprivate func fetchData() {
//        do {
//            let characters = try DataBaseController.persistentContainer.viewContext.fetch(Hero.fetchRequest())
//        } catch {
//            print("Não foi possível trazer as informações do banco de dados")
//        }
//    }
//    
//}
