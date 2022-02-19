//
//  Result.swift
//  MarvelApp
//
//  Created by C94280a on 26/11/21.
//

import Foundation

struct Result: Codable {
    let id: Int
    let name, resultDescription: String
    let comics, series, events: Comics
    let thumbnail: Thumbnail
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case resultDescription = "description"
        case thumbnail, comics, series, events
    }
}
