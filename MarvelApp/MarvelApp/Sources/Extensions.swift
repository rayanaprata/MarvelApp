//
//  Extensions.swift
//  MarvelApp
//
//  Created by C94280a on 28/01/22.
//

import Foundation

extension String {
    var replaceSpacesAndUnaccent: String {
        let string = self.folding(options: .diacriticInsensitive, locale: .current)
        return string.replacingOccurrences(of: " ", with: "_")
    }
}
