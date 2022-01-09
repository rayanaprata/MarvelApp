//
//  Thumbnail.swift
//  MarvelApp
//
//  Created by C94280a on 26/11/21.
//

import Foundation

struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}
