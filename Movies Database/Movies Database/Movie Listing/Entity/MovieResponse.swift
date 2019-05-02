//
//  File.swift
//  Movies Database
//
//  Created by Umair Ali on 17/04/2019.
//  Copyright © 2019 Umair Ali. All rights reserved.
//

import Foundation

struct MovieResponse: Decodable {
    
    var page: Int
    var totalPages: Int
    var results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case results
    }
    
}

struct Movie: Decodable {
    var id: Int
    var title: String?
    var posterPath: String?
    var backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
