//
//  CoreDataProtocol.swift
//  MarvelApp
//
//  Created by C94280a on 17/01/22.
//

protocol CoreDataProtocol: AnyObject {
    func saveInCoreData(_ models: [Result])
    func getCharactersFromCoreData() -> [Hero]
    func getNumberOfCharactersInCoreData() -> Int16
    func defineOffset(_ offsetAPI: Int16)
    func getOffset() -> Int16
}
