//
//  Data.swift
//  MarvelApp
//
//  Created by C94280a on 26/11/21.
//

import Foundation

struct DataClass: Codable {
    let offset, limit, total, count: Int
    let results: [Result]
}
