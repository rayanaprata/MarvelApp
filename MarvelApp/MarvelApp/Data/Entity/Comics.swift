//
//  Comics.swift
//  MarvelApp
//
//  Created by C94280a on 29/11/21.
//

import Foundation

struct Comics: Codable {
    let available: Int
    let collectionURI: String
    let items: [ComicsItem]
    let returned: Int
}
