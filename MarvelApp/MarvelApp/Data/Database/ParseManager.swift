//
//  ParseManager.swift
//  MarvelApp
//
//  Created by C94280a on 13/01/22.
//

import Foundation

class ParseManager {
    
    func parseCharacters(_ characterFromCoreData: [Hero]) -> [Result] {
        var parsedCharacters: [Result] = []
        
        for character in characterFromCoreData {
            
            let inputString = character.image ?? ""
            var path: String = ""
            var ext: String = ""
            
            if !inputString.isEmpty {
                let splits = inputString.components(separatedBy: "/standard_xlarge.")
                path = splits[0]
                ext = splits[1]
            }
            
            let coreDataCharacters = Result(id: Int(character.id),
                                            name: character.name ?? "",
                                            resultDescription: character.resultDescription ?? "",
                                            comics: Comics(available: 0, collectionURI: "", items: [ComicsItem(resourceURI: "", name: character.comics ?? "")], returned: 0),
                                            series: Comics(available: 0, collectionURI: "", items: [ComicsItem(resourceURI: "", name: character.series ?? "")], returned: 0),
                                            events: Comics(available: 0, collectionURI: "", items: [ComicsItem(resourceURI: "", name: character.events ?? "")], returned: 0),
                                            thumbnail: Thumbnail(path: path, thumbnailExtension: ext))
            parsedCharacters.append(coreDataCharacters)
        }
        
        return parsedCharacters
    }
    
}
